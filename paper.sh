#!/bin/bash

export PLUGINS_FOLDER_NAME="plugins"

if [ ! -f ${JAR_NAME} ]; then
    wget https://papermc.io/api/v1/paper/${MC_VERSION}/latest/download -O ${JAR_NAME}
fi
