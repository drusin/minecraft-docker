#!/usr/bin/env node

import { $, fs, cd } from 'zx';

const mapping = [['forge', 'Forge'], ['fabric', 'Fabric']];
const configFile = 'ferium-config.json';
const ferium = (E = process.env) => `./ferium -c ${configFile}`;

export default async function download(E = process.env) {
    const mapped = mapping.find(el => el[0] === E.TYPE);
    if (!mapped) {
        console.error(`Downloading mods not supported for server type ${E.TYPE}`);
        return;
    }

    const prevPath = E.PWD;

    cd(E.WORK_DIR);
    const config = fs.readJsonSync(configFile);
    config.profiles[0].game_version = E.MC_VERSION;
    config.profiles[0].mod_loader = mapped[1];
    fs.writeJSONSync(configFile, config);
    const mods = E.MODS.split(',');
    mods.forEach(async mod => await $`${ferium()} add ${mod}`);
    await $`${ferium()} upgrade`;
    
    cd(prevPath);
}

await download();
