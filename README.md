# vote-kubernetes-resources

## How to Debug Network/DNS

- [DNS Debugging Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
    1. Apply dnsutil to kubernetes cluster
    1. `kubectl exec -i -t dnsutils -- nslookup kubernetes.default`

- [Connect Applications Service](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)
    `kubectl run curl --image=radial/busyboxplus:curl -i --tty`

## How to Deploy to Local Demo Kubernetes Cluster
`kubectl apply -f [file_path]`


## Monitoring
For monitoring Istio traffic monitoring, we can use Prometheus, Jaeger, Grafanna and Kiali. All of them can be installed by helm.

TIPS: `helm search repo [chart_name]` provides the ability to search for Heml charts.

### 1. Prometheus
[prometheus-community](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus#install-chart)
[Prometheus and Grafana setup in Minikube](https://blog.marcnuri.com/prometheus-grafana-setup-minikube/)
    ```
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics
    helm repo update
    # Install
    helm install prometheus prometheus-community/prometheus
    # Expose prometheus to localhost:9090
    kubectl expose svc prometheus-server --type=LoadBalancer --target-port=9090 --port=9090 --name=prometheus-server-lb
    ```

### 2. Grafana
[grafana/helm-charts](https://github.com/grafana/helm-charts)

    ```
    helm repo add grafana https://grafana.github.io/helm-charts
    # Install
    helm install grafana grafana/grafana
    # Expose Grafana to localhost:3000
    kubectl expose svc grafana --type=LoadBalancer --target-port=3000 --port=3000 --name=grafana-lb
    # Retrieve the amdin user password
    kubectl get secret -n default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```
Configure Prometheus Datasource: `http://prometheus-server.default.svc.cluster.local` & `6417`

