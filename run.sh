#!/bin/bash

# Run the Docker container
docker run -p 8080:8080 \
    --env SKIP_DEMO_DATA=true \
    --mount type=bind,src=/Users/guadaluperomero/ProjectsTSB/amarex/amarex-geoserver/data,target=/opt/geoserver/data \
    --name geoserver \
    -e GEOSERVER_USER=admin \
    -e GEOSERVER_PASSWORD=geoserver \
    -d geoserver
