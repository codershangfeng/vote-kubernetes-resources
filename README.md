# vote-kubernetes-resources

## How to Deploy to Local Demo Kubernetes Cluster
```kubectl apply -f [file_path]```

## How to Enable Istio

### Install

Apply demo profile and disable metrics merging([details](https://istio.io/v1.7/docs/ops/integrations/prometheus/#Configuration)).

```
istioctl install --set meshConfig.enablePrometheusMerge=false --set profile=demo
```

## Resources

More tech details about Kubernetes and Istio could be found in [docs](./docs) folder. 