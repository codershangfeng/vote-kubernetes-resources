# Service Mesh

## 1. Introduction of Service Mesh

### The Intention of Service Mesh
服务 -> 服务治理 -> **微服务时代**(*将服务异化到不同交付团队，或者独立发布和独立伸缩的价值 >> 服务/容器编排的成本*)
* 多语言
* 系统复杂度 - 指数级上升

*Zen of Servie Mesh*: 
- Service Mesh是一个“基础设施”层，用于处理服务间通信。
- 云原生应用有着复杂的网络拓扑，而Service Mesh就是要保证请求可以在这些“拓扑”中“可靠”地穿梭。
- 实际应用中，Service Mesh是有一系列的“网络代理”组成的，它们与应用程序部署在一起，但应用程序“不需要知道”它们的存在。

    * Infrastructure: 下沉
    * Topology: 服务物理网络上的抽象层
    * Reliablity: 要靠谱！
    * Network Proxy: 透明、跨语言
    * Unawareness: 提供上层的全套功能且业务无侵入

典型应用:
- Traffic Control, such as rich routing rules, retries, A/B testing, canary rollouts, etc
- Authentication & Authorization
- Monitoring

Service Mesh vs. Spring Cloud
- 特征对比

## 2. Istio

### 2.1 Prerequsite Knowledge

#### 2.1.1 What is Kubenetes?

![History](https://d33wubrfki0l68.cloudfront.net/26a177ede4d7b032362289c6fccd448fc4a91174/eb693/images/docs/container_evolution.svg)

**注: Tons of Benefits**

#### 2.1.2 Why you need Kubernetes and what it can do?

- Service discovery and load balancing
- Storage orchestration
- Automated rollouts and rollbacks
- Automatic bin packing
- Self-healing
- Secret and configuration management

**关键字: Deployment, Scaling, Load Balance**

#### 2.1.3 Key Concept
![Kubernetes Architecture](https://d33wubrfki0l68.cloudfront.net/2475489eaf20163ec0f54ddc1d92aa8d4c87c96b/e7c81/images/docs/components-of-kubernetes.svg)

当你部署完Kubernetes，即拥有了一个完整的集群。

一个Kubernetes集群由一组成为节点的机器组成。这些节点上运行 Kubernetes 所管理的容器化应用。集群具有至少一个工作节点。

工作节点托管作为应用负载的组件的 Pod 。控制平面管理集群中的工作节点和 Pod 。 为集群提供故障转移和高可用性，这些控制平面一般跨多主机运行，集群跨多个节点运行。

**Kubernetes是对容器部署、负载均衡、运维的OO之作**

- Hardware
    - Node
        ![Node Overview](https://d33wubrfki0l68.cloudfront.net/5cb72d407cbe2755e581b6de757e0d81760d5b86/a9df9/docs/tutorials/kubernetes-basics/public/images/module_03_nodes.svg)
        ![Nodes](https://miro.medium.com/max/700/1*uyMd-QxYaOk_APwtuScsOg.png)
        ![Cluster](https://miro.medium.com/max/700/1*KoMzLETQeN-c63x7xzSKPw.png)

- Software
    - Pod
        ![Pod Overview](https://d33wubrfki0l68.cloudfront.net/fe03f68d8ede9815184852ca2a4fd30325e5d15a/98064/docs/tutorials/kubernetes-basics/public/images/module_03_pods.svg)


    - Deployment
        ```yaml
        apiVersion: apps/v1
        kind: Deployment
        metadata:
        name: nginx-deployment
        labels:
            app: nginx
        spec:
        replicas: 3
        selector:
            matchLabels:
            app: nginx
        template:
            metadata:
            labels:
                app: nginx
            spec:
            containers:
            - name: nginx
                image: nginx:1.14.2
                ports:
                - containerPort: 80
        ```

    - Service
        ![Service in Kubernetes](https://matthewpalmer.net/kubernetes-app-developer/articles/service-route.gif)
        ```yaml
        apiVersion: v1
        kind: Service
        metadata:
        name: my-service
        spec:
        selector:
            app: MyApp
        ports:
        - protocol: TCP
            port: 80
            targetPort: 9376
        ```

### 2.2 Istio

#### 2.2.1 Architecture

- **Data Plane**: a set of intelligent proxies (Envoy) deployed as sidecars
- **Control Plane**: manages and configures the proxies to route traffic

![Diagram](https://istio.io/latest/docs/ops/deployment/architecture/arch.svg)

- Components:
    - Envoy: a high-performance proxy developed in **C++** to mediate all inbound and outbound traffic for all services in the service mesh.
        * Dynamic service discovery
        * Load balancing
        * TLS termination
        * HTTP/2 and gRPC proxies
        * Circuit breakers
        * Health checks
        * Staged rollouts with %-based traffic split
        * Fault injection
        * Rich metrics
    - **Istiod**: provides service discovery (Pilot), configuration (Galley) and certificate management (Citadel). [The benefits of consolidation](https://istio.io/latest/blog/2020/istiod/#the-benefit-of-consolidation-introducing-istiod):
        * Installation becomes easier
        * Configuration becomes easier
        * Using VMs becomes easier
        * Maintenance becomes easier
        * Scalability becomes easier
        * Debugging becomes easier
        * Startup time goes down
        * Resource usage goes down and responsiveness goes up


#### 2.2.2 Concept

##### **Traffic Management**

- How to traffic routing?

    * Virtual services

        * Address multiple application services through a single virtual service.
        * Configure traffic rules in combination with gateways to control ingress and egress traffic.

    * Destination rules
    
        Along with virtual services, destination rules are a key part of Istio's traffic routing functionality.

        * Random
        * Weighted
        * Least Requests


- How to expose a service outside of the service mesh cluser?

    * Kubectl Proxy & NodePort & LoadBalancer & Ingress

        ![proxy](https://miro.medium.com/max/700/1*I4j4xaaxsuchdvO66V3lAg.png)
        ![node port](https://miro.medium.com/max/700/1*CdyUtG-8CfGu2oFC5s0KwA.png)
        ![load balancer](https://miro.medium.com/max/700/1*P-10bQg_1VheU9DRlvHBTQ.png)
        ![ingress](https://miro.medium.com/max/700/1*KIVa4hUVZxg-8Ncabo8pdg.png)

    * Kubernetes Ingress - [code](../ingress/kubernetes-ingress/ingress.yaml)

    * Istio Gateway - [code](../ingress/istio-ingress-gateway/ingressgateway.yaml)

    * Kubernetes Service APIs - [link](https://istio.io/latest/docs/tasks/traffic-management/ingress/service-apis/)
        ![Gateway API](https://gateway-api.sigs.k8s.io/images/api-model.png)


- How to access extenal services inside service mesh cluster?
    
    As [Accessing External Services](https://istio.io/latest/docs/tasks/traffic-management/egress/egress-control/) shows:

    1. Allow the Envoy proxy to pass requests through to services that are not configured inside the mesh.
    1. Configure service entries to provide controlled access to external services.
    1. Completely bypass the Envoy proxy for a specific range of IPs.

##### **Security**

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

##### **Observability**
For monitoring Istio traffic monitoring, we can use Prometheus, Jaeger, Grafanna and Kiali. All of them can be installed by helm.

TIPS: `helm search repo [chart_name]` provides the ability to search for Heml charts.

1. Prometheus

    - [prometheus-community](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus#install-chart)

    - [Prometheus and Grafana setup in Minikube](https://blog.marcnuri.com/prometheus-grafana-setup-minikube/)

        ```
        helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
        
        helm repo add kube-state-metrics https://kubernetes.github.io/kube-state-metrics

        helm repo update

        helm install prometheus prometheus-community/prometheus

        kubectl expose svc prometheus-server --type=LoadBalancer --target-port=9090 --port=9090 --name=prometheus-server-lb
        ```

1. Grafana

    - [grafana/helm-charts](https://github.com/grafana/helm-charts)

        ```
        helm repo add grafana https://grafana.github.io/helm-charts
        
        helm install grafana grafana/grafana
        
        kubectl expose svc grafana --type=LoadBalancer --target-port=3000 --port=3000 --name=grafana-lb
        
        kubectl get secret -n default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
        ```

    Configure Prometheus Datasource: `http://prometheus-server.default.svc.cluster.local` & `6417` & `istio_request_total`

1. Kiali

1. Loki

1. Zipkin

## References:


### Kubernetes Related

- Service Account - [Kubernetes Tips: Using a ServiceAccount](https://betterprogramming.pub/k8s-tips-using-a-serviceaccount-801c433d0023)

- NodePort vs LoadBalancer vs Ingress

    - [Access Services Running on Clusters
](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-services/)
        `http://kubernetes_master_address/api/v1/namespaces/namespace_name/services/[https:]service_name[:port_name]/proxy`

    - [Kubernetes NodePort vs LoadBalancer vs Ingress? When should I use what?](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)

- Kubernetes Concepts - [Kubernetes 101: Pods, Nodes, Containers, and Clusters](https://medium.com/google-cloud/kubernetes-101-pods-nodes-containers-and-clusters-c1509e409e16)

- Istiod - [Introducing istiod: simplifying the control plane](https://istio.io/latest/blog/2020/istiod/)