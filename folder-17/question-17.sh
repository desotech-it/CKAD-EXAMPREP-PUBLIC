 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-17
export folder=folder-17
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

cleanup.sh >> $LOGFILE 2>&1
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-17/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
kubectl create ns security >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/secret-2.yaml
apiVersion: v1
data:
  pass: cGFzc3dvcmQK
  user: dGVzdA==
kind: Secret
metadata:
  creationTimestamp: null
  name: secret-2
  namespace: security
EOF

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/secret-handler.yaml
apiVersion: v1
kind: Pod
metadata:
  labels:
    id: secret-handler
    uuid: 1428721e-8d1c-4c09-b5d6-afd79200c56a
    red_ident: 9cf7a7c0-fdb2-4c35-9c13-c2a0bb52b4a9
    type: automatic
  name: secret-handler
  namespace: security
spec:
  volumes:
  - name: cache-volume1
    emptyDir: {}
  - name: cache-volume2
    emptyDir: {}
  - name: cache-volume3
    emptyDir: {}
  containers:
  - name: secret-handler
    image: bash:5.0.11
    args: ['bash', '-c', 'sleep 2d']
    volumeMounts:
    - mountPath: /cache1
      name: cache-volume1
    - mountPath: /cache2
      name: cache-volume2
    - mountPath: /cache3
      name: cache-volume3
    env:
    - name: SECRET_KEY_1
      value: ">8$kH#kj..i8}HImQd{"
    - name: SECRET_KEY_2
      value: "IO=a4L/XkRdvN8jM=Y+"
    - name: SECRET_KEY_3
      value: "-7PA0_Z]>{pwa43r)__"
EOF

kubectl apply -f $location/$folder/secret-handler.yaml >> $LOGFILE 2>&1