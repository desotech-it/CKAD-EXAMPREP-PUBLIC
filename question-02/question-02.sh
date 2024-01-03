 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-02

cat <<EOF | kind create cluster --image kindest/node:v1.29.0@sha256:eaa1450915475849a73a9227b8f201df25e55e268e5d619312131292e324d570  --config - > /dev/null 2>&1
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-02/' /home/student/.kube/config
kubectl config use-context $question
kubectl config set-context --current --cluster $question --user kind-$question


cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/pizza-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: pizza-deployment
  namespace: question-02
  labels:
    app: pizza
spec:
  replicas: 1
  selector:
    matchLabels:
      app: pizza
  template:
    metadata:
      labels:
        app: pizza
    spec:
      containers:
      - name: kubectl
        image: r.deso.tech/dockerhub/bitnami/kubectl:1.24
        command:
        - sh
        - -c
        - 'while : ; do kubectl get deployments.app ; sleep 3 ; done'
      serviceAccountName: default
EOF

kubectl apply -f $location/$question/pizza-deployment.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/pizza-role.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pizza
  namespace: question-02
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

kubectl apply -f $location/$question/pizza-role.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/pizza-rolebinding.yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pizza
  namespace: question-02
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: Role
  name: pizza
subjects:
- kind: ServiceAccount
  name: pizza
  namespace: question-02
EOF

kubectl apply -f $location/$question/pizza-rolebinding.yaml >> $LOGFILE 2>&1 

cat >> $LOGFILE 2>&1  <<EOF >>$location/$question/pizza-serviceaccount.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: pizza
  namespace: question-02
EOF

kubectl apply -f $location/$question/pizza-serviceaccount.yaml >> $LOGFILE 2>&1 