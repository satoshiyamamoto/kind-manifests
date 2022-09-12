#!/bin/bash

kind create cluster
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.5/config/manifests/metallb-native.yaml
kubectl get pods -n metallb-system --watch
docker network inspect -f '{{.IPAM.Config}}' kind
#kubectl apply -f https://kind.sigs.k8s.io/examples/loadbalancer/metallb-config.yaml
cat <<EOF | k apply -f-
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
  - 172.18.255.200-172.18.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
EOF
