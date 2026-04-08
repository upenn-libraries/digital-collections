# Digital Collections

See the [README](rails_app/README.md) in the Rails app for more information about the application.

We are working to support development in a new environment orchestrated by Taskfile. If there is a need, we will revive our original local Ruby and docker environment, but for now we are going to focus our efforts on this environment.

1. [Development Environment](#development-environment)
   - [Installing](#installing)
   - [Starting](#starting)
   - [Interacting with Environment](#interacting-with-environment)
   - [Interacting with Application](#interacting-with-application)
   - [Services](#services)
   - [Destroying](#destroying)

---

## Development Environment
The development environment is based on Taskfile and Docker. `task up` creates Docker-in-Docker container that runs within it the application container and any related services.

### Installing
1. Install [Taskfile](https://taskfile.dev/), via one of the supported package managers.

    **For Linux:** Use [installation instructions](https://taskfile.dev/docs/installation) for your perferred package manager.
	
    **For Mac**: Install via homebrew, `brew install go-task`.
		
2. Install Docker.

	**For Mac:** [Install Docker Desktop](https://docs.docker.com/desktop/install/mac-install/). While this is enough to get the application running, you should request membership to the Penn Libraries Docker Team license from [the IT Helpdesk](https://ithelp.library.upenn.edu/support/home) for full functionality.
	
	**For Linux:** [Install docker engine](https://docs.docker.com/engine/install/).

### Starting

1. After installing Docker and Taskfile, move into the `.dev` directory:
    ```
    cd .dev
    ```

2. Then, run a task to start up the environment:
    ```
    task up
    ```

    When you first run a task command it will pull down a series of remote taskfiles, you'll need to answer `Y` to accept the alert/s.  

    While the task runs, it will ask you for your computer password to update the `/etc/hosts` file and for your LDAP credentials to pull down secrets from Hashicorp Vault.

3. Once the environment has completed building, you'll be able to confirm the application is running by going to [https://digitalcollections-dev.library.upenn.edu/](https://digitalcollections-dev.library.upenn.edu/).

4. Move to the next sections for more details on how to interact with the environment.

### Interacting with Environment
 When the environment is running, you can run the following command to swap the docker context.
 ```
 task docker:context:use:app
 ```

After swapping the docker context, you'll be able to interact with the containers locally as if you were with in the Docker-in-Docker container. Running commands like `docker ps` will display all the containers currently running in the environment.  

When you are done you can change the context back to the default by running:
  ```
  task docker:context:use:default 
  ```

### Interacting with Application
Once your environment is set up:
1. Swap the docker context (see [Interacting with Environment](#interacting-with-environment)):
    ```
    task docker:context:use:app
    ```
2. Start a shell in the `digital_collections` app container:
    ```
    docker exec -it digital_collections_digital_collections.1.{whatever} bash
    ```
   
See application README for more information on [indexing sample records](rails_app/README.md#add-sample-records) and [testing](rails_app/README.md#running-tests-suite). 

### Services
- Rails Application
    - URL: [https://digitalcollections-dev.library.upenn.edu/](https://digitalcollections-dev.library.upenn.edu/)
- Chrome (Browserless 2)
    - URL: http://digitalcollections-dev.library.upenn.int/chrome/
- Solr
    - URL: [http://digitalcollections-dev.library.upenn.int/solr](http://digitalcollections-dev.library.upenn.int/solr)
    - Username: `admin`
    - Password: `password`

### Destroying
To destroy the environment and any data associated with it, run:
```
task destroy
```
