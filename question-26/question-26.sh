 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-26

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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-26/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/mickey-api.yaml
apiVersion: v1
kind: Pod
metadata:
  name: mickey-api
  labels:
    id: mickey-api
spec:
  containers:
  - env:
    - name: CACHE_KEY_1
      value: b&MTCi0=[T66RXm!jO@
    - name: CACHE_KEY_2
      value: PCAILGej5Ld@Q%{Q1=#
    - name: CACHE_KEY_3
      value: 2qz-]2OJlWDSTn_;RFQ
    image: nginx:1.17.3-alpine
    name: mickey-api-container
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
  volumes:
  - emptyDir: {}
    name: cache-volume1
  - emptyDir: {}
    name: cache-volume2
  - emptyDir: {}
    name: cache-volume3
EOF


kubectl apply -f $location/$question/mickey-api.yaml >> $LOGFILE 2>&1 