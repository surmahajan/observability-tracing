#!/usr/bin/env bash

# Istio deployment 
echo -e "${GREEN}Starting Istio deployment..."
curl -L https://istio.io/downloadIstio | ISTIO_VERSION=1.12.2 sh -

cd istio-1.12.2
export PATH=$PWD/bin:$PATH

# Install istio with Default configuration profile on single cluster. 

istioctl install --set profile=default --set meshConfig.enableTracing=true --set meshConfig.defaultConfig.tracing.zipkin.address=jaeger-prod-collector:9411 --set meshConfig.defaultConfig.tracing.sampling=50

cd ..

# Elasticsearch deployment

GREEN="\033[1;32m"

echo -e "${GREEN}Start deploying resources...."

# 1. Deploy Elasticsearch operators

kubectl create -f https://download.elastic.co/downloads/eck/1.8.0/crds.yaml
kubectl apply -f https://download.elastic.co/downloads/eck/1.8.0/operator.yaml

# 2. Deploy Elasticsearch cluster

kubectl apply -f ./storage/elasticsearch.yaml

ES_HEALTH=$(kubectl get elasticsearch -o jsonpath='{.items[0].status.health}')
while [ "$ES_HEALTH" != "green" ];
do
	sleep 30
	ES_HEALTH=$(kubectl get elasticsearch -o jsonpath='{.items[0].status.health}')
	echo -e "Awaiting green status....Current status: ${ES_HEALTH}"
done

# 3. Create jaeger secret with default username and password
# To integrate Elasticsearch with Jaeger (when later deployed), we must create a jaeger secret through which jaeger will pass logs through to Elasticsearch:

kubectl create secret generic jaeger-secret --from-literal=ES_PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}') --from-literal=ES_USERNAME=elastic

############################################################################################
############################################################################################

# Jaeger deployment

# 1. Install CRDs and RBACs

kubectl apply -f ./tracing/jaeger-crd.yaml
kubectl apply -f ./tracing/jaeger-service_account.yaml
kubectl apply -f ./tracing/jaeger-role.yaml
kubectl apply -f ./tracing/jaeger-role_binding.yaml
kubectl apply -f ./tracing/jaeger-operator.yaml

# 2. Create production ready Jaeger instance
# Apply below command to deploy the relevant Jaeger resources
kubectl apply -f ./tracing/jaeger.yaml

############################################################################################
############################################################################################

# Once Jaeger is installed, you will need to point Istio proxies to send traces to the deployment.
# Add a namespace label to instruct Istio to automatically inject Envoy sidecar proxies when you deploy your application later
kubectl label namespace default istio-injection=enabled


############################################################################################
############################################################################################

# BookInfo application deployment

kubectl apply -f ./demo/bookinfo.yaml

############################################################################################
############################################################################################

# Kiali Deployment

kubectl apply -f https://raw.githubusercontent.com/istio/istio/release-1.12/samples/addons/prometheus.yaml
kubectl apply -f ./dashboard/kiali/kiali.yaml

############################################################################################
############################################################################################

# Graphana Deployment
CLUSTER_IP=$(kubectl get svc elasticsearch-es-http -o jsonpath='{.spec.clusterIP}')
PASSWORD=$(kubectl get secret elasticsearch-es-elastic-user -o go-template='{{.data.elastic | base64decode}}')

cp ./dashboard/grafana/grafana.yaml ./dashboard/grafana/grafana-with-values.yaml
sed -i -e "s/CLUSTER_IP/${CLUSTER_IP}/g" ./dashboard/grafana/grafana-with-values.yaml
sed -i -e "s/PASSWORD/${PASSWORD}/g" ./dashboard/grafana/grafana-with-values.yaml
kubectl apply -f ./dashboard/grafana/grafana-with-values.yaml

echo -e "${GREEN}Deployment completed..."

