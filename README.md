# vote-kubernetes-resources

## How to Debug Network/DNS

- [DNS Debugging Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
    1. Apply dnsutil to kubernetes cluster
    1. `kubectl exec -i -t dnsutils -- nslookup kubernetes.default`

- [Connect Applications Service](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)
    `kubectl run curl --image=radial/busyboxplus:curl -i --tty`