#!/bin/bash

export PLUGINS_FOLDER_NAME="plugins"

if [ ! -f $JAR_NAME ]; then
    build=$(curl https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION | grep -oP '\"builds\"\:\[.*?\]' | grep -oP '\d*?\]' | grep -oP '\d*')
    wget https://papermc.io/api/v2/projects/paper/versions/$MC_VERSION/builds/$build/downloads/paper-$MC_VERSION-$build.jar -O $JAR_NAME
fi
