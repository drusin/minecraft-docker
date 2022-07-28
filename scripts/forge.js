#!/usr/bin/env node

import { $, fs, fetch } from 'zx';
import { safe } from './helper.js';

export default async function (E = process.env) {
    E.PLUGINS_FOLDER_NAME = 'mods';
    
    await $`mkdir $DATA_DIR/config -p`;
    await $`mkdir config -p`;
    await safe(() => $`cp $DATA_DIR/config/* config`);
    
    if (!(await fs.pathExists(E.JAR_NAME))) {
        const response = await fetch('https://files.minecraftforge.net/net/minecraftforge/forge/promotions_slim.json');
        const { promos } = await response.json();
    
        const matches = Object.getOwnPropertyNames(promos).filter(name => name.startsWith(`${E.MC_VERSION}-`));
        if (matches.length == 0) {
            console.error(`No forge installer compatible with version ${E.MC_VERSION} found. Aborting...`);
            process.exit(1);
        }
    
        const recommended = matches.find(vers => vers.match(/.*?recommended/));
        const versionToUse = recommended ? promos[recommended] : promos[matches[0]];
    
        await $`wget https://files.minecraftforge.net/maven/net/minecraftforge/forge/$MC_VERSION-${versionToUse}/forge-$MC_VERSION-${versionToUse}-installer.jar -O forge-installer.jar`;
    
        console.log('############## Installing Forge, this might take a while! ###########')
        const args = '-jar forge-installer.jar server --installServer';
        await $`./run-java.sh ${args} >/dev/null`;
        console.log('############## Forge installation done! ###########')
    }
    
    $`echo "fake jar for forge" > $JAR_NAME`;
    
    const forgeArgsFile = (await fs.readFile(`./run.sh`, 'utf-8'))
        .split('\n')
        .find(str => !str.startsWith('#'))
        .split(' ')
        .find(str => str.startsWith('@libraries'))
        ;
    
    E.START_COMMAND = forgeArgsFile;
    
    await $`echo $START_COMMAND`;

};
