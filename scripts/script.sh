#!/bin/bash

source "$HOME/.sdkman/bin/sdkman-init.sh"

if ! java -version 2>&1 >/dev/null | grep -q $JAVA_VERSION ; then
    echo "########### installing $JAVA_VERSION-$JAVA_IDENTIFIER ###############"
    sdk update
    sdk i java $JAVA_VERSION-$JAVA_IDENTIFIER
fi

echo "eula=$EULA" > eula.txt

# copy all flat data to workdir
cp /data/* ./

if [ $FORCE_DOWNLOAD == "true" ]; then
    echo "########### deleting $JAR_NAME ###############"
    rm $JAR_NAME;
fi

# download server jar and do specific setup
case $TYPE in
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
    spigot)
        . ./spigot.sh
        ;;
    waterfall)
        . ./waterfall.sh
        ;;
esac

# bind large directories to avoid copying huge files
mkdir /data/logs -p
ln -sfn /data/logs logs

# split WORLDS string into array
IFS=',' read -r -a world_array <<< $WORLDS

# bind worlds
for world in ${world_array[@]}
do
    mkdir /data/${world} -p
    ln -sfn /data/${world} ${world}
done

# bind plugins/mods folder
mkdir /data/$PLUGINS_FOLDER_NAME -p
ln -sfn /data/$PLUGINS_FOLDER_NAME $PLUGINS_FOLDER_NAME

if [ $AUTO_UPDATE_VIAVERSION == 'true' ]; then
    echo "########### Downloading latest version of ViaVersion ###############"
    wget -O $PLUGINS_FOLDER_NAME/ViaVersion.jar http://myles.us/ViaVersion/latest.jar
fi

ARGS=""
# set correct defualt args
if [ $DEFAULT_ARGS == "true" ]; then
    if [ $JAVA_IDENTIFIER == "sem" ]; then
        echo "########### Using default args for Semeru ###############"
        ARGS=$SEM_ARGS
        # calculate gencon nursery for openJ9 VM
        ARGS=${ARGS/XMNS/$((MEMORY / 2))}
        ARGS=${ARGS/XMNX/$((MEMORY * 4 / 5))}
    else
        echo "########### Using default args for Temurin ###############"
        ARGS=$TEM_ARGS
        if [ $MEMORY < 256 ]; then
            # remove the too high Survivor Ratio
            ARGS=${ARGS/-XX:SurvivorRatio=32 /}
        fi
    fi
fi



# start the server
FINAL_ARGS="-Xms${MEMORY}M -Xmx${MEMORY}M $ARGS $ADDITIONAL_ARGS -jar $JAR_NAME nogui"
echo "########### Using the following java startup args ###############"
echo $FINAL_ARGS
java $FINAL_ARGS

########################################################
########### After the server has stopped ###############
########################################################

echo "########### Server has stopped, cleaning up ###############"

# server specific cleanup
case $TYPE in
    custom)
        ;;
    fabric)
        . ./fabric-cleanup.sh
        ;;
    forge)
        ;;
    paper)
        ;;
    spigot)
        ;;
    waterfall)
        ;;
esac

# copy all settings data that were touched back before container shutdown
cp *.properties /data/ -u
cp *.json /data/ -u
cp *.yml /data/ -u

echo "########### Bye! ###############"