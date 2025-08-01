#!/bin/sh
set -eux

if [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "puma" ] || [ "$1" = "bundle" -a "$2" = "exec" -a "$3" = "sidekiq" ]; then
    if [ ! -z "${APP_UID}" ] && [ ! -z "${APP_GID}" ]; then
        usermod -u ${APP_UID} app
        groupmod -g ${APP_GID} app
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
    find . -type d -exec chown app:app {} \;

    # chown all files except keys
    find . -type f \( ! -name "*.key" \) -exec chown app:app {} \;

    # run the application as the app user
    exec gosu app "$@"
fi

exec "$@"
