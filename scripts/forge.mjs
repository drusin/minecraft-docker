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

if (!(await fs.exists(process.env.JAR_NAME)) && false) {
    const response = await fetch('https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json');
    const { promos } = await response.json();

    const matches = Object.getOwnPropertyNames(promos).filter(name => name.match(new RegExp(`${process.env.MC_VERSION}-.*?`)));
    if (matches.length == 0) {
        console.error(`No forge installer compatible with version ${process.env.MC_VERSION} found. Aborting...`);
        process.exit(1);
    }

    const recommended = matches.find(vers => vers.match(/.*?recommended/));
    const versionToUse = recommended ? promos[recommended] : promos[matches[0]];

    await $`wget https://files.minecraftforge.net/maven/net/minecraftforge/forge/$MC_VERSION-${versionToUse}/forge-$MC_VERSION-${versionToUse}-installer.jar -O forge-installer.jar`;

    console.log('############## Installing Forge, this might take a while! ###########')
    const args = '-jar forge-installer.jar server --installServer';
    await $`./run-java.sh ${args}`;
    console.log('############## Forge installation done! ###########')

    
    // await $`mv forge-$MC_VERSION-${versionToUse}.jar $JAR_NAME`;
}

$`echo "fake jar for forge" > $JAR_NAME`;

const forgeArgsFile = (await fs.readFile(`./run.sh`, 'utf-8'))
    .split('\n')
    .find(str => !str.startsWith('#'))
    .split(' ')
    .find(str => str.startsWith('@libraries'))
    ;

process.env.START_COMMAND = forgeArgsFile;

await $`echo $START_COMMAND`;