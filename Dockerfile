FROM ubuntu:20.04

# API, use for configuration
ENV JAVA_VERSION="11.0.11"
ENV JAVA_VM="hs"
ENV TYPE="paper"
ENV MC_VERSION="1.16.3"
ENV MEMORY="4096"
ENV DEFAULT_ARGS="true"
ENV ADDITIONAL_ARGS=""
ENV WORLDS="world,world_nether,world_the_end"
ENV FORCE_DOWNLOAD="false"
ENV AUTO_UPDATE_VIAVERSION="false"
ENV FABRIC_INSTALLER_VERSION="0.7.3"
ENV FORGE_VERSION="34.1.0"

# Only might need touching for custom jars
ENV JAR_NAME="runme.jar"
ENV PLUGINS_FOLDER_NAME="plugins"

# Change if you don't want to use java from adoptopenjdk.net
ENV JAVA_DIST="adpt"

# No need to touch these
ENV HOTSPORT_ARGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
ENV J9_ARGS="-XmnsXMNSM -XmnxXMNXM -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc -Xtune:virtualized"

SHELL ["/bin/bash", "-c"]

# Prepare folder structure
RUN mkdir /data
WORKDIR /home/minecraft/
VOLUME /data

# Copy necessary files and make them executable
COPY *.sh ./
RUN chmod +x *.sh

# Install sdkman and its dependencies
RUN apt-get update -y && apt-get install zip unzip wget curl -y
#RUN apt install zip unzip wget curl -y
RUN curl -s "https://get.sdkman.io?rcupdate=false" | bash

EXPOSE 25565

ENTRYPOINT "./script.sh"