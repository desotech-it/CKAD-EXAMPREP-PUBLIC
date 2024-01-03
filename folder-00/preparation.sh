#!/bin/bash

git clone --depth=1 https://github.com/desotech-it/DSK402-public.git -b 1.28-dev >> /dev/null 2>&1 

mv DSK402-public CKAD-material >> /dev/null 2>&1 

cd CKAD-material >> /dev/null 2>&1 

chmod +x cleanup.sh

for q in {00..27} ; do chmod +x folder-"$q"/*.sh ; done >> /dev/null 2>&1 
