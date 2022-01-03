#!/bin/bash
mkdir tmp-teamengine-docker-test-suites
cd tmp-teamengine-docker-test-suites/

echo Clone test suites
git clone --depth 1 --branch 1.13 https://github.com/opengeospatial/ets-wfs10.git
git clone --depth 1 --branch 1.32 https://github.com/opengeospatial/ets-wfs11.git
git clone --depth 1 --branch 1.18 https://github.com/opengeospatial/ets-csw202.git
git clone --depth 1 --branch 0.5 https://github.com/opengeospatial/ets-kml2.git
git clone --depth 1 --branch 1.8 https://github.com/opengeospatial/ets-sfs11.git
git clone --depth 1 --branch 1.4 https://github.com/opengeospatial/ets-sfs12.git
git clone --depth 1 --branch 1.14 https://github.com/opengeospatial/ets-sos10.git
git clone --depth 1 --branch 1.8 https://github.com/opengeospatial/ets-sps10.git
git clone --depth 1 --branch 1.11 https://github.com/opengeospatial/ets-sps20.git

echo Build test suites
for d in */ ; do
    cd "$d" && mvn clean install -DskipTests && cd ..
done

echo Build embedded-dependencies-repacked of ets-security-client10
git clone https://github.com/opengeospatial/ets-security-client10.git
cd ets-security-client10/embedded-dependencies-repacked/
mvn clean install -DskipTests
cd ../..

cd ..
rm -rf tmp-teamengine-docker-test-suites/
