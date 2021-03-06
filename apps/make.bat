SET YOUR_DOCKER_HUB_USER=tentativafc

echo Building services
pushd
cd hello-app
mvn clean compile package
docker build -t $YOUR_DOCKER_HUB_USER/hello-app:1.0.0 -f Dockerfile .
docker push $YOUR_DOCKER_HUB_USER/hello-app:1.0.0
popd

pushd .
cd world-app
mvn clean compile package
docker build -t $YOUR_DOCKER_HUB_USER/world-app:1.0.0 -f Dockerfile .
docker push $YOUR_DOCKER_HUB_USER/world-app:1.0.0
popd

pushd .
cd hello-world-app
mvn clean compile package
docker build -t $YOUR_DOCKER_HUB_USER/hello-world-app:1.0.0 -f Dockerfile .
docker push $YOUR_DOCKER_HUB_USER/hello-world-app:1.0.0
popd

echo DONE