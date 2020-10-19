# minecraft-docker
A simple docker container that automatically downloads and starts a minecraft server.

## Usage
Mount a read/write volume to `/data`, to persist worlds and server settings. If the volume already contains worlds, config files or plugins/mods the server will use those and they will be updated during runtime. It is not possible to change server config using environment variables, please use the regular server config files in the volume.

## Environment
Name | Default value | Description
--- | --- | ---
TYPE | paper | Which server jar to use. Currently supported: paper, fabric (coming soon: waterfall)
VERSION | 1.16.3 | Which Minecraft version to use
MEMORY | 4096 | How much RAM to allocate for the server (in MB)
ARGS | Optimal command line args (see Description) | Which arguments to pass to the Java process. Depending on the container it uses them from https://mcflags.emc.gs or https://steinborn.me/posts/tuning-minecraft-openj9/
ADDITIONAL_ARGS | | Additional arguments if you don't want to overrwrite the whole ARGS

## Tags
Name | Description
--- | ---
11hotspot | OpenJDK 11 with HotSpot VM
15hotspot | OpenJDK 15 with HotSpot VM
11openj9 | OpenJDK 11 with Openj9 VM
15openj9 | OpenJDK 15 with Openj9 VM
