#!/bin/bash

# calculate gencon nursery for openJ9 VM if needed
ARGS=${ARGS/XMNS/$((MEMORY / 2))}
ARGS=${ARGS/XMNX/$((MEMORY * 4 / 5))}

# accept minecraft server eula
echo "eula=true" > eula.txt

# copy all flat data to workdir
cp /data/* ./

# bind large directories to avoid copying huge files
mkdir /data/logs -p
ln -sfn /data/logs logs
if [ ${TYPE} != 'waterfall' ]; then
    mkdir /data/world -p
    ln -sfn /data/world world
    mkdir /data/world_nether -p
    ln -sfn /data/world_nether world_nether
    mkdir /data/world_the_end -p
    ln -sfn /data/world_the_end world_the_end
fi

# download server jar and do specific setup
case ${TYPE} in
paper)
    ./paper.sh
    ;;
fabric)
    ./fabric.sh
    ;;
waterfall)
    ./waterfall.sh
    ;;
esac

java -Xms${MEMORY}M -Xmx${MEMORY}M ${ARGS} ${ADDITIONAL_ARGS} -jar runme.jar nogui

# copy all settings data that might have been touched back
cp *.properties /data/
cp *.json /data/
cp *.yml /data/
