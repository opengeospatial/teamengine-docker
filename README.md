# Running OGC TEAM Engine with ETS for WFS 2.0 on Docker

This module provides a Dockerfile for building a Docker image with OGC TEAM Engine and selected  executable test suite pre-installed.

## Profiles
Currently the following profiles are available, they differ in the available executable test suite:
 * ets-all (includes the executable testsuites for WMS 1.3, WFS 2.0 and WCS 1.1; default)
 * ets-wms13 (includes the executable testsuite for WMS 1.3)
 * ets-wfs20 (includes the executable testsuite for WFS 2.0)
 * ets-wcs11 (includes the executable testsuite for WCS 1.1)

## Prerequisites

### Install Docker

Check the official [Docker documentation](https://docs.docker.com/engine/) for information how to
  install Docker on your operating system. And then install Docker and supporting tools.

### Dependencies
Dependent on which executable test suites are required several dependencies must be build first.

Note: You can use any versions of the TEAM Engine and ETS.
Just update the versions set in the properties in the pom.xml.
Also, use the correct versions when building the TEAM Engine and ETS by setting ```git checkout tags/version``` to the demanded version.

#### Build the TEAM Engine:

Per default Version 4.10 is used.

    % git clone https://github.com/opengeospatial/teamengine.git
    % cd teamengine
    % git checkout tags/4.10
    % mvn clean install

#### Build the ETS for WMS 1.3:

Per default Version 1.22 is used.

    % git clone https://github.com/opengeospatial/ets-wms13.git
    % cd ets-wms13
    % git checkout tags/1.22
    % mvn clean install

#### Build the ETS for WFS 2.0:

Per default Version 1.26 is used.

    % git clone https://github.com/opengeospatial/ets-wfs20.git
    % cd ets-wfs20
    % git checkout tags/1.26
    % mvn clean install

#### Build the ETS for WCS 1.1:

Per default Version 1.12 is used.

    % git clone https://github.com/opengeospatial/ets-wcs11.git
    % cd ets-wcs11
    % git checkout tags/1.12
    % mvn clean install

## Build the Docker image

To build the Docker image with all currently available executable test suites run the Maven goals:

    % mvn clean package docker:build

This will build a new Docker image from scratch. It may take a while the first time since Docker will download some base images from [docker hub](https://hub.docker.com).

Check if the Docker image has been built successfully with:

    % docker images

The profiles described above can be used to control the executable test tesuites running in the teamengine. To build a Docker image with the test suite for WMS 1.3 append the name of this profile (parameter ```-Pets-wms13```):

    % mvn clean package docker:build -Pets-wms13

## Running TEAM Engine inside a Docker container

The following Docker command starts the TEAM Engine inside the Docker container with the name ```teamengine``` on port 8088
with the previously built Docker image named ```opengis/teamengine-ets-all``` (if a profile was used the name can be taken from the output of ```% docker images```):

    % docker run -p 8088:8080 --name teamengine --rm opengis/teamengine-ets-all

## Accessing the TEAM Engine web interface

Use a browser of your choice and open the URL:

http://container-ip:8088/teamengine

If your are running Docker on Windows or OS X with docker-machine check the IP with ```docker-machine ip```.
On Linux it is most likely localhost/127.0.0.1 on Windows and macOS it might be a IP like:

http://192.168.99.100:8088/teamengine