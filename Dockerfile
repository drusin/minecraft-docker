FROM node:16

# API, use for configuration
ENV JAVA_VERSION="17.0.3"
ENV JAVA_IDENTIFIER="tem"
ENV TYPE="paper"
ENV MC_VERSION="1.19"
ENV MEMORY="4096"
ENV EULA="false"
ENV DEFAULT_ARGS="true"
ENV ADDITIONAL_ARGS=""
ENV WORLDS="world,world_nether,world_the_end"
ENV FORCE_DOWNLOAD="false"
ENV AUTO_UPDATE_VIAVERSION="false"

# Only might need touching for custom jars
ENV JAR_NAME="runme.jar"
ENV PLUGINS_FOLDER_NAME="plugins"

# No need to touch these
ENV TEM_ARGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
ENV SEM_ARGS="-XmnsXMNSM -XmnxXMNXM -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc -Xtune:virtualized"

ENV START_COMMAND="-jar $JAR_NAME nogui"

# Necessary for local testing only
ENV SKIP_JAVA="false"
ENV DATA_DIR_NAME="data"
ENV DATA_DIR="/${DATA_DIR_NAME}/"
ENV WORK_DIR="./"
ENV JAVA_PATH="/root/.sdkman/candidates/java/current/bin/java"

SHELL ["/bin/bash", "-c"]

# Install zx
RUN npm install --location=global zx

# Install dependencies for sdkman and sdkman itself
RUN apt-get update -y && apt-get install zip unzip wget curl -y
RUN curl -s "https://get.sdkman.io?rcupdate=false" | bash

# Prepare folder structure
RUN mkdir /data
WORKDIR /home/minecraft/
VOLUME /data

# Copy necessary files and make them executable
COPY /scripts/* ./
RUN chmod +x *.sh
RUN chmod +x *.mjs

EXPOSE 25565

ENTRYPOINT "./script.mjs"