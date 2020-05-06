# Migration from version 3.16.0
Starting at version 3.17.0 Docker isn't part of the [main repository](https://github.com/xwiki-labs/cryptpad) anymore.
The Docker deployment is community maintained and not officially supported.

With the new repository comes a reworked Docker image and reworked docker-compose files, which require manual
intervention to keep working.

_**Notice:**_ xwiki/cryptpad_ was removed from Dockerhub as Docker is not supported officially.
Please use _promasu/cryptpad_ which is automaticly build from this repository.
See [Dockerhub](https://hub.docker.com/r/promasu/cryptpad) to get the suitable image for you. `:latest` should normally
do the job for you, as it's the last tagged release on the [main repository](https://github.com/xwiki-labs/cryptpad).

## Migration steps
1. Clone this repository. If you want to build the image yourself you have to pull the submodule.
(`git submodule update --init --recursive`)

2. Move the _data_ and _customize_ directories from the old location into the `cryptpad-docker` repository.

3. Move the configuration from `data/cfg/config.js` to `data/config.js`. Consider taking a look at the current
[example config](https://github.com/xwiki-labs/cryptpad/blob/master/config/config.example.js) if there are missing or
obsolet parameters in your configuration.

4. CryptPad now uses a dedicated user inside the repository which has no permission to access the currently saved files.
You need to execute `sudo chown -R 4001:4001 data customize` to set the correct permissions.

5. See the [README](README.md) for general instructions on using this repository.