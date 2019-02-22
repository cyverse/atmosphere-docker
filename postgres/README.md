# Postgres


This container runs the PostgreSQL database


The Dockerfile is based off the official postgres Docker container and just adds a new startup script and optional `.sql` file. The entrypoint script creates the Troposphere database.
