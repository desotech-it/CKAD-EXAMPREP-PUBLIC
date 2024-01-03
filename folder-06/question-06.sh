 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-06
export folder=folder-06
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-06/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/web-deployment.yaml
apiVersion: betav1applicationcontroller/v1
kind: Deployment
metadata:
  name: web-deployment
  namespace: version
  labels:
    app: web
    version: 1.15
    update: false
spec:
  replicas: 1
  template:
    metadata:
      labels:
        app: web
        version: 1.15
        update: false
    spec:
      containers:
      - name: whoami
        image: r.deso.tech/whoami/whoami:0.4.3
        ports:
        - containerPort: 80
EOF

kubectl apply -f $location/$folder/web-deployment.yaml >> $LOGFILE 2>&1 