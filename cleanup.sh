#!/bin/bash
for q in {01..27} ; do kind delete cluster -n question-"$q" ; done

rm -f /home/student/.kube/config

