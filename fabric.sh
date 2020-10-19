#!/bin/bash

mkdir /data/mods -p
ln -s /data/mods mods
curl https://maven.fabricmc.net/net/fabricmc/fabric-installer/0.6.1.51/fabric-installer-0.6.1.51.jar --output fabric-installer.jar
java -jar fabric-installer.jar server -mcversion ${VERSION} -downloadMinecraft
mv fabric-server-launch.jar runme.jar