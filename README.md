# MagicMirror² in Docker optimized for Unraid
This Container will download and install MagicMirror².

**MODULE INSTALLATION:** This container can pull modules from Github automatically, simply go to your server directory and in the 'modules' folder after the first startup, there you will find a file named 'modules.txt'.
Simply drop your links from Gitbub into the file (place a 'Y' in front of the link to run a automatic 'npm install' after the download, not every module will work with this automatic module installer) or simply delete the '#' in front of the premade modules in the file and then restart the container to download the modules.
Please don't forget to also to edit your config.js!

**Update Notice:** This container will check on every restart if there is a newer version of MagicMirror² available and will download and install it if so.
You can also set the variable FORCE_UPDATE to 'true' to force an update (Please don't forget to disable this afterwards since it will pull it every time you restart or start the container)!

There is also an option to only force an update for the modules, set the variable FORCE_UPDATE_MODULES to 'true' to force an update on every restart.

## Env params
| Name | Value | Example |
| --- | --- | --- |
| DATA_DIR | Data directory | /magicmirror2 |
| FORCE_UPDATE | This will force an update of the MagicMirror² and also the modules | "" |
| FORCE_UPDATE_MODULES | This will force an update of the modules for MagicMirror² | "" |
| UID | User Identifier | 99 |
| GID | Group Identifier | 100 |
| UMASK | User file permission mask for newly created files | 000 |
| DATA_PERM | Data permissions for main storage folder | 770 |

## Run example
```
docker run --name MagicMirror-2 -d \
    -p 8080:8080 \
    --env 'UID=99' \
    --env 'GID=100' \
    --env 'UMASK=000' \
    --env 'DATA_PERM=770' \
    --volume /mnt/user/appdata/magicmirror2:/magicmirror2 \
    --restart=unless-stopped \
    ich777/magic-mirror2
```

### Webgui address: http://[IP]:[PORT:8080]/


This Docker was mainly edited for better use with Unraid, if you don't use Unraid you should definitely try it!

#### Support Thread: https://forums.unraid.net/topic/83786-support-ich777-application-dockers/