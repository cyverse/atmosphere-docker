# Atmosphere Docker
Entire Atmosphere development environment in Docker Containers using Docker-Compose.


## Getting started
1. Clone this repository in the same directory as [Troposphere](https://github.com/cyverse/troposphere), [Atmosphere](https://github.com/cyverse/atmosphere), and [Atmosphere Ansible](https://github.com/cyverse/atmosphere-ansible) repositories (**these must be present for this to work properly**)
    - Alternatively, modify the docker-compose file to point to your local repositories with either relative or absolute paths


2. `docker-compose pull` to pull all containers
    - To populate with an existing Atmosphere database, copy the `*.sql` file to the `postgres` directory
    - To populate with a Troposphere database, copy the `tropo*.sql.dump` file to the `postgres` directory. If the file is a `*.sql` file, the postgres image will attempt to dump it into the Atmosphere database instead of the Troposphere database


3. Clone the `atmosphere-docker-secrets` repository in the same directory as this repository (not inside this repository directory)
    - Checkout branch with the correct variables for your environment
    - Use the script `mock_user.sh <your_cyverse_username>` to change `MOCK_USER` variable in `atmosphere.ini` and `troposphere.ini` to your username if using 'local' variables branch


4. `docker-compose up` to start all containers (use the `-d` option to run containers in the background)
    - The container's entrypoint will automatically read a variable from the `env` file in `atmosphere-docker-secrets` to determine if running a production or development environment
    - If you are using a local development version and want Guacamole also, replace the `docker-compose` part of all commands with: `docker-compose -f docker-compose.yml -f docker-compose.guac.yml`
    - If using local development version:
      - **IMPORTANT**: If you are using Linux and want to maintain ownership of your local repositories, edit the `command` lines in `docker-compose.yml` with your user id (use `id -u` to get this). User ID `1000` is the default
      - Your containers should be ready when you see `webpack: Compiled successfully.` from Troposphere and `Starting Django Python...` from Atmosphere
      - Access Atmosphere in your browser at `localhost`
      - Troposphere and Atmosphere changes will be automatically built


**NOTE**: Since this directly uses your local directories for Atmosphere, Troposphere, and Atmosphere-Ansible, these directories will be modified to have things like updated settings files, `*.pyc` files and others present in the `.gitignore` files. To clean up your directory and delete all files recognized by gitignore, run `git clean -fdx`


Variables ini files in atmosphere-docker-secrets are linked to the files used by Atmosphere, Troposphere, and Atmosphere-Ansible so you can easily modify those files locally and have them accessible by the services that use them. Easily re-run the configure scripts with these commands:
```shell
# Configure Troposphere
docker exec -ti $(docker ps -f name=troposphere --format "{{.Names}}") /opt/env/troposphere/bin/python configure

# Configure Atmosphere
docker exec -ti $(docker ps -f name=atmosphere_ --format "{{.Names}}") /opt/env/atmosphere/bin/python configure

# Configure Atmosphere-Ansible
docker exec -ti $(docker ps -f name=atmosphere_ --format "{{.Names}}") /opt/env/atmosphere/bin/python /opt/dev/atmosphere-ansible/configure

# Access Atmosphere Django shell
docker exec -ti $(docker ps -f name=atmosphere_ --format "{{.Names}}") /opt/env/atmo/bin/python manage.py shell
```


### Tips
Gracefully shut down containers with `Ctrl+c`. Press it again to kill containers.

Or kill all containers with `docker-compose kill`.

Delete all containers when you are done with `docker-compose rm`.

Delete all unattached volumes with `docker volume prune`.

**NOTE:** When the `logs/` directory is created by Docker Compose it will be owned by root so you cannot delete it without `sudo`. However, `rm -rf logs` will delete all of the files but the directory structure will remain. If you create the logs directory before running the containers, you can easily delete it.
