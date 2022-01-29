### What problem are we solving?
> Achieve end to end tracing of a request within istio enabled workloads using open source tools regardless of the language, framework, or platform you use to build your application.


### What is Observability?
Observability comprises of three pillars
* Logs
* Metrics
* Traces

For the current project we will focus on tracing.

![Image](images/observability-tracing.png)

Private Cluster - Managing application and data workloads.

![Image](images/observability-architecture.png)

### What are the Prerequisites?

1. Enable Kubernetes - https://docs.docker.com/desktop/kubernetes/#enable-kubernetes
2. Install Kubectl - https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/#install-with-homebrew-on-macos
3. Install kubectx - https://formulae.brew.sh/formula/kubectx
4. How to switch context - 
    `kubectx' * list all the contexts
    `kubectx docker-desktop' 


### How do I set up?

`make deploy`

* Elasticsearch to store Jaeger traces - Refer [Documentation](./storage/README.md)
* Jaeger - Refer [Documentation](./tracing/README.md)
* Istio - Refer [Documentation](./service-mesh/README.md)
* Grafana to visualise the traces - Refer [Documentation](./dashboard/grafana/README.md)
* Bookinfo application to test tracing - Refer [Documentation](./demo/README.md)

### Will it cost me anything?
If you are using Docker Desktop which includes a standalone Kubernetes server and client you can run it for free locally. 
If you are using any other cloud provider please refer the cloud provider's pricing documentation. As a good practice make sure you cleanup the resources at the end.


### How do I clean up?

`make clean`


