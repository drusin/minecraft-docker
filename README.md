# dawidr/minecraft-docker
A simple docker container that automatically installs java and downloads and starts a Minecraft server.

## Usage
Forward the port 25565 and mount a read/write volume to `/data`, to persist worlds and server settings. If the volume already contains worlds, config files or plugins/mods the server will use those and they will be updated during runtime. It is not possible to change server config using environment variables, please use the regular server config files in the volume.

### Running as non-root user
This container supports being run as a non-root user, just pass your user id when starting (see example [docker-compose.yml](https://github.com/drusin/minecraft-docker/blob/main/docker-compose.yml)).

### Persisting Java installations
The container automatically installs the set Java version on the fly. You can persist the installed java version between config changes (e.g. changing the Minecraft version or the memory amount) by binding a read/write volume to `/sdkman/candidates`. You can theoretically reuse the same volume for multiple containers.

## Environment
### Main configuration variables
The default values are **not considered stable**, changes to the default values are **not considered breaking**.
| Name                | Default value                    | Description                                                                                                                                                    |
| ------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| TYPE                | paper                            | Which server jar to use. Currently supported: paper, fabric, spigot, forge, velocity, waterfall, custom (see [Using custom jars](#using-custom-jars))                    |
| MC_VERSION          | 1.19                             | Which Minecraft version to use (ignored for Velocity)                                                                                                                                 |
| EULA                | false                            | If you accept Mojang's EULA                                                                                                                                    |
| JAVA_VERSION        | 17.0.4                           | Which Java version to use                                                                                                                                      |
| JAVA_IDENTIFIER     | tem                              | Which Java vendor to use. tem for Temurin (formally HotSpot), sem for Semeru (formally OpenJ9) - See https://sdkman.io/jdks                                                                 |
| MEMORY              | 4096                             | How much RAM to allocate for the server (in MB)                                                                                                                |
| DOWNLOAD_MODS       | false                            | Set to `true` to enable mod auto download functionality, see [Auto download mods](#auto-download-mods) |
| MODS                | ""                               | Which mods to download, when `DOWNLOAD_MODS` is enabled, no functionality otherwise |  
### Additional configuration variables
Default values can be considered quite stable.
| Name                | Default value                    | Description                                                                                      
| ------------------- | -------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| DEFAULT_ARGS        | true                             | Use recommended java startup flags. Depending on the container it uses them from https://mcflags.emc.gs or https://steinborn.me/posts/tuning-minecraft-openj9/ |
| ADDITIONAL_ARGS     |                                  | Additional arguments if you don't want to overwrite the whole ARGS                                                                                             |
| FORCE_DOWNLOAD      | false                            | If set to "false", no server jar will be downloaded if there is already one present from a previous run                                                        |
| JAR_NAME            | runme.jar                        | Name of the jar to run. Only might need changing for `TYPE: custom`, see [Using custom jars](#using-custom-jars)                                               |

### Choosing the correct java version
Starting with Minecraft 1.17 newer Java versions are required than Java 8. But some server types don't support the newest Java version yet, so you might need to stick to some in-between Java version instead of just going for the latest or the last lts release. With both regular Minecraft and Java releases it is hard to give a general recommendation here, but you might use [this wiki page](https://minecraft.fandom.com/wiki/Tutorials/Update_Java#Why_update?) as a starting point.
Also please keep in mind that Semeru Java releases might not be available for all architectures immediately.

### Using custom jars
It is possible to run server types that are not supported out of the box by using `TYPE: custom`. Then you just have to provide a jar-file that matches `JAR_NAME` in the root of the bound volume.
Variables `VERSION` and `FORCE_DOWNLOAD` don't have any effect when using `TYPE: custom`.

### Velocity
Velocity is compatible with Minecraft 1.7.7 - current (1.20.2 at time of writing). Currently, when using `TYPE: velocity`, always the latest version of Velocity is downloaded and used, the set Minecraft version is ignored.

### Auto download mods
This container has the built in functionaility to automatically download specified mods. It currently is only supported for server types `forge` and `fabric`. To use it, set `DOWNLOAD_MODS` to `true` and put a comma-separated list of mod ids in `MODS`. A mod id can be one of:
* Modrinth slug
* Modrinth project ID
* Curseforge project ID

Under the hood the container uses the awesome CLI tool [Ferium](https://github.com/gorilla-devs/ferium).

## Example docker-compose
You can find an extensive docker-compose example file [here](https://github.com/drusin/minecraft-docker/blob/main/docker-compose.yml).

## Development
The main entry point is the file `/scripts/script.mjs`.  
This project uses [zx](https://github.com/google/zx) to be able to write the container logic in javascript with some bash mixed in.  
You can run `./buildContainer.sh` without any arguments to build an image locally with the tag `dawidr/minecraft-docker:test`. This tag is already set in the provided `docker-compose.override.yaml`.

### Running the scripts locally
To make debugging and prototyping easier and faster, this project comes with a way to run all the logic locally on the machine, without the need of building a container after every change.

#### Prerequisites
* Node 16 installed and globally useable
* By default the local script skips the Java installation, so make sure to have an appropriate Java version installed and globally usable or add the line `ENV SKIP_JAVA="false"` to `testenv.override` - **Watch out - this will install Java system-wide!**
* Run `npm ci` in the project folder once after cloning to download and install zx for the project locally

#### Starting the local scripts
Just run `./localTest.js`. It will mimic some of the behavior defined in the Dockerfile:
1. Read and set all environment variables defined in `Dockerfile`, `testenv` and `testenv.override`
2. Create the folder `test-data` which mimics the bound read/write volume
3. Create the folder `test-workdir` which mimics the working directory in the container
4. Create symbolic links to all scripts form `/scripts` in `test-workdir` and make script files executable
5. Start the main script `script.js` from `test-workdir`
If you did not change any environnement variables the end result should be a running, freshly downloaded version of papermc.

You can use the `-c` flag to clean `test-data` and `test-workdir` before the rest of the script runs.

#### Changing environment variables
The file `testenv` changes the values of a few environment variables to make the scripts function locally. You should only touch this file if you know what you are doing and don't need to touch it if you just need to change some "regular" environment variables while testing/prototyping. Add your changed variables to `testenv.override` instead or comment in the already present but commented out lines.

#### Debugging
Instead of copying the script files, symbolic links are used which means you can work directly on the script files in the `scripts` directory, including breakpoints!
