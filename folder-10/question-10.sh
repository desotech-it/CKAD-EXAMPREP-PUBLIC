 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-10
export folder=folder-10
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

./cleanup.sh >> $LOGFILE 2>&1
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-10/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
kubectl create namespace shop  >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/cafe-newpod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: cafe-newpod
  labels:
    drink: cafe
  namespace: shop
spec:
  containers:
  - name: cafe
    image: r.deso.tech/dockerhub/nicolaka/netshoot
    command:
    - sleep
    - '100000000'
EOF

kubectl apply -f $location/$folder/cafe-newpod.yaml >> $LOGFILE 2>&1 

rm -f $folder/cafe-newpod.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/cappuccino-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: cappuccino-pod
  labels:
    drink: cappuccino
  namespace: shop
spec:
  containers:
  - name: cappuccino
    image: r.deso.tech/dockerhub/library/nginx:1
    ports:
    - containerPort: 80
EOF

kubectl apply -f $location/$folder/cappuccino-pod.yaml >> $LOGFILE 2>&1 
rm -f $folder/cappuccino-pod.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/espresso-pod.yaml
apiVersion: v1
kind: Pod
metadata:
  name: espresso-pod
  labels:
    drink: espresso
  namespace: shop
spec:
  containers:
  - name: espresso
    image: r.deso.tech/dockerhub/library/httpd:2
    ports:
    - containerPort: 80
EOF

kubectl apply -f $location/$folder/espresso-pod.yaml >> $LOGFILE 2>&1 

rm -f $folder/espresso-pod.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/cafe-networkpolicy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: access-espresso
  namespace: shop
spec:
  podSelector:
    matchLabels:
      allow-espresso: "true"
  ingress:
    - from:
        - podSelector:
            matchLabels:
              drink: espresso
  egress:
    - to:
        - podSelector:
            matchLabels:
              drink: espresso
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: access-cappuccino
  namespace: shop
spec:
  podSelector:
    matchLabels:
      allow-cappuccino: "true"
  ingress:
    - from:
        - podSelector:
            matchLabels:
              drink: cappuccino
  egress:
    - to:
        - podSelector:
            matchLabels:
              drink: cappuccino
EOF

kubectl apply -f $location/$folder/cafe-networkpolicy.yaml >> $LOGFILE 2>&1 
rm -f $folder/cafe-networkpolicy.yaml