#!/bin/bash
kubectl create namespace jenkins
helm repo add jenkinsci https://charts.jenkins.io
helm repo update

kubectl apply -f ../jenkins/jenkins-pv.yaml
kubectl apply -f ../jenkins/jenkins-pvc.yaml

helm install jenkins -n jenkins -f ../jenkins/jenkins-values.yaml jenkinsci/jenkins
