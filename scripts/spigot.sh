#!/bin/bash

export PLUGINS_FOLDER_NAME="plugins"

if [ ! -f $JAR_NAME ]; then
    apt-get install git -y
    git config --global --unset core.autocrlf
    mkdir buildTools
    cd buildTools
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar
    echo "########### Starting Spigot build tools, this might take a while! #################"
    java -jar BuildTools.jar --rev $MC_VERSION >/dev/null
    echo "########### Spigot build done #################"
    mv spigot-$MC_VERSION.jar ../$JAR_NAME
    cd ..
fi
