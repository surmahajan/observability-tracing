## Elasticsearch Installation

### 1. Deploy Elasticsearch operators

Install the ECK CRDs and operator:

```
kubectl create -f https://download.elastic.co/downloads/eck/1.8.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.8.0/operator.yaml
```

### 2. Deploy Elasticsearch cluster

```
kubectl apply -f ./observability-tracing/storage/elasticsearch.yaml
```
This creates a cluster and a ClusterIP service which can be seen through:

```
kubectl get service elasticsearch-es-http
```

You can get an overview of the current Elasticsearch clusters in the Kubernetes cluster, including health, version and number of nodes using:
```
kubectl get elasticsearch
```

### 3. Retrieve auto-generated password

When the cluster is deployed, a default user is created, with username 'elastic' and password that must be retrieved from the Kubernetes secret, through:


```
PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')
```

You can now verify that this is successful by port-forwarding the http service to e.g. 9200 and querying with 'elastic' and the retrieved password secret:
```
kubectl port-forward service/elasticsearch-es-http 9200
curl -u "elastic:$PASSWORD" -k "https://localhost:9200"
```

> NOTE: Replace $PASSWORD with the explicit password if you experience authentication issues.

Alternatively, you can port-forward the elasticsearch-es-http service through lens and access via the browser by pre-pending 'https' to the url, ignoring the warning and proceeding to localhost.



### 4. Create jaeger secret with default username and password

To integrate Elasticsearch with Jaeger (when later deployed), we must create a jaeger secret through which jaeger will pass logs through to Elasticsearch:

```
kubectl create secret generic jaeger-secret --from-literal=ES_PASSWORD=${PASSWORD} --from-literal=ES_USERNAME=elastic
```
