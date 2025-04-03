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

If you can't resolve offenses, regenerate `rubocop_todo.yml`:

```bash
rubocop --auto-gen-config --auto-gen-only-exclude --exclude-limit 10000
```

To update default Rubocop rules, open an MR in the `upennlib-rubocop` project.
