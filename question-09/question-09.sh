 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-09

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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-09/' /home/student/.kube/config
kubectl config use-context $question
kubectl config set-context --current --cluster $question --user kind-$question


cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/soccer-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: soccer-deployment
  namespace: question-09
  labels:
    app: soccer
spec:
  replicas: 3
  selector:
    matchLabels:
      app: soccer
  template:
    metadata:
      labels:
        app: soccer
    spec:
      containers:
      - name: kubectl
        image: r.deso.tech/dsk/dsutils:latest
EOF

kubectl apply -f $location/$question/soccer-deployment.yaml >> $LOGFILE 2>&1 