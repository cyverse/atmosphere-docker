# Atmosphere-Docker

Entire Atmosphere development environment in Docker Containers using Docker-Compose.

**Please note that this is a work in progress. It currently works to deploy a local Atmosphere setup, but more work is required to harness the full potential of Docker Compose. Create issues for any problems or feature requests.**

**Also, take a look at the open issues to see what you can expect to go wrong**


## Installing Docker
### macOS
To install Docker on macOS, follow [these instructions](https://store.docker.com/editions/community/docker-ce-desktop-mac). This includes Docker Compose.


### Ubuntu
To install Docker on Ubuntu, follow [these instructions](https://docs.docker.com/install/linux/docker-ce/ubuntu/#install-using-the-repository).
Then, install Docker Compose:
```
sudo curl -L https://github.com/docker/compose/releases/download/1.19.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```


## Getting started
1. `docker-compose build` to build all containers. This step will take a while the first time it is run, but will be quicker after that
  - Optionally change repositories and branches by modifying the `docker-compose.yml` file
  - To populate with an existing database, copy the `.sql` file to the `postgres` directory before building
1. Copy `secrets.env.example` to `secrets.env` and fill it out with the `atmosphere-docker-secrets` repository link and an SSH private key that has access to this repository
  - You can get your private key in the correct format with this command: `cat ~/.ssh/id_rsa | awk 'ORS="\\n"'`
1. `docker-compose up` to start all containers (use the `-d` option to start containers in the background)

Gracefully shut down containers with `Ctrl+c`. Press it again to kill containers.

Or kill all containers with `docker-compose kill`.

Delete all containers when you are done with `docker-compose rm`.

Delete all unattached volumes with `docker volume prune`.

**NOTE:** When the `logs/` directory is created by Docker Compose it will be owned by root so you cannot delete it without `sudo`. However, `rm -rf logs` will delete all of the files but the directory structure will remain. If you create the logs directory before running the containers, you can easily delete it.
