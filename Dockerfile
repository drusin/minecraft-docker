ARG IMAGE=adoptopenjdk/openjdk11:jre-11.0.8_10-alpine
FROM ${IMAGE}

# default args for hotspot VM
ARG DEFAULT_ARGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
# default args for openJ9 VM
# ARG DEFAULT_ARGS="-XmnsXMNSM -XmnxXMNXM -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc -Xtune:virtualized"

# API, use for configuration
ENV TYPE=paper
ENV MC_VERSION=1.16.3
ENV FORGE_VERSION=34.1.0
ENV MEMORY=4096
ENV ARGS=${DEFAULT_ARGS}
ENV ADDITIONAL_ARGS=""
ENV WORLDS="world,world_nether,world_the_end"
ENV FORCE_DOWNLOAD="false"
ENV AUTO_UPDATE_VIAVERSION="false"
ENV JAR_NAME="runme.jar"
ENV PLUGINS_FOLDER_NAME="plugins"

# for scripting and interacting with the container
RUN apk add --no-cache bash

RUN mkdir /data

WORKDIR /home/minecraft/

EXPOSE 25565

VOLUME /data

COPY *.sh ./
RUN chmod +x *.sh

ENTRYPOINT "./script.sh"
