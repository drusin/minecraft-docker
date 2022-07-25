#!/usr/bin/env node

import { $, fs } from 'zx';

const E = process.env;

const safe = async (fun) => {
    try {
        return await fun();
    }
    catch (error) {
        // ignore
    }
};

// install Java if necessary
const installedJavaVersion = await safe(() => $`java --version`);
if (E.SKIP_JAVA == 'false' && (!installedJavaVersion || !installedJavaVersion.stdout.match(E.JAVA_VERSION))) {
    await $`./install-java.sh`;
}
else {
    console.log('Matching Java version detected, skipping');
}

await fs.writeFile('eula.txt', `eula=${E.EULA}`);

// copy all flat data to workdir
await safe(() =>  $`cp $DATA_DIR/* ./`);

if (E.FORCE_DOWNLOAD == 'true') {
    console.log(`########### deleting ${E.JAR_NAME} ###############`)
    await $`rm $JAR_NAME`;
}

// download server jar and do specific setup
switch (E.TYPE) {
    case 'custom':
        await $`./custom.sh`;
        break;
    case 'fabric':
        await $`./fabric.mjs`
        break;
    case 'forge':
        await $`./forge.mjs`
        break;
    case 'paper':
        await $`./paper.mjs`;
        break;
    case 'spigot':
        await $`./spigot.sh`
        break;
    case 'waterfall':
        await $`./waterfall.mjs`
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

await $`echo $PLUGINS_FOLDER_NAME`;
// bind plugins folder
await $`mkdir $DATA_DIR/$PLUGINS_FOLDER_NAME -p`;
await $`ln -sfn $DATA_DIR/$PLUGINS_FOLDER_NAME $PLUGINS_FOLDER_NAME`;

// skipping autoupdating viaversion

let defaultArgs = '';
// choose correct default args
if (E.DEFAULT_ARGS == "true") {
    if (E.JAVA_IDENTIFIER == "sem") {
        console.log('########### Using default args for Semeru ###############');
        defaultArgs = E.SEM_ARGS;
        // calculate gencon nursery
        defaultArgs = defaultArgs.replace('XMNS', E.MEMORY / 2).replace('XMNX', E.MEMORY * 4 / 5);
    }
    else {
        console.log('########### Using default args for Temurin ###############');
        defaultArgs = E.TEM_ARGS;
        if (E.MEMORY < 256) {
            // remove too high Survivor Ratio
            defaultArgs = defaultArgs.replace('-XX:SurvivorRatio=32 ', '');
        }
    }
}


// ########################################################
// ################ Starting the server ###################
// ########################################################
console.log(E.START_COMMAND);
await $`echo $START_COMMAND`;
const finalArgs = `-Xms${E.MEMORY}M -Xmx${E.MEMORY}M ${defaultArgs} ${E.ADDITIONAL_ARGS} ${E.START_COMMAND}`;
console.log('########### Using the following java startup args ###############');
console.log(finalArgs);
await $`./run-java.sh ${finalArgs}`;


// ########################################################
// ########### After the server has stopped ###############
// ########################################################

console.log('########### Server has stopped, cleaning up ###############');

switch(E.TYPE) {
    case 'fabric':
    case 'forge':
        await $`./fabric-cleanup.mjs`;
        break;
}

// copy all settings data that were touched back before container shutdown
await safe(() => $`cp *.properties $DATA_DIR -u`);
await safe(() => $`cp *.json $DATA_DIR -u`);
await safe(() => $`cp *.yml $DATA_DIR -u`);

console.log('########### Bye! ###############');