#!/bin/bash

source "${SDKMAN_DIR}/bin/sdkman-init.sh"
sdk env install

java -Xms${MEMORY}M -Xmx${MEMORY}M $1 $2
