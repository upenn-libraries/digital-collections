# Penn Libraries Digital Collections

Frontend application for discovering content in Penn Libraries Digital Collections.

## Table of Contents

1. [Local Development Environment](#local-development-environment)  
   - [Requirements](#requirements)  
   - [Starting App Services](#starting-app-services)  
   - [Developing](#developing)  
2. [Contributing](#contributing)  
   - [Running Tests](#running-tests)  
   - [Code Analysis with Rubocop](#code-analysis-with-rubocop)  

---

## Local Development Environment

### Requirements

Your development machine needs the following:

#### Ruby

Use [`rbenv`](https://github.com/rbenv/rbenv), [`asdf`](https://asdf-vm.com/), or [`mise`](https://mise.jdx.dev/) to manage Ruby versions. The required version is specified in `.ruby-version`.

To be able to install all the required gems, your `bundler` must have valid credentials to the `sidekiq-pro` gem repository. [Configure](https://bundler.io/man/bundle-config.1.html) your user-level bundler config (`~/.bundle/config`) or repository-level config (`./.bundle/config`) with the environment variable expected by Bundler:

```
BUNDLE_GEMS__CONTRIBSYS__COM=username:password
```

#### Docker Compose

[Docker Compose](https://docs.docker.com/compose/install/) is required to run application services.

- **Linux users**: Install [Docker Engine](https://docs.docker.com/engine/install/) and then the [Compose plugin](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually).  
- **Mac users**: Install [Docker Desktop](https://docs.docker.com/desktop/install/mac-install/) for an easy setup. To access full functionality, request membership in the Penn Libraries Docker Team via [the IT Helpdesk](https://ithelp.library.upenn.edu/support/home).  

### Starting App Services

Use these Rake tasks to manage app services:

```bash
# Start app services and run database migrations
rake tools:start

# Stop services
rake tools:stop

# Remove containers
rake tools:clean
```

### Developing

#### Install Dependencies

Ensure your Ruby version matches `.ruby-version`:

```bash
ruby --version
```

Then install dependencies:

```bash
bundle install
```

If you get an error when installing the `sidekiq-pro` gem, [ensure you have bundler configured](#ruby) with the proper credentials.

If there's a version mismatch, debug with:

```bash
which ruby
```

##### PostgreSQL Issues on macOS

If the `pg` gem fails due to `libpq` issues, follow [this guide](https://gist.github.com/tomholford/f38b85e2f06b3ddb9b4593e841c77c9e).

#### Start the Development Server

```bash
bundle exec rails server
```

Access the app at `http://localhost:3000`.

---

#### Sidekiq Pro Web UI

The development environment for this app exposes the Sidekiq Web UI at [http://localhost:3000/sidekiq](http://localhost:3000/sidekiq).

## Configuration/Settings
Application-wide configuration is centralized in `config/settings` and `config/settings.yml`. Access to configuration is provided via the `Settings` object instantiated by the [config](https://github.com/rubyconfig/config) gem. For example, to retrieve a value defined in the `settings.yml` file as `my_yaml_key:`, run:

```ruby
Settings.my_yaml_key
```

Environment specific configuration values should be placed in the appropriate file in the `config/settings` directory. For configuration that is the same for all environments it should be placed in `config/settings.yml`.

All configuration values, including secrets, should be accessed via the `Settings` object. Secret values should be defined in the settings files and their values set via secure means, such as the Rails encrypted credentials file or via Docker Secrets.

## Contributing

Before contributing, review the [GitLab Collaboration Workflow](https://upennlibrary.atlassian.net/wiki/spaces/DLD/pages/498073672/GitLab+Collaboration+Workflow) and [Rails Development Guidelines](https://upennlibrary.atlassian.net/wiki/spaces/DLD/pages/495616001/Ruby-on-Rails+Development+Guidelines).

### Running Tests

Ensure test coverage when adding features. Run the test suite with:

```bash
bundle exec rspec
```

### Code Analysis with Rubocop

This project follows UPenn-specific style guidelines in [upennlib-rubocop](https://gitlab.library.upenn.edu/dld/upennlib-rubocop).

Check for style violations:

```bash
bundle exec rubocop
```

If you can't resolve offenses, *please* refrain from updating the Rubocop configuration in this project. 

Instead, regenerate `rubocop_todo.yml`:

```bash
rubocop --auto-gen-config --auto-gen-only-exclude --exclude-limit 10000
```

To update default Rubocop rules, open an MR in the `upennlib-rubocop` project.
