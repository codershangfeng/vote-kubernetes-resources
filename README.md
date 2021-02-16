# vote-kubernetes-resources

## How to Debug Network/DNS

- [DNS Debugging Resolution](https://kubernetes.io/docs/tasks/administer-cluster/dns-debugging-resolution/)
    `kubectl exec -i -t dnsutils -- nslookup kubernetes.default`

- [Connect Applications Service](https://kubernetes.io/docs/concepts/services-networking/connect-applications-service/)
    `kubectl run curl --image=radial/busyboxplus:curl -i --tty`