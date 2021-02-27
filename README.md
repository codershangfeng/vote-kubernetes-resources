# vote-kubernetes-resources

## How to Deploy to Local Demo Kubernetes Cluster
```kubectl apply -f [file_path]```

## How to Enable Istio

### Install

Apply demo profile and disable metrics merging([details](https://istio.io/v1.7/docs/ops/integrations/prometheus/#Configuration)).

```
istioctl install --set meshConfig.enablePrometheusMerge=false --set profile=demo
```

## Concept

### Traffic Management

- Virtual services

    * Address multiple application services through a single virtual service.
    * Configure traffic rules in combination with gateways to control ingress and egress traffic.

- Destination rules
    
    Along with virtual services, destination rules are a key part of Istio's traffic routing functionality.

    * Random
    * Weighted
    * Least Requests


- Gateways

- Service entries

- Sidecars

### Security

![Security Overview](https://istio.io/latest/docs/concepts/security/overview.svg)

![Security Architecture](https://istio.io/v1.8/docs/concepts/security/arch-sec.svg)

* To defend against man-in-the-middle attacks, they need traffic encryption.

* To provide flexible service access control, they need mutual TLS and fine-grained access policies.

* To determine who did what at what time, they need auditing tools.


1. Certifiate Management
    
    ![Identity Provisioning Workflow](https://istio.io/v1.8/docs/concepts/security/id-prov.svg)
    
    - Envoy secret discovery service (SDS)
        
    - Certificate signing requests (CSR)

1. Authentication
    ![Authentication Architecture](https://istio.io/v1.8/docs/concepts/security/authn.svg)
    
    - [Gloablly enabling Istio mutal TLS in STRICT mode](https://istio.io/v1.8/docs/tasks/security/authentication/authn-policy/#globally-enabling-istio-mutual-tls-in-strict-mode)
        - [Peer authentication](https://istio.io/v1.8/docs/concepts/security/#peer-authentication)
        - [X-Forwarded-Client-Cert](https://www.envoyproxy.io/docs/envoy/latest/configuration/http/http_conn_man/headers#x-forwarded-client-cert)
    
    - [Enable mutual TLS per namespace or workload](https://istio.io/v1.8/docs/tasks/security/authentication/authn-policy/#enable-mutual-tls-per-namespace-or-workload)

1. Authorization
    ![Authorization Architecture](https://istio.io/v1.8/docs/concepts/security/authz.svg)
    
    - Workload-to-workload and end-user-to-workload authorization.

    - A Simple API: it includes a single AuthorizationPolicy **CRD**, which is easy to use and maintain.

    - Flexible semantics: operators can define custom conditions on Istio attributes, and use DENY and ALLOW actions.
    
    - High performance: Istio authorization is enforced natively on Envoy.
    
    - High compatibility: supports gRPC, HTTP, HTTPS and HTTP2 natively, as well as any plain TCP protocols.
    
    From v1.4, `AuthorizationPolicy` is in use.
    - [Authorizaiton for HTTP traffic](https://istio.io/v1.8/docs/tasks/security/authorization/authz-http/)

    - The deny policy takes precedence over the allow policy.

## Observability
For monitoring Istio traffic monitoring, we can use Prometheus, Jaeger, Grafanna and Kiali. All of them can be installed by helm.

TIPS: `helm search repo [chart_name]` provides the ability to search for Heml charts.

### 1. Prometheus

- [prometheus-community](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus#install-chart)

- [Prometheus and Grafana setup in Minikube](https://blog.marcnuri.com/prometheus-grafana-setup-minikube/)

    ```
    helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
    
    helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics

    helm repo update

    helm install prometheus prometheus-community/prometheus

    kubectl expose svc prometheus-server --type=LoadBalancer --target-port=9090 --port=9090 --name=prometheus-server-lb
    ```

### 2. Grafana

- [grafana/helm-charts](https://github.com/grafana/helm-charts)

    ```
    helm repo add grafana https://grafana.github.io/helm-charts
    
    helm install grafana grafana/grafana
    
    kubectl expose svc grafana --type=LoadBalancer --target-port=3000 --port=3000 --name=grafana-lb
    
    kubectl get secret -n default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
    ```

Configure Prometheus Datasource: `http://prometheus-server.default.svc.cluster.local` & `6417` & `istio_request_total`

### Others
#### How to Debug Network/DNS

- [DNS Debugging Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
    1. Apply dnsutil to kubernetes cluster
    1. `kubectl exec -i -t dnsutils -- nslookup kubernetes.default`

- [Connect Applications Service](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)
    
    ```kubectl run curl --image=radial/busyboxplus:curl -i --tty```


## References:


### Kubernetes Related

- Service Account - [Kubernetes Tips: Using a ServiceAccount](https://betterprogramming.pub/k8s-tips-using-a-serviceaccount-801c433d0023)

- 