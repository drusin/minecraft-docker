#!/bin/bash

source "$HOME/.sdkman/bin/sdkman-init.sh"
sdk i java ${JAVA_VERSION}.${JAVA_VM}-${JAVA_DIST}

# accept minecraft server eula
echo "eula=true" > eula.txt

# copy all flat data to workdir
cp /data/* ./

if [ ${FORCE_DOWNLOAD} == "true" ]; then
    rm ${JAR_NAME};
fi

# download server jar and do specific setup
case ${TYPE} in
    custom)
        . ./custom.sh
        ;;
    fabric)
        . ./fabric.sh
        ;;
    forge)
        . ./forge.sh
        ;;
    paper)
        . ./paper.sh
        ;;
    waterfall)
        . ./waterfall.sh
        ;;
esac

# bind large directories to avoid copying huge files
mkdir /data/logs -p
ln -sfn /data/logs logs

# split WORLDS string into array
IFS=',' read -r -a world_array <<< ${WORLDS}

# bind worlds
for world in ${world_array[@]}
do
    mkdir /data/$world -p
    ln -sfn /data/$world $world
done

# bind plugins/mods folder
mkdir /data/${PLUGINS_FOLDER_NAME} -p
ln -sfn /data/${PLUGINS_FOLDER_NAME} ${PLUGINS_FOLDER_NAME}

if [ ${AUTO_UPDATE_VIAVERSION} == 'true' ]; then
    wget -O ${PLUGINS_FOLDER_NAME}/ViaVersion.jar http://myles.us/ViaVersion/latest.jar
fi

ARGS=""
# set correct defualt args
if [ ${DEFAULT_ARGS} == "true" ]; then
    ARGS=$([ "$JAVA_VM" == "hs" ]) && echo ${HOTSPORT_ARGS} || echo ${J9_ARGS}
fi

# calculate gencon nursery for openJ9 VM
ARGS=${ARGS/XMNS/$((MEMORY / 2))}
ARGS=${ARGS/XMNX/$((MEMORY * 4 / 5))}

# start the server
java -Xms${MEMORY}M -Xmx${MEMORY}M ${ARGS} ${ADDITIONAL_ARGS} -jar ${JAR_NAME} nogui

########################################################
########### After the server has stopped ###############
########################################################

# server specific cleanup
case ${TYPE} in
    custom)
        ;;
    fabric)
        . ./fabric-cleanup.sh
        ;;
    forge)
        ;;
    paper)
        ;;
    waterfall)
        ;;
esac

# copy all settings data that were touched back before container shutdown
cp *.properties /data/ -u
cp *.json /data/ -u
cp *.yml /data/ -u