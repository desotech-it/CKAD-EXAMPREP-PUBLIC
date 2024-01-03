 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-11
export folder=folder-11
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

.$location/cleanup.sh >> $LOGFILE 2>&1
#for q in {01..27} ; do rm folder-"$q"/*.yaml ; done >> $LOGFILE 2>&1

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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-11/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/donut-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: donut-deployment
  namespace: chicago
  labels:
    app: donut
spec:
  replicas: 4
  selector:
    matchLabels:
      app: donut
  template:
    metadata:
      labels:
        app: donut
    spec:
      containers:
      - name: kubectl
        image: r.deso.tech/whoami/whoami:latest
EOF

kubectl apply -f $location/$folder/donut-deployment.yaml >> $LOGFILE 2>&1 
rm -f $folder/donut-deployment.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/donut-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: donut-service
  namespace: chicago
spec:
  type: ClusterIP
  selector:
    app: donut
  ports:
  - port: 80
    targetPort: 80
EOF

kubectl apply -f $location/$folder/donut-service.yaml >> $LOGFILE 2>&1 
rm -f $folder/donut-service.yaml