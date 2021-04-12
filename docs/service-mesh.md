# Table of Contents

> 1. Introduction of Service Mesh
> 1. Several Framewroks of Service Mesh
> 1. In Action - Istio

# Goal

> 1. Understand basic ideas behind Service Mesh (Istio)
> 1. Highlevel recognition of Istio
> 1. Distinguish function/component differeces between Kubernetes and Istio

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


## 2. Several Framewroks of Service Mesh
### Prerequsite Knowledge

1. [Kubernetes Basic](https://github.com/codershangfeng/vote-kubernetes-resources/blob/main/docs/kubernetes-basic.md)

### [Frameworks](https://techbeacon.com/app-dev-testing/9-open-source-service-meshes-compared)
- Istio
- Linkerd
- Consul Connect
- Kuma
- Maesh
- ServiceComb-mesher
- Network Service Mesh (NSM)
- AWS App Mesh
- OpenShift Service Mesh by Red Hat

### Which is Best for You?
- 用Envoy吗？
- 你的Use Case需要什么？
    - 单体应用
    - 多容器编排框架
- 在用容器管理工具依赖？
    - AWS EKS / OpenShift / Consul
- 所在行业？
    - Kuma -> Regular financial platform
    - Network Service Mesh -> Lower-level networking telcos and ISPs
- 服务监控程度？
    - Observability
- Open standards???
- 工程师的开发体验？
- 真的准备用Service Mesh了吗？
    - 资源
    - 技能
- 其他

## 3. In Action - Istio 

### References:

#### Kubernetes Related

- Service Account - [Kubernetes Tips: Using a ServiceAccount](https://betterprogramming.pub/k8s-tips-using-a-serviceaccount-801c433d0023)

- NodePort vs LoadBalancer vs Ingress

    - [Access Services Running on Clusters
](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-services/)
        `http://kubernetes_master_address/api/v1/namespaces/namespace_name/services/[https:]service_name[:port_name]/proxy`

    - [Kubernetes NodePort vs LoadBalancer vs Ingress? When should I use what?](https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0)

- Kubernetes Concepts - [Kubernetes 101: Pods, Nodes, Containers, and Clusters](https://medium.com/google-cloud/kubernetes-101-pods-nodes-containers-and-clusters-c1509e409e16)

- Istiod - [Introducing istiod: simplifying the control plane](https://istio.io/latest/blog/2020/istiod/)