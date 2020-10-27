#!/bin/bash

versionArr=(${VERSION//./ })

# mkdir /data/plugins -p
# ln -s /data/plugins plugins
curl https://papermc.io/api/v1/waterfall/${versionArr[0]}.${versionArr[1]}/latest/download --output runme.jar