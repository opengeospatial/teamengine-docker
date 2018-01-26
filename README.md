# Running OGC TEAM Engine with selected executable test suites on Docker

This project provides Dockerfiles for building Docker images with OGC TEAM Engine and selected executable test suites pre-installed.

## Modules

Currently, following modules are available. They differ in the available executable test suite(s).

| Module name | Description |
| --- | --- |
| teamengine-ets-all | Includes TEAM Engine and all executable test suites listed below. |
| teamengine-ets-cat30 | Includes TEAM Engine and the executable test suite for CAT 3.0. |
| teamengine-ets-csw202 | Includes TEAM Engine and the executable test suite for CSW 2.0.2. |
| teamengine-ets-gml32 | Includes TEAM Engine and the executable test suite for GML 3.2. |
| teamengine-ets-gpkg10 | Includes TEAM Engine and the executable test suite for GeoPackage 1.0. |
| teamengine-ets-gpkg12 | Includes TEAM Engine and the executable test suite for GeoPackage 1.2. |
| teamengine-ets-kml2 | Includes TEAM Engine and the executable test suite for KML 2. |
| teamengine-ets-kml22 | Includes TEAM Engine and the executable test suite for KML 2.2. |
| teamengine-ets-owc10 | Includes TEAM Engine and the executable test suite for OWC 1.0. |
| teamengine-ets-sensorml10 | Includes TEAM Engine and the executable test suite for Sensor Model Language 1.0. |
| teamengine-ets-sensorml20 | Includes TEAM Engine and the executable test suite for Sensor Model Language 2.0. |
| teamengine-ets-sfs11 | Includes TEAM Engine and the executable test suite for SFS 1.1. |
| teamengine-ets-sfs12 | Includes TEAM Engine and the executable test suite for SFS 1.2. |
| teamengine-ets-sos10 | Includes TEAM Engine and the executable test suite for SOS 1.0. |
| teamengine-ets-sos20 | Includes TEAM Engine and the executable test suite for SOS 2.0. |
| teamengine-ets-sps10 | Includes TEAM Engine and the executable test suite for SPS 1.0. |
| teamengine-ets-sps20 | Includes TEAM Engine and the executable test suite for SPS 2.0. |
| teamengine-ets-sta10 | Includes TEAM Engine and the executable test suite for STA 1.0. |
| teamengine-ets-wcs10 | Includes TEAM Engine and the executable test suite for WCS 1.0. |
| teamengine-ets-wcs11 | Includes TEAM Engine and the executable test suite for WCS 1.1. |
| teamengine-ets-wcs20 | Includes TEAM Engine and the executable test suite for WCS 2.0. |
| teamengine-ets-wfs10 | Includes TEAM Engine and the executable test suite for WFS 1.0. |
| teamengine-ets-wfs11 | Includes TEAM Engine and the executable test suite for WFS 1.0. |
| teamengine-ets-wfs20 | Includes TEAM Engine and the executable test suite for WFS 2.0. |
| teamengine-ets-wms11 | Includes TEAM Engine and the executable test suite for WMS 1.1. |
| teamengine-ets-wms13 | Includes TEAM Engine and the executable test suite for WMS 1.3. |
| teamengine-ets-wms-client13 | Includes TEAM Engine and the executable test suite for WMS Client 1.3. |
| teamengine-ets-wmts10 | Includes TEAM Engine and the executable test suite for WMTS 1.0. |
| teamengine-ets-wps10 | Includes TEAM Engine and the executable test suite for WPS 1.0. |
| teamengine-ets-gpkg12-nsg | Includes TEAM Engine and the executable test suite for NSG GeoPackage 1.2. |

## Introduction

Running the Docker containers with pre-installed OGC TEAM Engine and selected executable test suites from the provided Dockerfiles needs some preparations:

 * install Docker
 * clone required Github repositories
 * build required Maven projects
 * build Docker image with Maven
 * start Docker image

The steps are described in the following sections.

### Requirements

The following software is required for the complete workflow (from git clone to the running Docker container). The specified versions are the tested ones. Other versions should also work.

 * JDK 1.8
 * Git 2.9.3
 * Maven 3.3.9
 * Docker 1.12

## Prerequisites

Before you start to work with this project, Docker has to be installed and all dependencies be provided as described in the following sections.

### Install Docker

Check the official [Docker documentation](https://docs.docker.com/engine/) for information how to
  install Docker on your operating system. And then install Docker and supporting tools.

### Dependencies
Dependent on which executable test suites are required several dependencies must be build first.

Note: You can use any versions of the TEAM Engine and executable test suites.
Just update the versions set in the properties in the pom.xml.

#### Build TEAM Engine:

Default version is 5.1.

    % git clone https://github.com/opengeospatial/teamengine.git
    % cd teamengine
    % git checkout tags/5.1
    % mvn clean install
    
Running the previous commands will make available the TEAM Engine project in the local mvn repository.    

If other TEAM Engine version is demanded, the version value must be adjusted.

#### Build an executable test suite:

Example for building ETS for WMS 1.3 version 1.22.

    % git clone https://github.com/opengeospatial/ets-wms13.git
    % cd ets-wms13
    % git checkout tags/1.22
    % mvn clean install

Running the previous commands will make available the WMS 1.3 test scritps in the local mvn repository.    

If other test suites are required, the repository path and version value must be adjusted.

### Build TEAM Engine Docker Image


To build a Docker image with TEAM Engine and all selected executable test suites run the Maven goals:
   
    % git clone https://github.com/opengeospatial/teamengine-docker.git
    % cd teamengine-docker 
    % mvn clean package docker:build

This will build a new Docker image from scratch. It may take a while the first time since Docker will download some base images from [Docker Hub](https://hub.docker.com).

If the command is executed in the root directory of this project, all modules are built.

If only some of the tests were build (using the steps from WMS 1.3 as described bellow) an error might occur because mavn modules for some tests might be missing. An error like the follwoing will be presented::

    [ERROR] Failed to execute goal on project teamengine-ets-all: Could not resolve dependencies for project org.opengis.cite:teamengine-ets-all:pom:1.0-SNAPSHOT: The following artifacts could not be resolved: org.opengis.cite:ets-kml2:zip:ctl:0.5, org.opengis.cite:ets-kml2:zip:deps:0.5, org.opengis.cite:ets-owc10:zip:ctl:0.1, org.opengis.cite:ets-owc10:zip:deps:0.1: Could not find artifact org.opengis.cite:ets-kml2:zip:ctl:0.5 in opengeospatial-cite (https://svn.opengeospatial.org/ogc-projects/cite/maven) -> [Help 1]

If just a single Docker image is required (e.g. TEAM Engine with all available executable test suites or TEAM Engine with ETS for WMS 1.3), navigate to the corresponding module and execute the built there. For example, following this examples, for WMS 1.3 do the following:

    % cd teamengine-ets-wms13
    % mvn clean package docker:build

## Running TEAM Engine inside a Docker container

The following Docker command starts the TEAM Engine with all available executable test suites inside a Docker container with the context name ```teamengine``` on port 8081 with the previously built Docker image named ```opengis/teamengine-ets-all```:

    % docker run -p 8081:8080 --name teamengine --rm opengis/teamengine-ets-all
    
To start TEAM Engine with a single executable test suite, just adjust the second part of the image name to the name of the required module.
Example for starting the TEAM Engine with ETS for WMS 1.3 (name of Docker image is ```opengis/teamengine-ets-wms13```):

    % docker run -p 8081:8080 --name teamengine --rm opengis/teamengine-ets-wms13

## Accessing the TEAM Engine web interface

Use a browser of your choice and open the URL:

http://localhost:8081/teamengine


## Hints for developer

If deployment of a SNAPSHOT version of an ETS is required during development, the demanded version can be set in the build command.

Of course, the SNAPSHOT of the ETS has to be built first so that it is available in local Maven repository.

Execute the build command and add a ```-D``` argument which changes the value of a version property.
Example for building Docker image with ETS for WMS 1.3 version 1.23-SNAPSHOT:

    % mvn clean package docker:build -Dets-wms13.version=1.23-SNAPSHOT

Following command can be used to build a Docker image with a SNAPSHOT version and immediately create and start the Docker container (just one command for complete deployment!):

    % mvn clean package docker:build -Dets-wms13.version=1.23-SNAPSHOT && docker run -p 8081:8080 --name teamengine --rm opengis/teamengine-ets-wms13

## Hints for usage in production

### Mount user data from host system

User data should be backed up regularly as they contain all registered users and the corresponding test runs.
An easy way to achieve this is to hold these data on the host system. By that they can be backed up by simple file system backups. Also, the data can easily be copied and used by different Docker containers.

So, the user data folder must be mounted into the Docker container.
With the ```-v``` flag a host system directory can be mounted as a data volume.

This is an example how to mount the ~/te_base/users (Linux syntax) folder (is created if not existing) of host system into Docker container:

    % docker run -p 8081:8080 --name teamengine -v ~/te_base/users:/root/te_base/users --rm opengis/teamengine-ets-all
