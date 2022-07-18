#!/usr/bin/env zx

const setVars = async (fileName) => {
    (await fs.readFile(fileName, 'utf8'))
        .split('\n')
        .filter(str => str.match('ENV .*?'))
        .map(str => str.replace('ENV ', ''))
        .map(str => str.split(/=(.*)/))
        .forEach(arr => process.env[arr[0]] = arr[1].substring(1, arr[1].length -1))
        ;
}

await setVars('Dockerfile');
await setVars('.env');

cd('scripts');

$`./script.mjs`;