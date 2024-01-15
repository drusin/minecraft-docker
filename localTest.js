#!/usr/bin/env node

/**
 * Runs all the scripts locally instead of building a Docker container for faster debugging/prototyping. Use the file "testenv.override" to change environment variables.
 */

import { $, fs, cd, path, argv } from 'zx';

if (argv.h || argv.help) {
    const message = `
    Helper script to run the container logic directly in bash, for local debugging or fast prototyping. It sets necessary environment variables and creates necessary directories. See readme for system requirements

    Usage: localTest.mjs [OPTION] [FILENAME]

    If no filename is provided, "script.mjs" will be run.

    Options:

    -c | --clean    deletes the temporary data and work directories before running logic
    -h | --help     prints this help message
    `;
    console.log(message);
    process.exit(0);
}

/**
 * Reads and sets the environment variables from a Dockerfile-like file named @param fileName
 */
const setEnv = async (fileName) => {
    (await fs.readFile(fileName, 'utf8'))
        .split('\n')
        // find all lines starting with ENV (and then remove the "ENV ")
        .filter(str => str.match('^ENV .*?'))
        // .map(line => {console.log(line);return line})    // fast debug in case env is funky
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

if (argv.c || argv.clean) {
    await $`rm -frd $WORK_DIR_NAME`;
    await $`rm -frd $DATA_DIR_NAME`;
}

await $`mkdir -p $DATA_DIR_NAME`;
await $`mkdir -p $WORK_DIR_NAME`;

const scriptDirFullPath = path.resolve(`./scripts`);

const scriptFiles = await fs.readdir('scripts');
for (let file of scriptFiles) {
    await $`ln -sf ${scriptDirFullPath}/${file} $WORK_DIR_NAME/${file}`;
}

await $`cp ferium-config.json $WORK_DIR_NAME/`;

cd(process.env.WORK_DIR_NAME);

await $`chmod +x *.js`;
// await $`chmod +x *.mjs`;
await $`chmod +x *.sh`;

const fileName = process.argv.slice(2)
    // is there a script file (.mjs or .sh) in the args?
    .find(arg => arg.match(/.*?\.(js|mjs|sh)/))
    || 'script.js'

$`./${fileName}`;
