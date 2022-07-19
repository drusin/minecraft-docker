#!/usr/bin/env zx

const E = process.env;

const safe = async (fun) => {
    try {
        return await fun();
    }
    catch (error) {
        // ignore
    }
}

// install Java if necessary
if (E.SKIP_JAVA == 'false' && !(await $`java --version`).stdout.match(E.JAVA_VERSION)) {
    await $`./install-java.sh`;
}
else {
    console.log('Matching Java version detected, skipping');
}

await fs.writeFile('eula.txt', `eula=${E.EULA}`);

// copy all flat data to workdir
await safe(() =>  $`cp $DATA_DIR/* ./`);


if (E.FORCE_DOWNLOAD == 'true') {
    console.log('########### deleting $JAR_NAME ###############')
    await $`rm $JAR_NAME`;
}

// download server jar and do specific setup
switch (E.TYPE) {
    case 'custom':
        //custom
        break;
    case 'fabric':
        //fabric
        break;
    case 'paper':
        await $`./paper.mjs`;
        break;
}

// bind large directories to avoid copying huge files
await $`mkdir $DATA_DIR/logs -p`;
await $`ln -sfn $DATA_DIR/logs logs`;

// bind world directories
const worlds = E.WORLDS.split(',');
for (let world of worlds) {
    await $`mkdir $DATA_DIR/${world} -p`;
    await $`ln -sfn $DATA_DIR/${world} ${world}`;
}

// bind plugins folder
await $`mkdir $DATA_DIR/$PLUGINS_FOLDER_NAME -p`;
await $`ln -sfn $DATA_DIR/$PLUGINS_FOLDER_NAME $PLUGINS_FOLDER_NAME`;

// skipping autoupdating viaversion

let args = '';
// choose correct default args
if (E.DEFAULT_ARGS == "true") {
    if (E.JAVA_IDENTIFIER == "sem") {
        console.log('########### Using default args for Semeru ###############');
        args = E.SEM_ARGS;
        // calculate gencon nursery
        args = args.replace('XMNS', E.MEMORY / 2).replace('XMNX', E.MEMORY * 4 / 5);
    }
    else {
        console.log('########### Using default args for Temurin ###############');
        args = E.TEM_ARGS;
        if (E.MEMORY < 256) {
            // remove too high Survivor Ratio
            args = args.replace('-XX:SurvivorRatio=32 ', '');
        }
    }
}


// ########################################################
// ################ Starting the server ###################
// ########################################################
const finalArgs = `-Xms${E.MEMORY}M -Xmx${E.MEMORY}M ${args} ${E.ADDITIONAL_ARGS} -jar ${E.JAR_NAME} nogui`;
console.log('########### Using the following java startup args ###############');
console.log(finalArgs);
await $`./start-server.sh ${finalArgs}`;


// ########################################################
// ########### After the server has stopped ###############
// ########################################################

console.log('########### Server has stopped, cleaning up ###############');

switch(E.TYPE) {
    case 'fabric':
        // fabric cleanup
        break;
}

// copy all settings data that were touched back before container shutdown
await safe(() => $`cp *.properties $DATA_DIR -u`);
await safe(() => $`cp *.json $DATA_DIR -u`);
await safe(() => $`cp *.yml $DATA_DIR -u`);

console.log('########### Bye! ###############');