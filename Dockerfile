FROM adoptopenjdk/openjdk11:jre-11.0.8_10-alpine

ENV TYPE=paper
ENV VERSION=1.16.3
ENV MEMORY=4G
ENV ARGS='-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true'
ENV ADDITIONAL_ARGS=''

RUN apk add curl bash
RUN mkdir /data

WORKDIR /home/minecraft/

EXPOSE 25565

VOLUME /data

COPY *.sh ./
RUN chmod +x *.sh

ENTRYPOINT "./script.sh"