ARG IMAGE=adoptopenjdk/openjdk11:jre-11.0.8_10-alpine
FROM ${IMAGE}

# default args for hotspot VM
ARG DEFAULT_ARGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"
# default args for openJ9 VM
# ARG DEFAULT_ARGS="-XmnsXMNSM -XmnxXMNXM -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc"

# API, use for configuration
ENV TYPE=paper
ENV VERSION=1.16.3
ENV MEMORY=4096
ENV ARGS=${DEFAULT_ARGS}
ENV ADDITIONAL_ARGS=""
ENV WORLDS="world,world_nether,world_the_end"
ENV FORCE_DOWNLOAD="true"
ENV AUTO_UPDATE_VIAVERSION="false"
ENV AUTO_PAUSE="false"
ENV BEFORE_FIRST_PAUSE=5

# Just globals, shouldn't need changing
ENV JAR_NAME="runme.jar"

# for scripting and interacting with the container
RUN apk add --no-cache bash
# to delay enabling cron
RUN apk add --no-cache at
# to check if someone tries to connect
RUN apk add --no-cache knock

RUN mkdir /data

WORKDIR /home/minecraft/

EXPOSE 25565

VOLUME /data

COPY *.sh ./
RUN chmod +x *.sh
COPY crontab ./crontab
COPY knockd.conf /etc/knockd.conf

ENTRYPOINT "./script.sh"