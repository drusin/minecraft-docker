#!/usr/bin/env zx

process.env.PLUGINS_FOLDER_NAME = 'plugins';
if (!(await fs.exists(process.env.JAR_NAME))) {
    const response = await fetch(`https://papermc.io/api/v2/projects/paper/versions/${process.env.MC_VERSION}`);
    const { builds } = await response.json();
    const build = builds[builds.length - 1];
    const url = `https://papermc.io/api/v2/projects/paper/versions/${process.env.MC_VERSION}/builds/${build}/downloads/paper-${process.env.MC_VERSION}-${build}.jar`;
    await $`wget ${url} -O $JAR_NAME`;
}