# Atmosphere-Docker
Entire Atmosphere development environment in Docker Containers using Docker-Compose.

**Please note that this is a work in progress. It currently works to deploy a local Atmosphere setup, but more work is required to harness the full potential of Docker Compose. Create issues for any problems or feature requests.**

**Also, take a look at the open issues to see what you can expect to go wrong**


## Getting started
1. Clone this repository in the same directory as Troposphere, Atmosphere, and Atmosphere Ansible
    - Alternatively, modify the docker-compose file to point to your local repositories
2. `docker-compose build` to build all containers. This step will take a while the first time it is run, but will be quicker after that
    - To populate with an existing database, copy the `.sql` file to the `postgres` directory before building
3. Clone the `atmosphere-docker-secrets` repository in the same directory as this repository (not inside this repository directory)
4. `docker-compose up` to start all containers (use the `-d` option to start containers in the background)


Troposphere changes will be automatically built whenever they are made.

Atmosphere may have to restart to have all changes (`docker-compose restart atmosphere`).


### Tips
Gracefully shut down containers with `Ctrl+c`. Press it again to kill containers.

Or kill all containers with `docker-compose kill`.

Delete all containers when you are done with `docker-compose rm`.

Delete all unattached volumes with `docker volume prune`.

**NOTE:** When the `logs/` directory is created by Docker Compose it will be owned by root so you cannot delete it without `sudo`. However, `rm -rf logs` will delete all of the files but the directory structure will remain. If you create the logs directory before running the containers, you can easily delete it.
