# Kubernetes Basic

## What is Kubenetes?

![History](https://d33wubrfki0l68.cloudfront.net/26a177ede4d7b032362289c6fccd448fc4a91174/eb693/images/docs/container_evolution.svg)

**注: Tons of Benefits**

## Why you need Kubernetes and what it can do?

- Service discovery and load balancing
- Storage orchestration
- Automated rollouts and rollbacks
- Automatic bin packing
- Self-healing
- Secret and configuration management

**关键字: Deployment, Scaling, Load Balance**

## Key Concept
![Kubernetes Architecture](https://d33wubrfki0l68.cloudfront.net/2475489eaf20163ec0f54ddc1d92aa8d4c87c96b/e7c81/images/docs/components-of-kubernetes.svg)

当你部署完Kubernetes，即拥有了一个完整的集群。

一个Kubernetes集群由一组称为节点的机器组成。这些节点上运行 Kubernetes 所管理的容器化应用。集群具有至少一个工作节点。

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