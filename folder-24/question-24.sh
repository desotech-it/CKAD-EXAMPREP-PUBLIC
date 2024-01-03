 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-24

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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-24/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/sausage-shop-001.yaml
apiVersion: v1
kind: Pod
metadata:
  name: sausage-shop-001
  labels:
    app: shop
  namespace: question-24
spec:
  containers:
  - name: shop
    image: r.deso.tech/dockerhub/library/nginx:1
    ports:
    - containerPort: 80
EOF

kubectl apply -f $location/$question/sausage-shop-001.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/sausage-shop-002.yaml
apiVersion: v1
kind: Pod
metadata:
  name: sausage-shop-002
  labels:
    app: shop
  namespace: question-24
spec:
  containers:
  - name: shop
    image: r.deso.tech/dockerhub/library/nginx:1
    ports:
    - containerPort: 80
EOF

kubectl apply -f $location/$question/sausage-shop-002.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/sausage-shop-003.yaml
apiVersion: v1
kind: Pod
metadata:
  name: sausage-shop-003
  labels:
    app: shop
  namespace: question-24
spec:
  containers:
  - name: shop
    image: r.deso.tech/dockerhub/library/nginx:1
    ports:
    - containerPort: 80
EOF


kubectl apply -f $location/$question/sausage-shop-003.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/sausage-shop-004.yaml
apiVersion: v1
kind: Pod
metadata:
  name: sausage-shop-004
  annotations:
    description: this is the server for the E-Commerce System Sausage-shop
  labels:
    app: shop
  namespace: question-24
spec:
  containers:
  - name: shop
    image: r.deso.tech/dockerhub/library/nginx:1
    ports:
    - containerPort: 80
EOF


kubectl apply -f $location/$question/sausage-shop-004.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/sausage-shop-005.yaml
apiVersion: v1
kind: Pod
metadata:
  name: sausage-shop-005
  labels:
    app: shop
  namespace: question-24
spec:
  containers:
  - name: shop
    image: r.deso.tech/dockerhub/library/nginx:1
    ports:
    - containerPort: 80
EOF

kubectl apply -f $location/$question/sausage-shop-005.yaml >> $LOGFILE 2>&1 