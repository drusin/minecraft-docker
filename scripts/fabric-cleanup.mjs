#!/usr/bin/env zx

// ####################################################
// ###### Important! Used for fabric AND forge! #######
// ####################################################

import { safe } from "./helper.js";

await safe(() => $`cp config/* $DATA_DIR/config -ru`);
