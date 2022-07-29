#!/usr/bin/env node

import { $, fs, fetch } from 'zx';
import { safe } from './helper.js';

export default async function(E = process.env) {
    E.PLUGINS_FOLDER_NAME = 'mods';
    
    await $`mkdir $DATA_DIR/config -p`;
    await $`mkdir config -p`;
    await safe(() => $`cp $DATA_DIR/config/* config`);
    
    if (!(await fs.pathExists(E.JAR_NAME))) {
        // Find the right fabric installer for the requested Minecraft version
        const response = await fetch('https://maven.fabricmc.net/net/fabricmc/fabric-installer/maven-metadata.xml');
        const versionXML = await response.text();
        const versions = versionXML.split('\n').filter(str => str.match(/<version>.*?<\/version>/));
        const latestVersion = versions[versions.length - 1].replace(/<\/?version>/g, '').trim();
        // Download the installer and start the installation
        await $`wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/${latestVersion}/fabric-installer-${latestVersion}.jar -O fabric-installer.jar`;
    
        const args = `-jar fabric-installer.jar server -mcversion ${E.MC_VERSION} -downloadMinecraft`;
        await $`./run-java.sh ${args}`
        await $`mv fabric-server-launch.jar $JAR_NAME`;
    }

};
