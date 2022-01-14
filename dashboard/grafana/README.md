## Grafana Installation

### 1. Modify the server host and password attributes

We need to modify the server host and password in 'grafana.yaml' before we can configure our elasticsearch deployment as a data source. To get both of these attributes:

#### a. Server host

```
CLUSTER_IP=$(kubectl get svc elasticsearch-es-http -o jsonpath='{.spec.clusterIP}')
```

and then echo this variable in the terminal.

#### b. Password
    
From the elasticsearch documentation you should have this stored already in the PASSWORD variable, but can be retrieved by:

```
PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
```

Retrieve PASSWORD value in the terminal
```
echo $PASSWORD
```

In grafana.yaml, replace CLUSTER_IP and PASSWORD with these two attributes.


### 2. Deploy Grafana

Execute the following kubernetes command to deploy Grafana:

```
kubectl apply -f grafana.yaml
```

Port-forward Grafana and access the UI with the following credentials: username and password as both 'admin'

![Image](../../images/grafana-ui-1.png)

Two data sources are configured to view traces from: Elasticsearch and Jaeger. Navigate to Configuration -> Data Sources, you should see them as:

![Image](../../images/grafana-ui-2.png)

Check the connection status by selecting a data source and clicking 'Save and Test' and you should see a successful connection message:

![Image](../../images/grafana-ui-3.png)


If you have deployed your application on kubernetes, create a dashboard to view your traces by selecting one of the data sources as a source as shown below:

![Image](../../images/grafana-ui-4.png)
