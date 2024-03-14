#!/bin/bash

# GeoServer credentials
GEOSERVER_USER="admin"
GEOSERVER_PASSWORD="geoserver"

# GeoServer URL
GEOSERVER_URL="http://localhost:8080/geoserver"

# Workspace and store information
WORKSPACE="amarex"
# TODO: We should extract these variables from the xml configurations, so it's not duplicated
DATASTORE="amarex"
LAYER_NAME="map"

## Path to your SLD file (optional)
SLD_FILE=""

# Function to check if a workspace exists
workspace_exists() {
    local workspace=$1
    local response=$(curl -s -o /dev/null -w "%{http_code}" -u "${GEOSERVER_USER}:${GEOSERVER_PASSWORD}" \
        "${GEOSERVER_URL}/rest/workspaces/${workspace}")

    if [ $response -eq 200 ]; then
        return 0  # Workspace exists
    else
        return 1  # Workspace does not exist
    fi
}

# Function to check if a data store exists
datastore_exists() {
    local workspace=$1
    local store=$2
    local response=$(curl -s -o /dev/null -w "%{http_code}" -u "${GEOSERVER_USER}:${GEOSERVER_PASSWORD}" \
        "${GEOSERVER_URL}/rest/workspaces/${workspace}/datastores/${store}")

    if [ $response -eq 200 ]; then
        return 0  # Data store exists
    else
        return 1  # Data store does not exist
    fi
}

# Function to create a workspace
create_workspace() {
    local workspace=$1

    # Check if workspace exists
    if workspace_exists "${workspace}"; then
        echo "Workspace '${workspace}' already exists."
    else
        # Create workspace if it doesn't exist
        curl -v -u "${GEOSERVER_USER}:${GEOSERVER_PASSWORD}" -X POST -H "Content-type: text/xml" \
            -d "<workspace><name>${workspace}</name></workspace>" \
            "${GEOSERVER_URL}/rest/workspaces"
        echo "Workspace '${workspace}' created."
    fi
}

# Function to create a data store
create_datastore() {
    local workspace=$1
    local store=$2
    local datastore_xml="/Users/guadaluperomero/ProjectsTSB/amarex/amarex-geoserver/data/datastore.xml"

    # Check if datastore exists
    if datastore_exists "${workspace}" "${store}"; then
        echo "Data Store '${store}' already exists."
    else
        # Create data store
        curl -v -u "${GEOSERVER_USER}:${GEOSERVER_PASSWORD}" -X POST -H "Content-type: text/xml" \
            --data-binary "@${datastore_xml}" \
            "${GEOSERVER_URL}/rest/workspaces/${workspace}/datastores"
        echo "Data store '${store}' created."
    fi
}


# Function to publish a layer
publish_layer() {
    local workspace=$1
    local store=$2
    local layer=$3
#    local sld=$4

    # Publish layer
    curl -v -u "${GEOSERVER_USER}:${GEOSERVER_PASSWORD}" -X POST -H "Content-type: application/xml" \
        -d "<featureType><name>${layer}</name></featureType>" \
        "${GEOSERVER_URL}/rest/workspaces/${workspace}/datastores/${store}/featuretypes"

#    # Set layer style (if SLD file provided)
#    if [ -n "${sld}" ]; then
#        curl -v -u "${GEOSERVER_USER}:${GEOSERVER_PASSWORD}" -X PUT -H "Content-type: application/vnd.ogc.sld+xml" \
#            -d "@${sld}" "${GEOSERVER_URL}/rest/workspaces/${workspace}/styles/${layer}.sld"
#        curl -v -u "${GEOSERVER_USER}:${GEOSERVER_PASSWORD}" -X POST -H "Content-type: application/xml" \
#            -d "<layer><defaultStyle><name>${layer}</name></defaultStyle></layer>" \
#            "${GEOSERVER_URL}/rest/layers/${workspace}:${layer}"
#    fi

    echo "Layer '${layer}' published successfully."
}

# Create workspace
create_workspace "${WORKSPACE}"

# Create data store
create_datastore "${WORKSPACE}" "${DATASTORE}"

# This step not working at the moment
### Publish layer
publish_layer "${WORKSPACE}" "${DATASTORE}" "${LAYER_NAME}" #"${SLD_FILE}"
