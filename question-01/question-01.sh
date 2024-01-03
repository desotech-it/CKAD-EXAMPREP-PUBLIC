#!/bin/bash

export location=/home/student/CKAD-material
export question=question-01

export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

cat <<EOF | kind create cluster --image kindest/node:v1.29.0@sha256:eaa1450915475849a73a9227b8f201df25e55e268e5d619312131292e324d570  --config - > /dev/null 2>&1
kind: Cluster
name: $question
apiVersion: kind.x-k8s.io/v1alpha4
networking:
  podSubnet: "10.199.0.0/16"
  serviceSubnet: "10.200.0.0/16"
nodes:
- role: control-plane
- role: worker
- role: worker
EOF


sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-01/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1


cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/burger-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: burger-deployment
  namespace: question-01
  labels:
    app: burger
spec:
  replicas: 1
  selector:
    matchLabels:
      app: burger
  template:
    metadata:
      labels:
        app: burger
    spec:
      containers:
      - name: whoami
        image: r.deso.tech/whoami/whoami:0.4.3
        ports:
        - containerPort: 80
EOF


kubectl apply -f $location/$question/burger-deployment.yaml >> $LOGFILE 2>&1 