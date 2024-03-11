# Run the Amarex GeoServer

## Requirements

Follow the [instructions to install Docker](https://docs.docker.com/get-docker/) on your computer, if not available yet.

## Run the shell scripts

Run `sh build.sh` on the command line to build the docker image and `sh run.sh` to run it.
If everything goes well, the GeoServer should be then available at http://localhost:8080/geoserver.
If you want to delete the container (for example, to re-build it and re-run it), type `sh delete.sh`.
