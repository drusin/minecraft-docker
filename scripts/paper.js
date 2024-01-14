#!/usr/bin/env node

import { fetch, $ } from 'zx';

export default async function(E = process.env) {
    // find the newest build for the requested Minecraft version
    const response = await fetch(`https://papermc.io/api/v2/projects/paper/versions/${E.MC_VERSION}`);
    const { builds } = await response.json();
    const build = builds.pop();
    const url = `https://papermc.io/api/v2/projects/paper/versions/${E.MC_VERSION}/builds/${build}/downloads/paper-${E.MC_VERSION}-${build}.jar`;
    await $`wget ${url} -O $JAR_NAME`;
};
