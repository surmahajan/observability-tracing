## Jaeger installation

### 1. Install CRDs and RBACs

```
kubectl apply -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/crds/jaegertracing.io_jaegers_crd.yaml

kubectl apply -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/service_account.yaml

kubectl apply -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/role.yaml

kubectl apply -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/role_binding.yaml

kubectl apply -f https://raw.githubusercontent.com/jaegertracing/jaeger-operator/master/deploy/operator.yaml
```

### 2. Create production ready Jaeger instance

* Apply below command to deploy the relevant Jaeger resources
    ```
    kubectl apply -f ./observability-tracing/tracing/jaeger.yaml
    ```

### 3. Navigate to the UI
* Port forward ```kubectl  port-forward service/jaeger-prod-query 16686```
* or use LENS IDE 

### TODO: Configuring remote access to Jaeger


kubectl config --kubeconfig=config-demo set-context dev-frontend --cluster=development --namespace=frontend --user=developer