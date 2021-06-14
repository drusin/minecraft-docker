#!/bin/bash

export PLUGINS_FOLDER_NAME="plugins"
export WORLDS=""

mkdir /data/modules -p
ln -sfn /data/modules modules

versionArr=(${VERSION//./ })
if [ ! -f $JAR_NAME ]; then
    wget https://papermc.io/api/v1/waterfall/${versionArr[0]}.${versionArr[1]}/latest/download -O $JAR_NAME
fi