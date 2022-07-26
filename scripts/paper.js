#!/usr/bin/env node

import { fs, fetch, $ } from 'zx';

export default async function(E = process.env) {
    E.PLUGINS_FOLDER_NAME = 'plugins';
    
    if (!(await fs.pathExists(E.JAR_NAME))) {
        const response = await fetch(`https://papermc.io/api/v2/projects/paper/versions/${E.MC_VERSION}`);
        const { builds } = await response.json();
        const build = builds[builds.length - 1];
        const url = `https://papermc.io/api/v2/projects/paper/versions/${E.MC_VERSION}/builds/${build}/downloads/paper-${E.MC_VERSION}-${build}.jar`;
        await $`wget ${url} -O $JAR_NAME`;
    }
}