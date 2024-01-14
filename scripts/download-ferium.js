#!/usr/bin/env node

import { $, fetch } from 'zx';

const RELEASES_URL = 'https://api.github.com/repos/gorilla-devs/ferium/releases';
const ARM_NAME = 'ferium-linux-arm64-nogui.zip';
const AMD_NAME = 'ferium-linux-nogui.zip';

const isArm = (await $`uname -m`).stdout.includes(`aarch`);
const assetName = isArm ? ARM_NAME : AMD_NAME;
let response = await fetch(RELEASES_URL);
const releases = await response.json();
response = await fetch(releases[0].assets_url);
const assets = await response.json()
const toDownload = assets.find(el => el.name === assetName);
await $`wget ${toDownload.browser_download_url} -O $WORK_DIR/ferium-arch.zip`;
await $`unzip $WORK_DIR/ferium-arch.zip -d $WORK_DIR`;
