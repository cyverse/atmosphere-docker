# Changelog
All notable changes to this project will be documented in this file.

---
## [PR #2: Postgres database container](https://github.com/cyverse/atmosphere-docker/pull/2) - 2018-04-18
### Added
- Postgres container

### Changed
- Some build tasks in the Atmosphere and Troposphere containers required the database to be active, so I had to move these tasks into the entrypoint. This causes startup to take a little longer than before.
- Using postgres container allows us to create Docker images for different Atmosphere versions **without** a database so that nothing is leaked, but then users can add a database file at startup, or use an existing database container.
- Database dump documentation

### Removed
None.


---
## [PR #3: Choose version on run instead of build](https://github.com/cyverse/atmosphere-docker/pull/3) - 2018-04-20
### Added
- New environment file `options.env`. This file contains empty environment variables for GitHub repository and branch choices.

### Changed
- Added a lot of stuff to the entrypoints so that new branches/remotes can be chosen and built.

### Removed
None.


---
## [PR #4: Reduce the image size of the main containers](https://github.com/cyverse/atmosphere-docker/pull/4) - 2018-04-25
### Added
None.

### Changed
- Nginx container:
  - Now uses `debian:jessie-slim` as the base
  - Combined `RUN` tasks and cleared apt-cache
- Atmosphere container:
  - Install dependencies using apt instead of letting Clank do it
  - Combined `RUN` tasks and cleared apt-cache
- Troposphere container:
  - Install dependencies using apt instead of letting Clank do it
  - Combined `RUN` tasks and cleared apt-cache
  - Skip `npm` install and build steps and move them to `entrypoint.sh`
- Also, updated Guacamole to use `0.9.14`

### Removed
None.


---
## [PR #5: Build without atmo-local](https://github.com/cyverse/atmosphere-docker/pull/5) - 2018-04-27
### Added
None.

### Changed
- All containers now can be built without `atmo-local` variables, so the images are completely secret-free. This also makes it a lot simpler to get started.
- Updated README to be more clear and be accurate with the new changes.

### Removed
- All scripts that are no longer useful.
- `alt` scripts may have been useful, but I think they were more confusing than they were worth.


---
## [PR #6: Use wait_for ansible module instead of sleep loop](https://github.com/cyverse/atmosphere-docker/pull/6) - 2018-05-10
### Added
None.

### Changed
- Use ansible's `wait_for` module in the entrypoint playbooks instead of a sleep loop. This improved readability and startup time.

### Removed
None.


---
## [PR #7: Link Guacamole and Atmosphere for Web Shell access](https://github.com/cyverse/atmosphere-docker/pull/7) - 2018-05-16
### Added
- Named volume used by Guacamole and Atmosphere for storing SSH keys
- Use local connection instead of SSH on role `sshkey-host-access`

### Changed
- Replaced all uses of `sed` in the setup playbooks with `lineinfile`

### Removed
None.


---
## [PR #8: Allow changing Clank remote and branch during build](https://github.com/cyverse/atmosphere-docker/pull/8) - 2018-06-18
### Added
None.

### Changed
- Add $CLANK_REPO and $CLANK_BRANCH to Docker Compose file and the Atmosphere, Troposphere, and Nginx containers

### Removed
None.
