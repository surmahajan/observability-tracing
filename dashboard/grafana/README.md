## Grafana Installation

### Modify the server host and password attributes

We need to modify the server host and password in 'grafana.yaml' before we can configure our elasticsearch deployment as a data source. To get both of these attributes:

#### 1) Server host

```
CLUSTER_IP=$(kubectl get svc elasticsearch-es-http -o jsonpath='{.spec.clusterIP}')
```

and then echo this variable in the terminal.

#### 2) Password
    
From the elasticsearch documentation you should have this stored already in the PASSWORD variable, but can be retrieved by:

```
PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
```

and then echo this variable in the terminal. 

In grafana.yaml, replace CLUSTER_IP (line 20) and PASSWORD (line 28) with these two attributes.


### Deploy Grafana

Navigate to ../grafana/grafana.yaml and perform the command:

```
kubectl apply -f grafana.yaml
```

You can now port-forward Grafana, and using the username and password as both 'admin' log-in - you should see the following UI:

![Image](../../images/grafana-ui-1.png)
