#!/bin/bash

mkdir /data/plugins -p
ln -s /data/plugins plugins
curl https://papermc.io/api/v1/paper/${VERSION}/latest/download --output runme.jar