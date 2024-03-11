# Use the official GeoServer base image
FROM docker.osgeo.org/geoserver:2.24.1

# Set the GeoServer data directory as a volume
VOLUME /opt/geoserver/data_dir

# Expose GeoServer port
EXPOSE 8080
