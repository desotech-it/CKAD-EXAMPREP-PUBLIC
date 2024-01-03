 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-22
export folder=folder-22
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-22/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/question-22-sa-v2.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: question-22-sa-v2
  namespace: question-22
EOF

kubectl apply -f $location/$folder/question-22-sa-v2.yaml >> $LOGFILE 2>&1 
rm -f $folder/*.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/question-22-sa-v2-secret.yaml
apiVersion: v1
kind: Secret
metadata:
  name: question-22-sa-v2-secret
  namespace: question-22
  annotations:
    kubernetes.io/service-account.name: question-22-sa-v2
type: kubernetes.io/service-account-token
EOF

kubectl apply -f $location/$folder/question-22-sa-v2-secret.yaml >> $LOGFILE 2>&1 
rm -f $folder/*.yaml