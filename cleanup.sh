#!/bin/bash

export LOGFILE=clean$question.log
touch $LOGFILE >> $LOGFILE 2>&1

for q in {01..27} ; do kind delete cluster -n question-"$q" ; done >> $LOGFILE 2>&1 

rm -f /home/student/.kube/config >> $LOGFILE 2>&1 

for q in {01..27} ; do rm folder-"$q"/*.yaml ; done >> $LOGFILE 2>&1 
