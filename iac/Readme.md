Atualização do Kubeconfig

```sh
aws eks --region us-east-1 update-kubeconfig --name k8s-demo
```

kubectl label namespace default istio-injection=enabled

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/prometheus.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/grafana.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/jaeger.yaml
kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.18/samples/addons/kiali.yaml

k apply -f manifests/virtual-service-grafana.yaml
k apply -f manifests/virtual-service-kiali.yaml
k apply -f manifests/virtual-service-jaeger.yaml

curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Repo

helm repo add flagger https://flagger.app

# CRD

kubectl apply -f https://raw.githubusercontent.com/fluxcd/flagger/main/artifacts/flagger/crd.yaml

# Deploy with istio

helm upgrade -i flagger flagger/flagger \
--namespace=istio-system \
--set crd.create=false \
--set meshProvider=istio \
--set metricsServer=http://prometheus.istio-system.svc.cluster.local:9090

# Install service and deployment.

kubectl apply -f manifests/hello-app.yaml
kubectl apply -f manifests/app-world-flagger-v1.yaml

# Install Flagger canary objects

kubectl apply -f k8s/app-canary-world-with-flagger.yaml
