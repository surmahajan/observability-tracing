#!/usr/bin/env bash

GREEN="\033[1;32m"

echo -e "${GREEN}Start cleanup...."

# Bookinfo Clean-up
kubectl delete -f ./demo-app/app/app-with-values.yaml

# Grafana Clean-up
kubectl delete -f ./dashboard/grafana/grafana-with-values.yaml

# Kiali Clean-up
kubectl delete -f ./dashboard/kiali/kiali.yaml
kubectl delete -f ./dashboard/kiali/prometheus.yaml

# Jaeger Clean-up
kubectl delete -f ./tracing/jaeger.yaml
kubectl delete -f ./tracing/jaeger-operator.yaml
kubectl delete -f ./tracing/jaeger-role_binding.yaml
kubectl delete -f ./tracing/jaeger-role.yaml
kubectl delete -f ./tracing/jaeger-service_account.yaml
kubectl delete -f ./tracing/jaeger-crd.yaml
kubectl delete secret jaeger-secret

# Elasticsearch Clean-up
kubectl delete -f ./storage/elasticsearch.yaml
kubectl delete -f ./storage/elasticsearch_operator.yaml
kubectl delete -f ./storage/elasticsearch_crds.yaml

# Istio Clean-up
kubectl delete namespace istio-system

echo -e "${GREEN}Cleanup completed...."
