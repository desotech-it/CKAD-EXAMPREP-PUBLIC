 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-14
export folder=folder-14
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

sed -i '/^\s*name:/s/\(name:\s*\).*/\1question-14/' /home/student/.kube/config
kubectl config use-context $question  >> $LOGFILE 2>&1
kubectl config set-context --current --cluster $question --user kind-$question  >> $LOGFILE 2>&1

cat >> $LOGFILE 2>&1  <<EOF >>$location/$folder/Docker-file01
FROM r.deso.tech/dockerhub/library/alpine:3.13.5

# Here we  set Rome time zone locale as default.
ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8


RUN apk update --no-cache && apk add ca-certificates --no-cache && \
    apk add tzdata --no-cache && \
    ln -sf /usr/share/zoneinfo/Europe/Rome /etc/localtime && \
    echo "Europe/Rome" > /etc/timezone
EOF