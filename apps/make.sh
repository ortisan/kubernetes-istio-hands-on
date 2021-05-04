#!/bin/sh

#https://stackoverflow.com/questions/2870992/automatic-exit-from-bash-shell-script-on-error
abort()
{
    echo >&2 '
***************
*** ABORTED ***
***************
'
    echo "An error occurred. Exiting..." >&2
    exit 1
}

trap 'abort' 0

set -e

YOUR_DOCKER_HUB_USER=tentativafc

## Building services
cd hello-app
mvn clean compile package
docker build -t $YOUR_DOCKER_HUB_USER/hello-app:1.0.0-snapshot -f Dockerfile .
docker push $YOUR_DOCKER_HUB_USER/hello-app:1.0.0-snapshot
cd - 

cd world-app
mvn clean compile package
docker build -t $YOUR_DOCKER_HUB_USER/world-app:1.0.0-snapshot -f Dockerfile .
docker push $YOUR_DOCKER_HUB_USER/world-app:1.0.0-snapshot
cd - 

trap : 0

echo >&2 '
************
*** DONE *** 
************
'