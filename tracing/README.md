## Jaeger deployment

### Navigate to the UI
* Port forward `kubectl port-forward service/jaeger-prod-query 16686` or use LENS IDE 

![Image](../images/jaeger-ui-1.png)
![Image](../images/jaeger-ui-2.png)
![Image](../images/jaeger-ui-3.png)

### TODO: Configuring remote access to Jaeger

`kubectl config --kubeconfig=config-demo set-context dev-frontend --cluster=development --namespace=frontend --user=developer`