#!/usr/bin/env zx

// ####################################################
// ###### Important! Used for fabric AND forge! #######
// ####################################################

try {
    await $`cp config/* $DATA_DIR/config -ru`;
}
catch (error) {
    //ignore
}