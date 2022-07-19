#!/usr/bin/env zx

process.env.PLUGINS_FOLDER_NAME = 'mods';

await $`mkdir $DATA_DIR/config -p`;
await $`mkdir config -p`;
try {
    await $`cp $DATA_DIR/config/* config`;
}
catch (error) {
    // cp is stupid
}

if (!(await fs.exists(process.env.JAR_NAME))) {
    const response = await fetch('https://maven.fabricmc.net/net/fabricmc/fabric-installer/maven-metadata.xml');
    const versionXML = await response.text();
    const versions = versionXML.split('\n').filter(str => str.match(/<version>.*?<\/version>/));
    const latestVersion = versions[versions.length - 1].replace(/<\/?version>/g, '').trim();
    await $`wget https://maven.fabricmc.net/net/fabricmc/fabric-installer/${latestVersion}/fabric-installer-${latestVersion}.jar -O fabric-installer.jar`;

    const args = `-jar fabric-installer.jar server -mcversion ${process.env.MC_VERSION} -downloadMinecraft`;
    await $`./run-java.sh ${args}`
    await $`mv fabric-server-launch.jar $JAR_NAME`;
}