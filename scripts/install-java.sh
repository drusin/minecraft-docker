#!/bin/bash
source "${SDKMAN_DIR}/bin/sdkman-init.sh"
echo "########### installing $JAVA_VERSION-$JAVA_IDENTIFIER ###############"
sdk update
sdk i java $JAVA_VERSION-$JAVA_IDENTIFIER
rm -f .sdkmanrc
sdk env init
