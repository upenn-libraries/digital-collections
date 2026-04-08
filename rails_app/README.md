# Penn Libraries Digital Collections

Frontend application for discovering content in Penn Libraries Digital Collections. 

This application is an Apotheca consumer application. Apotheca publishes content to this application and this 
application displays the content to the public.

1. [Development Environment](#development-environment)  
   - [Installation and Initialization](#installation-and-initialization)  
   - [Services](#services)  
   - [Interacting with Application](#interacting-with-application)
   - [Add Sample Records](#add-sample-records)
   - [Running Test Suite](#running-tests-suite)
2. [Javascript Bundler Caveats](#javascript-bundler-caveats)
3. [Configuration/Settings](#configurationsettings)
4. [Contributing](#contributing)  
   - [Running Tests](#running-tests)  
   - [Code Analysis with Rubocop](#code-analysis-with-rubocop)  

---

## Development Environment
### Installation and Initialization
Our local development environment uses Taskfile to set up a consistent environment with the required services. 
Please see the [root README for instructions](../README.md#development-environment) on how to install and start this 
environment.

### Services
The **Rails application** will be available at [http://digitalcollections-dev.library.upenn.edu](http://digitalcollections-dev.library.upenn.edu).

The **Sidekiq Web UI** will be available at [http://digitalcollections-dev.library.upenn.edu/sidekiq](http://digitalcollections-dev.library.upenn.edu/sidekiq).

The **Solr admin console** for will be available at [http://digitalcollections-dev.library.upenn.
int/solr/#/](http://digitalcollections-dev.library.upenn.int/solr/#/). Log-in with `admin/password`.

### Interacting with Application
After the development environment is initialized:
1. Swap docker context to see containers in development environment
   ```sh
   task docker:context:use:app
   ```
2. Start a shell in the application container
   ```sh
   docker exec -it digital_collections_digital_collections.1.{whatever} bash
   ```

### Add Sample Records
Within the application container, run the following task to add sample records. Sample records are retrieved from the 
Apotheca API and indexed into Solr. 
```sh
bundle exec rake tools:add_sample_records
```

### Running Tests Suite
Within the application container, run the test suite with:

```bash
RAILS_ENV=test bundle exec rspec
```

## Javascript Bundler Caveats

- The `@penn-libraries/web` assets cannot be pulled in via Yarn and `jsbundling-rails` - the way that the local assets (ie. footer image) get packaged in the [Stencil.js](https://stenciljs.com/docs/assets) output is a pain point that many others in the community struggle with. There isn't really a way to serve up assets from node_modules without having a build step that copies them locally. The easiest thing to do is serve it from a CDN where the asset paths can resolve. This also allows us to use the design system in this app like we would use it in other places, and that consistency is a positive.

- A slightly annoying change of removing `importmap-rails` is our loss of automatic Stimulus controller loading. Unfortunately, `importmap-rails` includes Stimulus controller eager loading, so switching to `jsbundling-rails` means that we now have to manually declare new Stimulus controllers and register them with the application. This can be automated (to a certain degree). Here's a snippet of the [docs](https://github.com/hotwired/stimulus-rails?tab=readme-ov-file#usage-with-javascript-bundler):

    > This can be done automatically using either the Stimulus generator (./bin/rails generate stimulus [controller]) or the dedicated stimulus:manifest:update task. Either will overwrite the controllers/index.js file.

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
RAILS_ENV=test bundle exec rspec
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
bundle exec rubocop --auto-gen-config --auto-gen-only-exclude --exclude-limit 10000
```

To update default Rubocop rules, open an MR in the `upennlib-rubocop` project.
