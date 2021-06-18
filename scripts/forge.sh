#!/bin/bash

export PLUGINS_FOLDER_NAME="mods"

mkdir /data/config -p
ln -sfn /data/config config

if [ ! -f $JAR_NAME ]; then
	forgeVersion=$(curl https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json | grep -oP $MC_VERSION'-recommended.*?\d*?\.\d*?\.\d*\"' | grep -oP '\"\d*?\.\d*?\.\d*\"' | grep -oP '\d*?\.\d*?\.\d*')
    wget https://files.minecraftforge.net/maven/net/minecraftforge/forge/$MC_VERSION-$forgeVersion/forge-$MC_VERSION-$forgeVersion-installer.jar -O forge-installer.jar
    if [ ! -f forge-installer.jar ]; then
      echo "Something went wrong with the Forge Installer Download. Check versions!"
      ls -al
      exit 1
    fi

    java -jar forge-installer.jar server --installServer
    if [ ! -f forge-$MC_VERSION-$forgeVersion.jar ]; then
      echo "Something went wrong during Forge Installation. Expected file forge-$MC_VERSION-$forgeVersion.jar not found!"
      ls -al
      exit 1
    fi

    ln -s forge-$MC_VERSION-$forgeVersion.jar $JAR_NAME
fi
