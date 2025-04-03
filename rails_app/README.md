# Penn Libraries Digital Collections

Font-end app for discovery of Penn Libraries Digital Collections content.

1. [Local Development Environment](#local-development-environment)
    1. [Requirements](#requirements)
    2. [Starting App Services](#starting-app-services)
    4. [Developing](#developing)
2. [Contributing](#contributing)
    1. [Running the RSpec Test Suite](#running-the-rspec-test-suite)
    2. [Code Analysis with Rubocop](#code-analysis-with-rubocop)

## Local Development Environment

### Requirements

Your development machine will need the following:

#### Ruby

I suggest installing Ruby via [`rbenv`](https://github.com/rbenv/rbenv), [`asdf`](https://asdf-vm.com/), or [`mise`](https://mise.jdx.dev/). There is
plenty of guidance available on the open web about installing and using these tools. The `.ruby-version` file in this repo explicitly define the version of Ruby to be installed.

#### Docker Compose

[Docker compose](https://docs.docker.com/compose/install/) is required to run the application services. For 🌈 linux
users 🌈 this is free and straightforward. [Install docker engine](https://docs.docker.com/engine/install/) and then
[add the compose plugin](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually).

For Mac users, the easiest and recommended way to get Docker Compose is to
[install Docker Desktop](https://docs.docker.com/desktop/install/mac-install/). While this is enough to get the
application running, you should request membership to the Penn Libraries Docker Team license
from [the IT Helpdesk](https://ithelp.library.upenn.edu/support/home) for full functionality.

### Starting App Services

Helpful Rake tasks have been created to wrap up the initialization process for the development environment.

```
# start the app docker services and run database migrations
rake tools:start

# stop docker services
rake tools:stop

# remove docker containers
rake tools:clean
```

### Developing

#### Install dependencies

Ensure your local Ruby version matches the version in `.ruby-version`:
```bash
ruby --version
```
If it does:
```bash
bundle install
```
If it doesn't, this will get you started on debugging:
```bash
which ruby
```

##### Postgres
For MacOS users the `pg` gem may fail to install with an error concerning the `libpq` library.

[Refer to this gist](https://gist.github.com/tomholford/f38b85e2f06b3ddb9b4593e841c77c9e) to address this issue.

#### Start the development server

```bash
bundle exec rails server
```

View the app at `localhost:3000`

## Contributing

In order to contribute productively while fostering the project values, familiarize yourself with the established
[Gitlab Collaboration Workflow](https://upennlibrary.atlassian.net/wiki/spaces/DLD/pages/498073672/GitLab+Collaboration+Workflow)
as well as the [Ruby on Rails Development Guidelines](https://upennlibrary.atlassian.net/wiki/spaces/DLD/pages/495616001/Ruby-on-Rails+Development+Guidelines).

### Running the RSpec Test Suite

When adding new features, be sure to consider the need for test coverage.

Run the full application test suite with:

```bash
bundle exec rspec
```

### Code Analysis with Rubocop

This application uses Rubocop to enforce Ruby and Rails style guidelines. We centralize our UPenn specific configuration in
[upennlib-rubocop](https://gitlab.library.upenn.edu/dld/upennlib-rubocop).


To check style and formatting run:
```ruby
bundle exec rubocop
```

If there are rubocop offenses that you are not able to fix please do not edit the rubocop configuration instead regenerate the `rubocop_todo.yml` using the following command:

```bash
rubocop --auto-gen-config  --auto-gen-only-exclude --exclude-limit 10000
```

To change our default Rubocop config please open an MR in the `upennlib-rubocop` project.
