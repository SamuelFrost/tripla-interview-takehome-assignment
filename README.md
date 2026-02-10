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

   ```console
   git clone https://github.com/SamuelFrost/calendaculator.git
   cd calendaculator
   ```

#### 2. Optional use devcontainer (recommended and considered the default context for running commands)

You can use a remote devcontainer environment that will make it easy to keep your locally installed software in line with other developers. This is particularly useful if you are using vscode or a devcontainer compatible IDE that can be mounted onto the devcontainer.

##### using vscode or cursor

- ensure you have a dev containers extension installed (ms-vscode-remote.remote-containers, or anysphere.remote-containers)
- open the project folder in vscode
- WSL users: if you are using windows subsystem for linux, enable the vscode setting `"dev.containers.executeInWSL": true`, without this, ssh credentials will not be shared with the devcontainer and you won't be able to use your git account from the cli easily
- use dev containers commands through the IDE to build and open the project
  - use the quick action bar (ctrl + p / cmd + p) to search for `Dev Containers: Rebuild and Reopen in Container` (command id is "remote-containers.rebuildAndReopenInContainer")
- vs code should reopen on top of the remote environment

### Project Information

The project scaffold is a minimal Ruby on Rails application with a `/pricing` endpoint. While you're free to configure your environment as you wish, this repository is pre-configured for a Docker-based workflow that supports live reloading for your convenience.

The provided `Dockerfile` builds a container with all necessary dependencies. Your local code is mounted directly into the container, so any changes you make on your machine will be reflected immediately. Your application will need to communicate with the external pricing model, which also runs in its own Docker container.

### Quick Start Guide

Here is a list of common commands for building, running, and interacting with the Dockerized environment.

#### dyanmic-pricing rails application

```bash

# change to the dynamic-pricing directory
cd dynamic-pricing/

# --- 1. Build & Run The Main Application ---
# Build the Docker image
docker build -t interview-app .

# Run the service
docker run -p 3000:3000 -v $(pwd):/rails interview-app

# --- 2. Test The Endpoint ---
# Send a sample request to your running service
curl 'http://localhost:3000/pricing?period=Summer&hotel=FloatingPointResort&room=SingletonRoom'

# --- 3. Run Tests ---
# Run the development container in the background
docker run -d -p 3000:3000 -v $(pwd):/rails --name interview-dev interview-app

# Run the full test suite
docker container exec -it interview-dev ./bin/rails test

# Run a specific test file
docker container exec -it interview-dev ./bin/rails test test/controllers/pricing_controller_test.rb

# Run a specific test by name
docker container exec -it interview-dev ./bin/rails test test/controllers/pricing_controller_test.rb -n test_should_get_pricing_with_all_parameters
```