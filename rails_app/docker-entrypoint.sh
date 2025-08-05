#!/bin/sh
set -e

if [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "puma" ] || [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "sidekiq" ]; then
    if [ ! -z "${UID}" ] && [ ! -z "${GID}" ]; then
        usermod -u ${UID} app
        groupmod -g ${GID} app
    fi

    if [ "${RAILS_ENV}" = "development" ]; then
        git config --global --add safe.directory '*'
        gem install bundler -v $(grep -A 1 "BUNDLED WITH" ${PROJECT_ROOT}/Gemfile.lock | tail -n 1 | awk '{print $1}') --verbose

        bundle config --local path ${BUNDLE_HOME}
        bundle config set --local with 'development:test:assets'
        bundle config set --local gems.contribsys.com $(cat /run/secrets/sidekiq_pro_credentials)

        bundle install -j$(nproc) --retry 3
        bundle exec bootsnap precompile --gemfile
        bundle exec bootsnap precompile app/ lib/

        if [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "puma" ]; then
          # run js hotloading in the background
          rm -fr ${PROJECT_ROOT}/node_modules
          gosu app yarn install --frozen-lockfile
          gosu app yarn build --watch=forever &
        fi
    fi

    # remove puma server.pid
    if [ -f ${PROJECT_ROOT}/tmp/pids/server.pid ]; then
        rm -f ${PROJECT_ROOT}/tmp/pids/server.pid
    fi

    # run db migrations
    if [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "puma" ]; then
        bundle exec rake db:migrate

        if [ "${RAILS_ENV}" = "development" ] || [ "${RAILS_ENV}" = "test" ]; then
            bundle exec rake db:create RAILS_ENV=test
            bundle exec rake db:migrate RAILS_ENV=test
        fi
    fi

    # chown all dirs
    find "${PROJECT_ROOT}" -type d -not \( -user "app" -a -group "app" \) -exec chown app:app {} \;

    # chown all files except keys
    find "${PROJECT_ROOT}" -type f -not \( -user "app" -a -group "app" -or -name "*.key" \) -exec chown "app:app" {} \;

    # run the service as the app user
    exec gosu app "$@"
fi

exec "$@"
