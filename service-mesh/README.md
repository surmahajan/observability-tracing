## Download Istio 

**NOTE:** To run Istio with Docker Desktop, you will need to increase Docker's memory limit. To do so, go to Settings -> Resources -> Advanced, and set Memory to 8.0Gb and CPUs to 4.

*Once Jaeger is installed, you will need to point Istio proxies to send traces to the deployment.*

## Add a namespace label to instruct Istio to automatically inject Envoy sidecar proxies when you deploy your application later

`kubectl label namespace default istio-injection=enabled`


## Only on multi-cluster env - Install istio with Default configuration profile on multi cluster.

`istioctl install --set profile=default --set meshConfig.enableTracing=true --set meshConfig.defaultConfig.tracing.zipkin.address=http://jaeger-prod-collector:9411 --set meshConfig.defaultConfig.tracing.sampling=50 --set prometheus.enabled=false --set kiali.prometheusAddr=http://prometheus.monitoring.svc.cluster.local:9090 --set kiali.dashboard.jaegerURL=http://jaeger-query.observability.svc.cluster.local:16686`

