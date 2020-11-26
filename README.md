# dawidr/minecraft-docker
A simple docker container that automatically downloads and starts a minecraft server.

## Available images
| Name                              | Description                |
| --------------------------------- | -------------------------- |
| dawidr/minecraft-docker-11hotspot | OpenJDK 11 with HotSpot VM |
| dawidr/minecraft-docker-15hotspot | OpenJDK 15 with HotSpot VM |
| dawidr/minecraft-docker-11openj9  | OpenJDK 11 with Openj9 VM  |
| dawidr/minecraft-docker-15openj9  | OpenJDK 15 with Openj9 VM  |

## Usage
Forward the port 25565 and mount a read/write volume to `/data`, to persist worlds and server settings. If the volume already contains worlds, config files or plugins/mods the server will use those and they will be updated during runtime. It is not possible to change server config using environment variables, please use the regular server config files in the volume.

## Environment
| Name                   | Default value                               | Description                                                                                                                                                             |
| ---------------------- | ------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TYPE                   | paper                                       | Which server jar to use. Currently supported: paper, fabric, waterfall                                                                                                  |
| VERSION                | 1.16.3                                      | Which Minecraft version to use                                                                                                                                          |
| MEMORY                 | 4096                                        | How much RAM to allocate for the server (in MB)                                                                                                                         |
| ARGS                   | Optimal command line args (see Description) | Which arguments to pass to the Java process. Depending on the container it uses them from https://mcflags.emc.gs or https://steinborn.me/posts/tuning-minecraft-openj9/ |
| ADDITIONAL_ARGS        |                                             | Additional arguments if you don't want to overwrite the whole ARGS                                                                                                      |
| WORLDS                 | world,world_nether,world_the_end            | Which world directories to use (ignored for when using waterfall)                                                                                                       |
| FORCE_DOWNLOAD         | true                                        | If set to "false", no server jar will be downloaded if there is already one present from a previous run                                                                 |
| AUTO_UPDATE_VIAVERSION | false                                       | If set to "true", the latest version of ViaVersion will be downloaded and put into the plugins or mods folder                                                           |
| AUTO_PAUSE             | false                                       | If set to "true", the minecraft server process will be paused when no players are connected. See below for more info                                                    |
| BEFORE_FIRST_PAUSE     | 5                                           | Time in minutes until the first "AUTO_PAUSE" check is done. See below for more info                                                                                     |
| FORGE_VERSION          | 34.1.0                                      | Specific version for the Forge Installer. Only used when `TYPE: forge` is used. See [Forge specific Information](#forge-specific-information) below.                    | 

### Forge specific information

For configuring Forge it is necessary to find out, which Forge Version is currently available for your desired Minecraft version.
Here you can check the Forge versions: http://files.minecraftforge.net/.
In most cases the recommended version (right one) will fit.

Currently (2020-11-26) Forge is not compatible with Java 15.

## Auto pause functionality
By setting `AUTO_PAUSE` to `"true"`, every 5 min it will be checked if anyone is connected to the server. If noone is, the server process will be stopped and will not consume any processor resources anymore. As soon as someone tries to connect, the server process will be continued - this should work seamlessly, without the players even noticing. This functionality is based on [this comment on the official Mojang bug tracker](https://bugs.mojang.com/browse/MC-149018?focusedCommentId=593606&page=com.atlassian.jira.plugin.system.issuetabpanels%3Acomment-tabpanel#comment-593606).  
**Important:** By default the minecraft server is set to crash if no ticks are happening for 60s. If you want to use auto pause you need to disable this functionality by setting `max-tick-time=-1` in `server.properties`, `timeout-time: -1` and `restart-on-crash: false` in `spigot.yaml` (if appliacable). Also there is a grace period before the first check for online players to make sure the server is fully started. You can change the amount of time with the `BEFORE_FIRST_PAUSE` environment variable.

## Example docker-compose
```yaml
version: '3'

services:
    my-minecraft:
        image: dawidr/minecraft-docker-11hotspot
        environment:
            TYPE: paper
            VERSION: "1.16.4"
            MEMORY: 3072
            WORLDS: "world,world_nether,world_the_end,world_creative"
            FORCE_DOWNLOAD: "false"
            AUTO_UPDATE_VIAVERSION: "true"
            AUTO_PAUSE: "true"
            BEFORE_FIRST_PAUSE: 2
        ports:
            - "25565:25565"
        volumes:
            - "~/my-minecraft:/data"
```
