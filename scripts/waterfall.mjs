#!/usr/bin/env zx

process.env.PLUGINS_FOLDER_NAME = 'plugins';
process.env.WORLDS = '';

await $`mkdir $DATA_DIR/modules -p`;
await $`ln -sfn $DATA_DIR/modules modules`;

if (!(await fs.exists(process.env.JAR_NAME))) {
    const versionSplit = process.env.MC_VERSION.split('.');
    const waterfallVersion = `${versionSplit[0]}.${versionSplit[1]}`;
    const response = await fetch(`https://papermc.io/api/v2/projects/waterfall/versions/${waterfallVersion}`);
    const { builds } = await response.json();
    const build = builds[builds.length - 1];
    const url = `https://papermc.io/api/v2/projects/waterfall/versions/${waterfallVersion}/builds/${build}/downloads/waterfall-${waterfallVersion}-${build}.jar`;
    await $`wget ${url} -O $JAR_NAME`;
}