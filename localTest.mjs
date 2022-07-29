#!/usr/bin/env node

/**
 * Runs all the scripts locally instead of building a Docker container for faster debugging/prototyping. Use the file "testenv.override" to change environment variables.
 */

import { $, fs, cd } from 'zx';

/**
 * Reads and sets the environment variables from a Dockerfile-like file named @param fileName
 */
const setEnv = async (fileName) => {
    (await fs.readFile(fileName, 'utf8'))
        .split('\n')
        // find all lines starting with ENV (and then remove the "ENV ")
        .filter(str => str.match('ENV .*?'))
        .map(str => str.replace('ENV ', ''))
        // split on the first "=" only
        .map(str => str.split(/=(.*)/))
        // set vars to environment (also remove the quotes from the values)
        .forEach(arr => process.env[arr[0]] = arr[1].substring(1, arr[1].length -1))
        ;
}

await setEnv('Dockerfile');
await setEnv('testenv');
await setEnv('testenv.override');

await $`mkdir -p $DATA_DIR_NAME`;
await $`mkdir -p $WORK_DIR`;

await $`cp ./scripts/* $WORK_DIR`;

cd(process.env.WORK_DIR);

$`./script.mjs`;
