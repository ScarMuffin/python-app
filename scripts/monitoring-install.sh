#!/bin/bash
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
kubectl apply -f ../config-map.yaml
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring --create-namespace
