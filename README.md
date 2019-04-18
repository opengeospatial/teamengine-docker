**Attention: This manual is outdated and must be updated!**

# Running OGC TEAM Engine with selected executable test suites on Docker

This project provides Dockerfiles for building Docker Images with OGC TEAM Engine and selected executable test suites pre-installed.

## Modules

Currently, following modules are available.

| Module name | Description |
| --- | --- |
| teamengine-ets-all | Includes TEAM Engine and all executable test suites which are included in this project. |
| teamengine-[TEST_SUITE_ID] | Includes TEAM Engine and executable test suite [TEST_SUITE_ID]. |

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
This is the case if a version shall be used which has not been released yet (also, some releases are not deployed to Central Maven Repository).

Note: You can use any versions of the TEAM Engine and executable test suites.
Just update the versions set in the properties in the pom.xml.

Example for building ETS for WMS 1.3 version 1.22.

    % git clone https://github.com/opengeospatial/ets-wms13.git
    % cd ets-wms13
    % git checkout tags/1.22
    % mvn clean install

Running the previous commands will make available WMS 1.3 test suite in local Maven repository.

### Build TEAM Engine Docker Image

To build a Docker Image with TEAM Engine and all selected executable test suites run commands:

    % git clone https://github.com/opengeospatial/teamengine-docker.git
    % cd teamengine-docker 
    % mvn clean package docker:build

If those commands are executed, all modules are built (```mvn clean package docker:build``` is executed in root directory of this project).
Caution: All required dependencies must be available.
Following case is the more common one.

If just a single Docker Image is required (e.g. TEAM Engine with all available executable test suites or TEAM Engine with ETS for WMS 1.3), navigate to the corresponding module and execute the built there.
For example, for WMS 1.3 do the following:

    % cd teamengine-ets-wms13
    % mvn clean package docker:build

## Running TEAM Engine inside a Docker Container

The following Docker command starts TEAM Engine with all available executable test suites inside a Docker Container on port 8081 with the previously built Docker Image named ```opengis/teamengine-ets-all```:

    % docker run -p 8081:8080 --rm opengis/teamengine-ets-all
    
To start TEAM Engine with a single executable test suite, just adjust the second part of the image name to the name of the required module.
Example for starting the TEAM Engine with ETS for WMS 1.3 (name of Docker Image is ```opengis/teamengine-ets-wms13```):

    % docker run -p 8081:8080 --rm opengis/teamengine-ets-wms13

## Accessing the TEAM Engine web interface

Use a browser of your choice and open the URL:

http://localhost:8081/teamengine

## Hints for developer

If deployment of a SNAPSHOT version of an ETS is required during development, the demanded version can be set in the build command.

Of course, the SNAPSHOT of the ETS has to be built first so that it is available in local Maven repository.

Execute the build command and add a ```-D``` argument which changes the value of a version property.
Example for building Docker Image with ETS for WMS 1.3 version 1.23-SNAPSHOT:

    % mvn clean package docker:build -Dets-wms13.version=1.23-SNAPSHOT

Following command can be used to build a Docker Image with a SNAPSHOT version and immediately create and start the Docker Container (just one command for complete deployment!):

    % mvn clean package docker:build -Dets-wms13.version=1.23-SNAPSHOT && docker run -p 8081:8080 --rm opengis/teamengine-ets-wms13

## Hints for usage in production

### Mount user data from host system

User data should be backed up regularly as they contain all registered users and the corresponding test runs.
An easy way to achieve this is to hold these data on the host system. By that they can be backed up by simple file system backups. Also, the data can easily be copied and used by different Docker Containers.

So, the user data folder must be mounted into the Docker Container.
With the ```-v``` flag a host system directory can be mounted as a data volume.

This is an example how to mount the ~/te_base/users (Linux syntax) folder (is created if not existing) of host system into Docker Container:

    % docker run -p 8081:8080 -v ~/te_base/users:/root/te_base/users --rm opengis/teamengine-ets-all
