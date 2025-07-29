# Penn Libraries Digital Collections

Frontend application for discovering content in Penn Libraries Digital Collections.

## Table of Contents

1. [Local Development Environment](#local-development-environment)  
   - [Requirements](#requirements)  
   - [Install Gems](#install-gems)  
   - [Starting App Services](#starting-app-services)
   - [Start the Development Server](#start-the-development-server)
   - [Add Sample Records](#add-sample-records)
2. [Configuration/Settings](#configurationsettings)
3. [Contributing](#contributing)  
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

### Install Gems

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

#### PostgreSQL Issues on macOS

If the `pg` gem fails due to `libpq` issues, follow [this guide](https://gist.github.com/tomholford/f38b85e2f06b3ddb9b4593e841c77c9e).

### Install Javascript Dependencies

To use `jsbundling-rails`, we must have `node` and `yarn` installed. It's recommended to use a version manager to install `node`, like [`nvm`](https://github.com/nvm-sh/nvm?tab=readme-ov-file#installing-and-updating), [`asdf`](https://asdf-vm.com/), or [`mise`](https://mise.jdx.dev/).

Check that node is installed:
```bash
node -v
```

Install Yarn:
```bash
npm install --global yarn
```

### Starting App Services

Use these Rake tasks to manage app services:

```bash
# Start app services and run database migrations
bundle exec rake tools:start

# Stop services
bundle exec rake tools:stop

# Remove containers
bundle exec rake tools:clean
```

### Start the Development Server

Because we're using a Javascript bundler, it's important to start the server like this:
```bash
bin/dev
```

The `Procfile` will run the following server commands:
```bash
env RUBY_DEBUG_OPEN=true bin/rails server
yarn build --watch
```

Access the app at `http://localhost:3000`.

#### Javascript Bundler Caveats

- The `@penn-libraries/web` assets cannot be pulled in via Yarn and `jsbundling-rails` - the way that the local assets (ie. footer image) get packaged in the [Stencil.js](https://stenciljs.com/docs/assets) output is a pain point that many others in the community struggle with. There isn't really a way to serve up assets from node_modules without having a build step that copies them locally. The easiest thing to do is serve it from a CDN where the asset paths can resolve. This also allows us to use the design system in this app like we would use it in other places, and that consistency is a positive.

- A slightly annoying change of removing `importmap-rails` is our loss of automatic Stimulus controller loading. Unfortunately, `importmap-rails` includes Stimulus controller eager loading, so switching to `jsbundling-rails` means that we now have to manually declare new Stimulus controllers and register them with the application. This can be automated (to a certain degree). Here's a snippet of the [docs](https://github.com/hotwired/stimulus-rails?tab=readme-ov-file#usage-with-javascript-bundler):

    > This can be done automatically using either the Stimulus generator (./bin/rails generate stimulus [controller]) or the dedicated stimulus:manifest:update task. Either will overwrite the controllers/index.js file.

### Add Sample Records
Sample records are retrieved from the Apotheca API and indexed into Solr. `rake tools:start` automatically adds sample 
records, but if you would like to reindex records or refresh the sample records run:
```sh
bundle exec rake tools:add_sample_records
```

---

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
