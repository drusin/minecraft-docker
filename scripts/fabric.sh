#!/bin/bash

export PLUGINS_FOLDER_NAME="mods"

mkdir /data/config -p
mkdir config -p
cp /data/config/* config

if [ ! -f $JAR_NAME ]; then
    wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/$FABRIC_INSTALLER_VERSION/fabric-installer-$FABRIC_INSTALLER_VERSION.jar -O fabric-installer.jar
    java -jar fabric-installer.jar server -mcversion $MC_VERSION -downloadMinecraft
    mv fabric-server-launch.jar $JAR_NAME
fi