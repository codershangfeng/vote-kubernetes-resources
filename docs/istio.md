# Istio

# Architecture

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

# In Action

## 1. Security

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


## 2. Traffic Management

- How to traffic routing?

    * Virtual services
        > * Address multiple application services through a single virtual service.
        > * Configure traffic rules in combination with gateways to control ingress and egress traffic.
        
        在kubernetes Service之上的一层抽象，更加面向业务请求/需求方。

        **HttpRoute**
        ```go
        type HTTPRoute struct {
	        Name                 string
	        Match                []*HTTPMatchRequest
	        Route                []*HTTPRouteDestination
	        Redirect             *HTTPRedirect
	        Delegate             *Delegate
	        Rewrite              *HTTPRewrite
	        Timeout              *types.Duration
	        Retries              *HTTPRetry
	        Fault                *HTTPFaultInjection
	        Mirror               *Destination
	        MirrorPercentage     *Percent
	        CorsPolicy           *CorsPolicy
	        Headers              *Headers
	        XXX_NoUnkeyedLiteral struct{}
	        XXX_unrecognized     []byte
	        XXX_sizecache        int32
        }
        ```
        * 路由 (route)
            * 权重 (weight)
        * 重定向 (redirect)
        * 代理 (delegate)
        * 重写Http URIs and Authority headers （rewrite)
        * 超时 (timeout)
        * 重试 (retries)
        * 错误注入 (Fault Injection)
        * 镜像 (mirror / mirrorPercentage)
        * cors策略 (corsPolicy)

        **TLCRoute**
        ```go
        type TLSRoute struct {
	        Match                []*TLSMatchAttributes 
	        Route                []*RouteDestination 
	        XXX_NoUnkeyedLiteral struct{} 
	        XXX_unrecognized     []byte   
	        XXX_sizecache        int32    
        }
        ```

        **TCPRoute**
        ```go
        type TCPRoute struct {
	        Match                []*L4MatchAttributes 
	        Route                []*RouteDestination 
	        XXX_NoUnkeyedLiteral struct{}    
	        XXX_unrecognized     []byte      
	        XXX_sizecache        int32       
        }
        ```

    * Destination rules
    
        > Along with virtual services, destination rules are a key part of Istio's traffic routing functionality.

        从Virtual Service中剥离出来，是构建Kubernetes **Service** & **Pod**资源的路由逻辑的抽象层
        
        * 负载均衡 (loadBalancer: simple / consistentHash / LocalityLbSetting)
            * ROUND_ROBIN (Default)
            * LEAST_CONN
            * RANDOM
            * PASSTHROUGH (*Be Careful*)
        * 边车连接池大小 (connectionPool)
        * 断路器 (connectionPool / outlierDetection) 
        * TLS (tls)

- How to expose a service outside of the service mesh cluser?

    * Kubectl Proxy & NodePort & LoadBalancer & Ingress

        - Proxy
        ![proxy](https://miro.medium.com/max/700/1*I4j4xaaxsuchdvO66V3lAg.png)

        - NodePort
        ![node port](https://miro.medium.com/max/700/1*CdyUtG-8CfGu2oFC5s0KwA.png)
        缺点: 
            1. Port Binding
            2. 需要单独Load Balancing
        
        - Load Balancer
        ![load balancer](https://miro.medium.com/max/700/1*P-10bQg_1VheU9DRlvHBTQ.png)
        缺点:
            1. 依赖于cloud provider
            2. 一个服务，一个LB
        
        - Ingress
        ![ingress](https://miro.medium.com/max/700/1*KIVa4hUVZxg-8Ncabo8pdg.png)
        缺点:
            1. 负载集中

    * Kubernetes Ingress - [code](../ingress/kubernetes-ingress/ingress.yaml)

    * Istio Gateway - [code](../ingress/istio-ingress-gateway/ingressgateway.yaml)

    * Kubernetes Service APIs - [link](https://istio.io/latest/docs/tasks/traffic-management/ingress/service-apis/)
        ![Gateway API](https://gateway-api.sigs.k8s.io/images/api-model.png)


- How to access extenal services inside service mesh cluster?
    
    As [Accessing External Services](https://istio.io/latest/docs/tasks/traffic-management/egress/egress-control/) shows:

    1. Allow the Envoy proxy to pass requests through to services that are not configured inside the mesh.
    1. Configure service entries to provide controlled access to external services.
    1. Completely bypass the Envoy proxy for a specific range of IPs.

## 3. Observability
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