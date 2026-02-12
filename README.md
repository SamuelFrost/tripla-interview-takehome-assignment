# Licensing

This project is under a custom evaluation license. See [LICENSE](LICENSE) for full terms. In short: it is not for distribution or commercial use. The repository exists solely to evaluate the capabilities of Samuel Frost for potential business relations. Use of solutions from this repository by Tripla or associates for real business profit without hiring Samuel Frost or obtaining explicit consent may result in liability to share revenue with Samuel Frost.

# Tripla interview takehome assignment

This is a project that uses a Ruby on Rails application for core processes. SQLite is being used as the database.

## Getting Started

To get started with this project, you'll need to have a linux kernal OS and Docker installed on your machine. Windows users should use WSL2 (windows subsystem for linux). Mac and linux users should not need special steps beyond installing docker.

This project uses devcontainers to minimize local setup requirements. For the best experience use devcontainers for development dependencies (most modern IDEs support devcontainers out of the box, for vscode and cursor users, you can run the "Dev Containers: Rebuild and Reopen in Container" command). Otherwise you can install the CLI if desired, or install the appropriate ruby version and other software for this project.

## Setup

### Development Environment Setup


#### 1. Clone the repository

In your projects directory run the following:

```bash
   git clone https://github.com/SamuelFrost/tripla-interview-takehome-assignment.git
   cd tripla-interview-takehome-assignment
```

All commands are run from the top level cloned project directory unless otherwise mentioned.

#### 2. Optional use devcontainer (recommended and considered the default context for running commands)

You can use a remote devcontainer environment that will make it easy to keep your locally installed software in line with other developers. This is particularly useful if you are using vscode or a devcontainer compatible IDE that can be mounted onto the devcontainer.

##### using vscode or cursor

- ensure you have a dev containers extension installed (ms-vscode-remote.remote-containers, or anysphere.remote-containers)
- open the project folder in vscode
- WSL users: if you are using windows subsystem for linux, enable the vscode setting `"dev.containers.executeInWSL": true`, without this, ssh credentials will not be shared with the devcontainer and you won't be able to use your git account from the cli easily
- use dev containers commands through the IDE to build and open the project
  - use the quick action bar (ctrl + p / cmd + p) to search for `Dev Containers: Rebuild and Reopen in Container` (command id is "remote-containers.rebuildAndReopenInContainer")
- vs code should reopen on top of the remote environment

#### 3. Start services

Start services using docker compose.

```bash
docker compose up --build
```

##### common troubleshooting

If you are not using a devcontainer and there are oddities around file ownership you may need to add your userid before building with docker. Run `sh -c '(echo \"DEVELOPER_UID=$(id -u)\nDEVELOPER_GID=$(id -g)\") > .env` once before running docker compose up --build.

If you are not using a devcontainer you will need to create the base image manually.
```bash
docker build -t dynamic-pricing-base ./dynamic-pricing/
```

### Project Information

The project scaffold is a minimal Ruby on Rails application with a `/pricing` endpoint. While you're free to configure your environment as you wish, this repository is pre-configured for a Docker-based workflow that supports live reloading for your convenience.

The provided `Dockerfile` builds a container with all necessary dependencies. Your local code is mounted directly into the container, so any changes you make on your machine will be reflected immediately. Your application will need to communicate with the external pricing model, which also runs in its own Docker container.

### Quick Start Guide

#### dynamic-pricing rails application

Run commands prefixed with `docker compose exec dynamic-pricing` as if you were running them locally, ruby based commands should be prefixed with `bundle exec`. 

Here is a list of common commands for building, running, and interacting with the Dockerized environment.

running tests; add `-v` option for verbose; add test filepath (relative from dynamic-pricing directory) for more focused testing 
```bash
docker compose exec dynamic-pricing bundle exec rails test
```

#### Background Jobs with Solid Queue

The application uses Solid Queue for background job processing.

**The worker starts automatically** when you run `docker compose up`. The `dynamic-pricing-worker` service runs Solid Queue's supervisor which manages workers, dispatchers, and the scheduler.

To view worker logs:

```bash
docker compose logs -f dynamic-pricing-worker
```

To manually trigger a price update job:

```bash
docker compose exec dynamic-pricing bundle exec rails runner "UpdateHotelRoomPricesJob.perform_now"
```

To restart just the worker:

```bash
docker compose restart dynamic-pricing-worker
```

The worker configuration is in `config/queue.yml` and recurring jobs are configured in `config/recurring.yml`. Jobs are stored in a separate SQLite database for the queue.
