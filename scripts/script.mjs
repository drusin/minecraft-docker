#!/usr/bin/env node

/**
 * The main script run in the Docker container. Installs Java, downloads the server, binds directories, copies files, runs the server...
 */

import { safe } from './helper.js';
import { $, cd, fs } from 'zx';
import paper from './paper.js';
import fabric from './fabric.js';
import forge from './forge.js';
import velocity from './velocity.js';
import waterfall from './waterfall.js';

const E = process.env;

cd(E.DATA_DIR);
fs.writeFileSync('eula.txt', `eula=${E.EULA}`);

// install Java if necessary
const installedJavaVersion = await safe(() => $`java --version`);
if (E.SKIP_JAVA == 'false' && (!installedJavaVersion || !installedJavaVersion.stdout.match(E.JAVA_VERSION))) {
    await $`$WORK_DIR/install-java.sh`;
}
else {
    console.log('Matching Java version detected, skipping');
}

const prefs = fs.existsSync('.minecraft-docker') ? JSON.parse(fs.readFileSync('.minecraft-docker')) : {};

if (E.TYPE != 'custom' && (!fs.existsSync(E.JAR_NAME) || E.FORCE_DOWNLOAD == 'true' || prefs.mcVersion != E.MC_VERSION || prefs.type != E.TYPE)) {
    console.log(`########### deleting ${E.JAR_NAME} ###############`);
    await safe(() => $`rm $JAR_NAME`);
    await getJar();
}
else {
    console.log(`########### reusing existing ${E.JAR_NAME} ###########`);
}

prefs.mcVersion = E.MC_VERSION;
prefs.type = E.TYPE;
fs.writeFileSync('.minecraft-docker', JSON.stringify(prefs, null, '  '));

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
const finalArgs = `${defaultArgs} ${E.ADDITIONAL_ARGS} ${E.START_COMMAND}`;
console.log('########### Using the following java startup args ###############');
console.log(finalArgs);
await $`$WORK_DIR/run-java.sh ${finalArgs}`;

// ############### Server has stopped #####################
console.log('########### Bye! ###############');


async function getJar() {
    cd(E.WORK_DIR);
    // download server jar and do specific setup
    switch (E.TYPE) {
        case 'custom':
            await $`./custom.sh`;
            break;
        case 'fabric':
            await fabric(E);
            break;
        case 'forge':
            await forge(E);
            break;
        case 'paper':
            await paper(E);
            break;
        case 'spigot':
            await $`./spigot.sh`
            break;
        case 'velocity':
            await velocity();
            break;
        case 'waterfall':
            await waterfall(E);
            break;
        default:
            // no supported Minecraft server type detected
            console.error(`Unsupported server type ${E.TYPE} - aborting!`);
            await $`exit 1`;
    }
    await $`cp $JAR_NAME $DATA_DIR`
    cd(E.DATA_DIR);
}
