#!/bin/bash

export PLUGINS_FOLDER_NAME="mods"

mkdir /data/config -p
mkdir config -p
cp /data/config/* config

if [ ! -f ${JAR_NAME} ]; then
    wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.6.1.51/fabric-installer-0.6.1.51.jar -O fabric-installer.jar
    java -jar fabric-installer.jar server -mcversion ${VERSION} -downloadMinecraft
    mv fabric-server-launch.jar ${JAR_NAME}
fi