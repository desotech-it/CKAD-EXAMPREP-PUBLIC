 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-18
export folder=folder-18
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

cat <<EOF | kind create cluster  --image kindest/node:v1.29.0@sha256:eaa1450915475849a73a9227b8f201df25e55e268e5d619312131292e324d570  --config - > /dev/null 2>&1
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-18/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/manager-api-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: manager-api-deployment
  namespace: question-18
  labels:
    app: manager-api-deployment
spec:
  replicas: 6
  selector:
    matchLabels:
      id: manager-api-pod
  template:
    metadata:
      labels:
        id: manager-api-pod
    spec:
      containers:
      - name: manager-container
        image: r.deso.tech/dockerhub/library/nginx:stable
        ports:
        - containerPort: 80
EOF

kubectl apply -f $location/$folder/manager-api-deployment.yaml >> $LOGFILE 2>&1 
rm -f $folder/*.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/manager-api-svc.yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: manager-api-svc
  name: manager-api-svc
  namespace: question-18
spec:
  ports:
  - port: 4444
    protocol: TCP
    targetPort: 80
  selector:
    id: manager-api-deployment
  sessionAffinity: None
  type: ClusterIP
EOF

kubectl apply -f $location/$folder/manager-api-svc.yaml >> $LOGFILE 2>&1 
rm -f $folder/*.yaml