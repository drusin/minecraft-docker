#!/bin/bash

export PLUGINS_FOLDER_NAME="mods"

mkdir /data/config -p
mkdir config -p
cp /data/config/* config

if [ ! -f $JAR_NAME ]; then
    fabricInstallerVersion=$(curl https://maven.fabricmc.net/net/fabricmc/fabric-installer/maven-metadata.xml | grep -oP '<version>.*?</version>' | tail -1 | grep -oP '\d*?\.\d*?\.\d*')
    wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/$fabricInstallerVersion/fabric-installer-$fabricInstallerVersion.jar -O fabric-installer.jar
    java -jar fabric-installer.jar server -mcversion $MC_VERSION -downloadMinecraft
    mv fabric-server-launch.jar $JAR_NAME
fi