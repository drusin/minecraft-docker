#!/bin/bash

# make sure the important dirs exist and make softlinks to the workdir to avoid copying of huge files
mkdir /data/world -p
ln -s /data/world world
mkdir /data/world_nether -p
ln -s /data/world_nether world_nether
mkdir /data/world_the_end -p
ln -s /data/world_the_end world_the_end
mkdir /data/logs -p
ln -s /data/logs logs

# accept minecraft server eula
echo "eula=true" > eula.txt

# copy all flat data to workdir
cp /data/* ./

# download server jar and do specific setup
case ${TYPE} in
paper)
    ./paper.sh
    ;;
fabric)
    ./fabric.sh
    ;;
esac

java -Xms${MEMORY} -Xmx${MEMORY} ${ARGS} ${ADDITIONAL_ARGS} -jar runme.jar nogui

# copy all settings data that might have been touched back
cp *.properties /data/
cp *.json /data/
cp *.yml /data/
