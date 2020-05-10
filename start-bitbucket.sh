#!/usr/bin/env bash

# After Bitbucket has started it can be browsed at http://localhost:7990
# To access the Bitbucket data folder you can mount the Docker volume
# assigned to Bitbucket with the volume name: 'bitbucket-data', typically
# found at: /var/lib/docker/volumes/bitbucket-data on Linux. If you are
# running Docker on MacOS, the volumes are hidden inside a Docker VM.
#
# Bitbucket will auto restart after a system shutdown/reboot unless it was
# manually stopped, so theoretically you should only need to ever start it
# once. If for some reason you do want to manually stop Bitbucket, use the
# following command:
#
# docker stop bitbucket
#
echo 'Starting Bitbucket ...'
docker run \
    -d \
    --name bitbucket \
    --network iac-env \
    --publish 7990:7990 \
    --publish 7999:7999 \
    --restart unless-stopped \
    --volume bitbucket-data:/var/atlassian/application-data/bitbucket \
    atlassian/bitbucket-server:6.10
