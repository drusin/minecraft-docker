#!/bin/bash

versionArr=(${VERSION//./ })

mkdir /data/plugins -p
ln -sfn /data/plugins plugins
mkdir /data/modules -p
ln -sfn /data/modules modules

if [ ${AUTO_UPDATE_VIAVERSION} == 'true' ]; then
    wget -O plugins/ViaVersion.jar http://myles.us/ViaVersion/latest.jar
fi

curl https://papermc.io/api/v1/waterfall/${versionArr[0]}.${versionArr[1]}/latest/download --output runme.jar