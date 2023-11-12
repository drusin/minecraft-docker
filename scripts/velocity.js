#!/usr/bin/env node

import { fetch, $ } from 'zx';

export default async function() {
    // find the newest build for the requested Minecraft version
    const versionsResponse = await fetch(`https://papermc.io/api/v2/projects/velocity`);
    const { versions } = await versionsResponse.json();
    const lastStable = versions
            .filter(version => !version.includes('SNAPSHOT'))
            .sort()
            .pop();
    const buildsResponse = await fetch(`https://papermc.io/api/v2/projects/velocity/versions/${lastStable}/builds`);
    const { builds } = await buildsResponse.json();
    const build = builds.pop().build;
    const url = `https://papermc.io/api/v2/projects/velocity/versions/${lastStable}/builds/${build}/downloads/velocity-${lastStable}-${build}.jar`;
    await $`wget ${url} -O $JAR_NAME`;
};
