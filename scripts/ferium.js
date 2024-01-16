#!/usr/bin/env node

import { $, fs, path } from 'zx';

const MAPPING = [['forge', 'Forge'], ['fabric', 'Fabric']];
const CONFIG_FILE_NAME = 'ferium-config.json';

export async function downloadMods(E = process.env) {
    const configFile = path.resolve(`${E.WORK_DIR}/${CONFIG_FILE_NAME}`);
    const ferium = (...args) => [`${E.WORK_DIR}/ferium`, '-c' , configFile, ...args];

    const mapped = MAPPING.find(el => el[0] === E.TYPE);
    if (!mapped) {
        console.error(`Downloading mods not supported for server type ${E.TYPE}`);
        return;
    }

    const config = fs.readJsonSync(configFile);
    config.profiles[0].game_version = E.MC_VERSION;
    config.profiles[0].output_dir = path.resolve(`${E.DATA_DIR}/mods`);
    config.profiles[0].mod_loader = mapped[1];
    config.profiles[0].mods = [];
    fs.writeJSONSync(configFile, config);
    const mods = E.MODS.split(',');
    for (const mod of mods) {
        await $`${ferium('add', mod, '--dependencies', 'required')}`;
    }
    await $`${ferium('upgrade')}`;
}

export function feriumInstalled(E = process.env) {
    return fs.existsSync(`${E.WORK_DIR}/ferium`);
}
