## Elasticsearch deployment

You can get an overview of the current Elasticsearch clusters in the Kubernetes cluster, including health, version and number of nodes using:

`kubectl get elasticsearch`

Port-forward the http service to 9200 and query with 'elastic':

```shell
kubectl port-forward service/elasticsearch-es-http 9200
curl -u "elastic:$(kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')" -k "https://localhost:9200"
```

Alternatively, you can port-forward the elasticsearch-es-http service through lens and access via the browser by pre-pending 'https' to the url, ignoring the warning and proceeding to localhost.