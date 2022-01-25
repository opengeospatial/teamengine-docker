**Attention: This manual is outdated and must be updated!**

# Running OGC TEAM Engine with selected executable test suites on Docker

This project provides Dockerfiles for building Docker Images with OGC TEAM Engine and selected executable test suites pre-installed.

## Modules

Currently, following modules are available.

| Module name | Description |
| --- | --- |
| teamengine-production | Includes TEAM Engine and executable test suites of OGC CITE Production environment |
| teamengine-beta | Includes TEAM Engine and executable test suites of OGC CITE Beta environment |

## Introduction

Running the Docker Containers with pre-installed OGC TEAM Engine and selected executable test suites from the provided Dockerfiles needs some preparations:

 * Install Docker
 * Build required Maven projects (not always required)
 * Build Docker Image with Maven
 * Create and start Docker Container

The steps are described in the following sections.

### Requirements

The following software is required for the complete workflow (from git clone to the running Docker Container). The specified versions are the tested ones. Other versions should also work.

 * JDK 1.8
 * Git 2.9.3
 * Maven 3.3.9
 * Docker 1.12

## Prerequisites

Before you start to work with this project, Docker has to be installed and all dependencies be provided as described in the following sections.

### Install Docker

Check the official [Docker documentation](https://docs.docker.com/engine/) for information how to install Docker on your operating system. And then install Docker and supporting tools.

### Dependencies

Most dependencies are automatically downloaded from Central Maven Repository (https://search.maven.org/) by Maven.
However, some dependencies must be built manually.
You can use the script scripts/build-test-suites-not-available-via-central-maven-repo.sh to automatically build all missing dependencies.

Note: You can use any versions of the TEAM Engine and executable test suites.
Just update the versions set in the properties in the pom.xml.

### Build TEAM Engine Docker Image

Run following commands to build a Docker Image with TEAM Engine and all selected executable test suites:

    % git clone https://github.com/opengeospatial/teamengine-docker.git
    % cd teamengine-docker 
    % mvn clean package docker:build

If those commands are executed, all modules are built (```mvn clean package docker:build``` is executed in root directory of this project).

## Running TEAM Engine inside a Docker Container

The following Docker command starts TEAM Engine with executable test suites inside a Docker Container on port 8081 with the previously built Docker Image named ```ogccite/teamengine-production```:

    % docker run -p 8081:8080 --rm ogccite/teamengine-production

## Accessing the TEAM Engine web interface

Use a browser of your choice and open the URL:

http://localhost:8081/teamengine

## Hints for usage in production

### Mount user data from host system

User data should be backed up regularly as they contain all registered users and the corresponding test runs.
An easy way to achieve this is to hold these data on the host system. By that they can be backed up by simple file system backups. Also, the data can easily be copied and used by different Docker Containers.

So, the user data folder must be mounted into the Docker Container.
A host system directory can be mounted as a data volume with the ```-v``` flag.

This is an example how to mount the ~/te_base/users (Linux syntax) folder (is created if not existing) of host system into Docker Container:

    % docker run -p 8081:8080 -v ~/te_base/users:/root/te_base/users --rm ogccite/teamengine-production
