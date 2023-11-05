#!/bin/bash
source "$HOME/.sdkman/bin/sdkman-init.sh"
echo "########### installing $JAVA_VERSION-$JAVA_IDENTIFIER ###############"
sdk update
sdk i java $JAVA_VERSION-$JAVA_IDENTIFIER
rm -f .sdkmanrc
sdk env init
