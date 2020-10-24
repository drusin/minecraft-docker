# dawidr/minecraft-docker
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
ADDITIONAL_ARGS | | Additional arguments if you don't want to overwrite the whole ARGS

## Tags
Name | Description
--- | ---
11hotspot | OpenJDK 11 with HotSpot VM
15hotspot | OpenJDK 15 with HotSpot VM
11openj9 | OpenJDK 11 with Openj9 VM
15openj9 | OpenJDK 15 with Openj9 VM

## Example docker-compose
```yaml
version: '3.7'

services:
    paper-hotspot:
        image: dawidr/minecraft-docker:11hotspot
        environment: 
            TYPE: paper
        ports:
            - "25565:25565"
        volumes: 
            - "/home/dawid/ssd/paper_hotspot:/data"
    fabric-j9:
        image: dawidr/minecraft-docker:11openj9
        environment: 
            TYPE: fabric
            MEMORY: 3072
        ports:
            - "25565:35565"
        volumes: 
            - "/home/dawid/ssd/fabric_j9:/data"
```
