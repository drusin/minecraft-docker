#!/usr/bin/env zx

try {
    await $`cp config/* $DATA_DIR/config -ru`;
}
catch (error) {
    //ignore
}