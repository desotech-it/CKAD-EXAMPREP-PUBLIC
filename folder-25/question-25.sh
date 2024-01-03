 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-25
export folder=folder-25
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-25/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/deploy-q25-copy-0.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    kubernetes.io/change-cause: original
  name: bluegreen
  namespace: production-new-release
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
        image: r.deso.tech/dockerhub/library/httpda:latest
EOF


kubectl apply -f $location/$folder/deploy-q25-copy-0.yaml >> $LOGFILE 2>&1 
rm -f $folder/deploy-q25-copy-0.yaml

sleep 10

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/deploy-q25-copy-1.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    kubernetes.io/change-cause: kubectl edit new version -- upgrade memory limit
  name: bluegreen
  namespace: production-new-release
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
        image: r.deso.tech/dockerhub/library/httpdt:latest
EOF


kubectl apply -f $location/$folder/deploy-q25-copy-1.yaml >> $LOGFILE 2>&1 
rm -f $folder/deploy-q25-copy-1.yaml

sleep 10

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/deploy-q25-copy-2.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: bluegreen
  namespace: production-new-release
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
        image: r.deso.tech/dockerhub/library/httpdd:latest
EOF

kubectl apply -f $location/$folder/deploy-q25-copy-2.yaml >> $LOGFILE 2>&1 
rm -f $folder/deploy-q25-copy-2.yaml

sleep 10

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/deploy-q25-copy-3.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    kubernetes.io/change-cause: kubectl edit new version -- upgrade 
  name: bluegreen
  namespace: production-new-release
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
        image: r.deso.tech/dockerhub/library/httpd:latest
EOF


kubectl apply -f $location/$folder/deploy-q25-copy-3.yaml >> $LOGFILE 2>&1 
rm -f $folder/deploy-q25-copy-3.yaml

sleep 10

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/deploy-q25-copy-4.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  annotations:
    kubernetes.io/change-cause: kubectl edit new version -- upgrade cpu limit
  name: bluegreen
  namespace: production-new-release
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
        image: r.deso.tech/dockerhub/library/httpdf:latest
EOF

kubectl apply -f $location/$folder/deploy-q25-copy-4.yaml >> $LOGFILE 2>&1 
rm -f $folder/deploy-q25-copy-4.yaml

sleep 10