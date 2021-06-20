#!/bin/bash

NAME="dawidr/minecraft-docker"
PLATFORMS="linux/amd64,linux/arm64,linux/arm/v7"

VERSION_FILE="version"
read -r version<$VERSION_FILE
versionArr=(${version//./ })

push="false"

for arg in "$@"
do
    case $arg in
        -p|--push)
            push="true"
            shift
            ;;
        -v=p|--patch)
            versionArr[2]=$((${versionArr[2]} + 1))
            shift
            ;;
        -v=mi|--minor)
            versionArr[1]=$((${versionArr[1]} + 1))
            versionArr[2]=0
            shift
            ;;
        -v=ma|--major)
            versionArr[0]=$((${versionArr[0]} + 1))
            versionArr[1]=0
            versionArr[2]=0
            shift
            ;;
    esac
done

newVersion=${versionArr[0]}.${versionArr[1]}.${versionArr[2]}
echo $newVersion > $VERSION_FILE

if [ ${push} == "true" ]; then
    docker buildx build -t $NAME:v$newVersion -t $NAME:v${versionArr[0]} -t $NAME:v${versionArr[0]}.${versionArr[1]} -t$NAME:latest --platform $PLATFORMS --push .
else
    docker build -t $NAME:v$newVersion -t $NAME:v${versionArr[0]} -t $NAME:v${versionArr[0]}.${versionArr[1]} .
fi

if [ ${push} == "true" ]; then
    git tag v$newVersion
    git push origin v$newVersion
    git add .
    git commit -m "increasing version number"
    git push
fi