#!/usr/bin/env node

import { $, fetch } from 'zx';

export default async function (E = process.env) {
    const versionSplit = E.MC_VERSION.split('.');
    // Waterfall ignores patch versions...
    const waterfallVersion = `${versionSplit[0]}.${versionSplit[1]}`;
    const response = await fetch(`https://api.papermc.io/v2/projects/waterfall/versions/${waterfallVersion}`);
    const { builds } = await response.json();
    const build = builds.pop();
    const url = `https://api.papermc.io/v2/projects/waterfall/versions/${waterfallVersion}/builds/${build}/downloads/waterfall-${waterfallVersion}-${build}.jar`;
    await $`wget ${url} -O $JAR_NAME`;
};
