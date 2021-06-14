#!/bin/bash

export PLUGINS_FOLDER_NAME="plugins"
export WORLDS=""

mkdir /data/modules -p
ln -sfn /data/modules modules

if [ ! -f $JAR_NAME ]; then
    versionArr=(${MC_VERSION//./ })
    waterfallVersion=(${versionArr[0]}.${versionArr[1]})
    build=$(curl https://papermc.io/api/v2/projects/waterfall/versions/$waterfallVersion | grep -oP '\"builds\"\:\[.*?\]' | grep -oP '\d*?\]' | grep -oP '\d*')
    wget https://papermc.io/api/v2/projects/waterfall/versions/$waterfallVersion/builds/$build/downloads/waterfall-$waterfallVersion-$build.jar -O $JAR_NAME
fi