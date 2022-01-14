## Jaeger installation

### 1. Install CRDs and RBACs

```
kubectl apply -f ./tracing/jaeger-setup
```

### 2. Create production ready Jaeger instance

* Apply below command to deploy the relevant Jaeger resources
    ```
    kubectl apply -f ./tracing/jaeger.yaml
    ```

### 3. Navigate to the UI
* Port forward ```kubectl  port-forward service/jaeger-prod-query 16686``` (or use the LENS IDE) 
* If you have already deployed the bookinfo application, then you should be able to see the traces for the services as in the images below:

![Image](../images/jaeger-ui-1.png)
![Image](../images/jaeger-ui-2.png)
![Image](../images/jaeger-ui-3.png)

### Troubleshooting

1. Failed Jaeger deployment with the message 'elasticsearch node unavaiable'
   1. This can be simply solved by waiting for a longer period of time for Jaeger to finish deploying.

### TODO: Configuring remote access to Jaeger


kubectl config --kubeconfig=config-demo set-context dev-frontend --cluster=development --namespace=frontend --user=developer