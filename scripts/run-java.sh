#!/bin/bash

if [ $SKIP_JAVA == "false" ]
then
    source "${SDKMAN_DIR}/bin/sdkman-init.sh"
    sdk env install
fi

java -Xms${MEMORY}M -Xmx${MEMORY}M $@
