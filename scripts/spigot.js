#!/usr/bin/env node

import { $ } from 'zx';

export default async function (E = process.env) {
    await $`wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar -O BuildTools.jar`;
    console.log('########### Starting Spigot build tools, this might take a while! #################');
    await $`$WORK_DIR/run-java.sh -jar BuildTools.jar --rev ${E.MC_VERSION} >/dev/null`;
    console.log('########### Spigot build done #################');
    await $`mv spigot-${E.MC_VERSION}.jar ${E.JAR_NAME}`;
}