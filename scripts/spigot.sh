#!/bin/bash

export PLUGINS_FOLDER_NAME="plugins"

if [ ! -f $JAR_NAME ]; then
    apt-get install git -y
    git config --global --unset core.autocrlf
    mkdir buildTools
    cd buildTools
    wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar
    java -jar BuildTools.jar --rev $MC_VERSION
    mv spigot-$MC_VERSION.jar ../$JAR_NAME
    cd ..
fi