#!/bin/bash

kubectl apply -f ../ingress/alertmanager-ingress.yaml
kubectl apply -f ../ingress/app-ingress.yaml
kubectl apply -f ../ingress/grafana-ingress.yaml
kubectl apply -f ../ingress/jenkins-ingress.yaml 
kubectl apply -f ../ingress/prometheus-ingress.yaml

