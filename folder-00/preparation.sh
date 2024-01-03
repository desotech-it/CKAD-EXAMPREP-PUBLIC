#!/bin/bash

git clone --depth=1 https://github.com/desotech-it/DSK402-public.git -b 1.28-dev >> $LOGFILE 2>&1 

mv DSK402-public CKAD-material >> $LOGFILE 2>&1 

cd CKAD-material >> $LOGFILE 2>&1 

chmod +x cleanup.sh

for q in {00..27} ; do chmod +x folder-"$q"/*.sh ; done >> $LOGFILE 2>&1 
