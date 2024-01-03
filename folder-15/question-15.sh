 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-15
export folder=folder-15
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-15/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/spaghetti-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: spaghetti-deployment
  namespace: question-15
  labels:
    app: spaghetti
spec:
  replicas: 7
  selector:
    matchLabels:
      app: pasta
  template:
    metadata:
      labels:
        app: pasta
    spec:
      containers:
      - name: pasta
        image: r.deso.tech/whoami/whoami:latest
        ports:
        - containerPort: 80
EOF

kubectl apply -f $location/$folder/spaghetti-deployment.yaml >> $LOGFILE 2>&1 
rm -f $folder/*.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/spaghetti-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: pasta-service
  namespace: question-15
spec:
  type: ClusterIP
  selector:
    app: pasta
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl apply -f $location/$folder/spaghetti-service.yaml >> $LOGFILE 2>&1 
rm -f $folder/*.yaml