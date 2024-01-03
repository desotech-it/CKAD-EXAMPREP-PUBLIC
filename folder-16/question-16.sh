 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-16
export folder=folder-16
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-16/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1
kubectl create namespace bar  >> $LOGFILE 2>&1


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/foo-app-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: foo-app-role
  namespace: bar
rules:
- apiGroups:
  - apps
  resources:
  - deployments
  verbs:
  - get
  - watch
  - list
EOF

kubectl apply -f $location/$folder/foo-app-role.yaml >> $LOGFILE 2>&1 
rm -f $folder/foo-app-role.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/foo-app-saccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: foo-app-saccount
  namespace: default
EOF

kubectl apply -f $location/$folder/foo-app-saccount.yaml >> $LOGFILE 2>&1 
rm -f $folder/foo-app-saccount.yaml

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/foo-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: foo-app
  namespace: bar
  labels:
    app: foo
    ns: bar
    env: ckad
    end: never
    project: kubectl
spec:
  replicas: 1
  selector:
    matchLabels:
      app: foo
  template:
    metadata:
      labels:
        app: foo
        ns: bar
        env: ckad
        end: never
        project: kubectl
    spec:
      containers:
      - name: foo-c01
        image: r.deso.tech/dockerhub/bitnami/kubectl:1.24
        command:
        - sh
        - -c
        - 'while : ; do kubectl get deployments.app ; sleep 3 ; done'
EOF

kubectl apply -f $location/$folder/foo-app.yaml >> $LOGFILE 2>&1 


cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/rb-foo.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rb-foo
  namespace: bar
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: foo-app-role
subjects:
- kind: ServiceAccount
  name: foo-app-saccount
  namespace: default
EOF

kubectl apply -f $location/$folder/rb-foo.yaml >> $LOGFILE 2>&1 
rm -f $folder/rb-foo.yaml