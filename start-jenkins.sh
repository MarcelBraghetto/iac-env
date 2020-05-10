#!/usr/bin/env bash

# After Jenkins has started it can be browsed at http://localhost:8080
# To access the Jenkins home folder you can mount the Docker volume
# assigned to Jenkins with the volume name: 'jenkins-data', typically
# found at: /var/lib/docker/volumes/jenkins-data on Linux. If you are
# running Docker on MacOS, the volumes are hidden inside a Docker VM.
#
# Jenkins will auto restart itself after a system shutdown/reboot unless
# it was manually stopped, so theoretically you should only need to ever
# start it once. If for some reason you do want to manually stop Jenkins,
# use the following command:
#
# docker stop jenkins
#
echo 'Starting Jenkins ...'
docker run \
    -d \
    --name jenkins \
    --network iac-env \
    --publish 8080:8080 \
    --publish 50000:50000 \
    --restart unless-stopped \
    --volume jenkins-data:/var/jenkins_home \
    --volume /var/run/docker.sock:/var/run/docker.sock \
    iac-jenkins:latest
