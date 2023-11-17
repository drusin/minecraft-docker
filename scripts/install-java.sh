#!/bin/bash
source "${SDKMAN_DIR}/bin/sdkman-init.sh"
rm -f .sdkmanrc
echo "########### installing $JAVA_VERSION-$JAVA_IDENTIFIER ###############"
sdk update
sdk i java $JAVA_VERSION-$JAVA_IDENTIFIER
echo "java="$JAVA_VERSION-$JAVA_IDENTIFIER > .sdkmanrc
