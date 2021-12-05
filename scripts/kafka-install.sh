#!/bin/bash
helm repo add incubator https://charts.helm.sh/incubator
helm repo update
helm install kafka -n kafka incubator/kafka -f ../kafka/values.yaml
