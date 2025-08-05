# Global Build Args ----------------------------------
# Default project root
ARG PROJECT_ROOT=/home/app

# Default Bundle home
ARG BUNDLE_HOME=${PROJECT_ROOT}/vendor/bundle

# Default Image name
ARG IMAGE_NAME=ruby

# Default Image tag
ARG IMAGE_TAG=3.4.2-slim-bookworm

# Default Node version
ARG NODE_VERSION=24.5.0

# Default Rails env
ARG RAILS_ENV=development

# Default Ruby
ARG RUBY_MAJOR=3.4.0

# Default Yarn version
ARG YARN_VERSION=1.22.22

# Build Stage ----------------------------------------
FROM ${IMAGE_NAME}:${IMAGE_TAG} AS base

ARG BUNDLE_HOME
ARG NODE_VERSION
ARG PROJECT_ROOT
ARG RAILS_ENV
ARG RUBY_MAJOR
ARG YARN_VERSION

ENV BUNDLE_HOME=${BUNDLE_HOME}
ENV PROJECT_ROOT=${PROJECT_ROOT}
ENV RAILS_ENV=${RAILS_ENV}
ENV RUBY_MAJOR=${RUBY_MAJOR}

ENV BUNDLE_APP_CONFIG="${PROJECT_ROOT}/.bundle"
ENV GEM_HOME="${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bundle"
ENV PATH="${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bin:$PATH"

WORKDIR ${PROJECT_ROOT}

RUN apt-get update && apt-get install --no-install-recommends -y \
      apt-transport-https \
      ca-certificates \
      build-essential \
      curl \
      git \
      libpq-dev \
      libyaml-dev \
      postgresql \
      postgresql-contrib && \
    rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION%%.*}.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g "yarn@${YARN_VERSION}" && \
    rm -rf /var/lib/apt/lists/*

COPY package.json yarn.lock ${PROJECT_ROOT}
RUN yarn install --frozen-lockfile

COPY Gemfile* ./

RUN bundle config path ${BUNDLE_HOME} && \
    set -eux; \
    if [ "${RAILS_ENV}" = "development" ]; then \
    bundle config set with "development:test:assets"; \
    else \
    bundle config set without "development:test:assets"; \
    fi

RUN --mount=type=secret,id=sidekiq_pro_credentials \
    bundle config set --local gems.contribsys.com $(cat /run/secrets/sidekiq_pro_credentials)

RUN bundle install -j$(nproc) --retry 3 --verbose && \
    rm -rf ${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/cache/*.gem && \
    find ${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/gems/ \( -name "*.c" -o -name "*.o" \) -delete && \
    bundle exec bootsnap precompile --gemfile

COPY . ${PROJECT_ROOT}/

RUN bundle exec bootsnap precompile app/ lib/

# Development Stage ----------------------------------
FROM ${IMAGE_NAME}:${IMAGE_TAG} AS development

ARG BUNDLE_HOME
ARG NODE_VERSION
ARG PROJECT_ROOT
ARG RAILS_ENV
ARG RUBY_MAJOR
ARG YARN_VERSION

ENV BUNDLE_HOME=${BUNDLE_HOME}
ENV PROJECT_ROOT=${PROJECT_ROOT}
ENV RAILS_ENV=${RAILS_ENV}
ENV RUBY_MAJOR=${RUBY_MAJOR}

ENV BUNDLE_APP_CONFIG="${PROJECT_ROOT}/.bundle"
ENV GEM_HOME="${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bundle"
ENV NLS_LANG=$LANG
ENV PATH="${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bin:$PATH"
ENV RAILS_ENV=${RAILS_ENV}

WORKDIR ${PROJECT_ROOT}

RUN apt-get update && apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      gosu \
      libpq-dev \
      libyaml-dev \
      postgresql \
      postgresql-contrib \
      procps && \
    addgroup app && useradd -m -d ${PROJECT_ROOT} -s /bin/bash -g app app && \
    mkdir -p ${PROJECT_ROOT}/tmp/pids && \
    rm -rf /var/lib/apt/lists/*

COPY --chmod=755 --from=base ${PROJECT_ROOT}/docker-entrypoint.sh /usr/local/bin/
COPY --chmod=744 --chown=app:app --from=base ${PROJECT_ROOT} ${PROJECT_ROOT}

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION%%.*}.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g "yarn@${YARN_VERSION}" && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${PROJECT_ROOT}/app/assets/builds/ && \
    find ${PROJECT_ROOT} -type d -exec chmod 755 {} + && \
    chmod 744 -R ./bin && \
    chmod +x -R ${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bin/ && \
    SECRET_KEY_BASE_DUMMY=x bundle exec rails assets:precompile

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000
VOLUME ${PROJECT_ROOT}

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]


# Production Stage -----------------------------------
FROM ${IMAGE_NAME}:${IMAGE_TAG} AS production

ARG BUNDLE_HOME
ARG NODE_VERSION
ARG PROJECT_ROOT
ARG RAILS_ENV=production
ARG RUBY_MAJOR
ARG YARN_VERSION

ENV BUNDLE_HOME=${BUNDLE_HOME}
ENV PROJECT_ROOT=${PROJECT_ROOT}
ENV RAILS_ENV=${RAILS_ENV}
ENV RUBY_MAJOR=${RUBY_MAJOR}

ENV BUNDLE_APP_CONFIG="${PROJECT_ROOT}/.bundle"
ENV GEM_HOME="${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bundle"
ENV NLS_LANG=$LANG
ENV PATH="${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bin:$PATH"
ENV RAILS_ENV=${RAILS_ENV}
ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_SERVE_STATIC_FILES=true

WORKDIR ${PROJECT_ROOT}

RUN apt-get update && apt-get install --no-install-recommends -y \
      build-essential \
      curl \
      git \
      gosu \
      libpq-dev \
      libyaml-dev \
      postgresql \
      postgresql-contrib && \
    addgroup app && useradd -m -d ${PROJECT_ROOT} -s /bin/bash -g app app && \
    mkdir -p ${PROJECT_ROOT}/tmp/pids && \
  rm -rf /var/lib/apt/lists/*

COPY --chmod=755 --from=base ${PROJECT_ROOT}/docker-entrypoint.sh /usr/local/bin/
COPY --chmod=744 --chown=app:app --from=base ${PROJECT_ROOT} ${PROJECT_ROOT}

RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION%%.*}.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g "yarn@${YARN_VERSION}" && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p ${PROJECT_ROOT}/app/assets/builds/ && \
    find ${PROJECT_ROOT} -type d -exec chmod 755 {} + && \
    chmod 744 -R ./bin && \
    chmod +x -R ${BUNDLE_HOME}/ruby/${RUBY_MAJOR}/bin/ && \
    SECRET_KEY_BASE_DUMMY=x bundle exec rails assets:precompile

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3000
VOLUME ${PROJECT_ROOT}

CMD ["bundle", "exec", "puma", "-b", "tcp://0.0.0.0:3000"]
