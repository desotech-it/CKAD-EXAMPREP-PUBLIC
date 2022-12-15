#!/bin/bash
for q in {01..30} ;
do 
"kubectl delete ns question-$q >>$LOGFILE 2>&1" ;
done

