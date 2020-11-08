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
    # split WORLDS string into array
    IFS=',' read -r -a world_array <<< ${WORLDS}
    
    # bind worlds
    for world in ${world_array[@]}
    do
        mkdir /data/$world -p
        ln -sfn /data/$world $world
    done
fi

if [ ${FORCE_DOWNLOAD} == "true" ]; then
    rm ${JAR_NAME};
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

java -Xms${MEMORY}M -Xmx${MEMORY}M ${ARGS} ${ADDITIONAL_ARGS} -jar ${JAR_NAME} nogui

# copy all settings data that were touched back
cp *.properties /data/ -u
cp *.json /data/ -u
cp *.yml /data/ -u
