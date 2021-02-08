## GKE cluster example (using public modules)

GKE cluster provision from public modules.

Prerequisites:
* terraform >= 0.13
* kubectl >= 1.18
* gcloud

Pre-commit installation:
```shell
git secrets --install
pre-commit install -f
pre-commit run -a
```

Key points:
* VPC resources are managed in standalone public module

## Create/Destroy Staging Infrastructure:

1) GCP init and authentication
```shell
gcloud init
gcloud auth application-default login
```

2) Create VPC and GKE cluster
```shell
make plan
make apply
```
As soon as cluster is ready, you should find a `kubeconfig_*` kubeconfig file in the current directory.

3) Destroy VPC and GKE cluster
```shell
make destroy
```

## Example application deploy for Ingress testing:
1) Go to example-app folder
```shell
cd example-app
```

2) Apply manifests
```shell
kubectl apply -f . 
```

3) Check ingress
```shell
kubectl get ing 
```

4) Wait for a while and test endpoints
```shell
curl <LB Ingress IP>/apple
curl <LB Ingress IP>/banana
```

5) Destroy manifests
```shell
kubectl delete -f .
```

## Example application deploy for Cloud-Native Ingress testing: 

https://cloud.google.com/kubernetes-engine/docs/how-to/container-native-load-balancing

1) Go to example-app folder
```shell
cd example-app-neg
```

2) Apply manifests
```shell
kubectl apply -f . 
```

3) Check ingress
```shell
kubectl get ing 
```

4) Wait for a while and test endpoints
```shell
curl <LB Ingress IP>/apple
curl <LB Ingress IP>/banana
```

5) Destroy manifests
```shell
kubectl delete -f .
```
