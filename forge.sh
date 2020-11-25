#!/bin/bash

mkdir /data/mods -p
ln -sfn /data/mods mods
mkdir /data/config -p
ln -sfn /data/config config

if [ ! -f ${JAR_NAME} ]; then
    wget https://files.minecraftforge.net/maven/net/minecraftforge/forge/${VERSION}-${FORGE_VERSION}/forge-${VERSION}-${FORGE_VERSION}-installer.jar -O forge-installer.jar
    if [ ! -f forge-installer.jar ]; then
      echo "Something went wrong with the Forge Installer Download. Check versions!"
      ls -al
      exit 1
    fi

    java -jar forge-installer.jar server --installServer
    if [ ! -f forge-${VERSION}-${FORGE_VERSION}.jar ]; then
      echo "Something went wrong during Forge Installation. Expected file forge-${VERSION}-${FORGE_VERSION}.jar not found!"
      ls -al
      exit 1
    fi

    ln -s forge-${VERSION}-${FORGE_VERSION}.jar ${JAR_NAME}
fi
