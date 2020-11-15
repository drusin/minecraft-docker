#!/bin/bash

mkdir /data/mods -p
ln -sfn /data/mods mods
mkdir /data/config -p
ln -sfn /data/config config

if [ ${AUTO_UPDATE_VIAVERSION} == 'true' ]; then
    wget -O mods/ViaVersion.jar http://myles.us/ViaVersion/latest.jar
fi

if [ ! -f ${JAR_NAME} ]; then
    wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.6.1.51/fabric-installer-0.6.1.51.jar -O fabric-installer.jar
    java -jar fabric-installer.jar server -mcversion ${VERSION} -downloadMinecraft
    mv fabric-server-launch.jar ${JAR_NAME}
fi