#!/bin/bash

mkdir /data/plugins -p
ln -sfn /data/plugins plugins

if [ ${AUTO_UPDATE_VIAVERSION} == 'true' ]; then
    wget -O plugins/ViaVersion.jar http://myles.us/ViaVersion/latest.jar
fi

curl https://papermc.io/api/v1/paper/${VERSION}/latest/download --output runme.jar