#!/bin/bash

push="false"

while getopts 'p' flag; do
    case ${flag} in
        p) push="true"
    esac
done

TAG_FILE="tag"

read -r tag<$TAG_FILE

NAME="dawidr/minecraft-docker"

HOTSPOT_VMS=(adoptopenjdk/openjdk11:jre-11.0.8_10-alpine adoptopenjdk/openjdk15:jre-15_36-alpine)
HOTSPOT_ARGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true"

J9_VMS=(adoptopenjdk/openjdk11-openj9:jre-11.0.8_10_openj9-0.21.0-alpine adoptopenjdk/openjdk15-openj9:jre-15_36_openj9-0.22.0-alpine)
J9_ARGS="-XmnsXMNSM -XmnxXMNXM -Xgc:concurrentScavenge -Xgc:dnssExpectedTimeRatioMaximum=3 -Xgc:scvNoAdaptiveTenure -Xdisableexplicitgc"

build()
{
    VM=$1
    ARGS=$2
    VERSION=$3
    docker build --build-arg IMAGE=$VM --build-arg DEFAULT_ARGS="$ARGS" -t $NAME-$VERSION:$tag -t $NAME_$VERSION:latest .
    if [ ${push} == "true" ]; then
        docker push $NAME_$VERSION:$tag
        docker push $NAME_$VERSION:$latest
    fi
}

build ${HOTSPOT_VMS[0]} "$HOTSPOT_ARGS" "11hotspot"
build ${HOTSPOT_VMS[1]} "$HOTSPOT_ARGS" "15hotspot"

build ${J9_VMS[0]} "$J9_ARGS" "11openj9"
build ${J9_VMS[1]} "$J9_ARGS" "15openj9"

if [ ${push} == "true" ]; then
    git tag $tag
    echo "$(($tag + 1))" > $TAG_FILE
    git add .
    git commit -m "increasing tag number"
    git push
fi