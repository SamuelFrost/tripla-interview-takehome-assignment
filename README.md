# Licensing

This project is under a custom evaluation license. See [LICENSE](LICENSE) for full terms. In short: it is not for distribution or commercial use. The repository exists solely to evaluate the capabilities of Samuel Frost for potential business relations. Use of solutions from this repository by Tripla or associates for real business profit without hiring Samuel Frost or obtaining explicit consent may result in liability to share revenue with Samuel Frost.

# Tripla interview takehome assignment

This is a Ruby on Rails application that uses PostgreSQL as the database.

## Getting Started

To get started with this project, you'll need to have a linux kernal OS and Docker installed on your machine. Windows users should use WSL2 (windows subsystem for linux). Mac and linux users should not need special steps beyond installing docker.

### Setup

TODO: refine this to be more in line with a fully functioning project as opposed to a simple stand alone container

## Development Environment Setup

The project scaffold is a minimal Ruby on Rails application with a `/pricing` endpoint. While you're free to configure your environment as you wish, this repository is pre-configured for a Docker-based workflow that supports live reloading for your convenience.

The provided `Dockerfile` builds a container with all necessary dependencies. Your local code is mounted directly into the container, so any changes you make on your machine will be reflected immediately. Your application will need to communicate with the external pricing model, which also runs in its own Docker container.

### Quick Start Guide

Here is a list of common commands for building, running, and interacting with the Dockerized environment.

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