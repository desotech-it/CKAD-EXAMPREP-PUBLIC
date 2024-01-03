 #!/bin/bash

export location=/home/student/CKAD-material
export question=question-14
export folder=folder-14
export LOGFILE=$question.log
touch $LOGFILE >> $LOGFILE 2>&1

cleanup.sh >> $LOGFILE 2>&1
#for q in {01..27} ; do rm folder-"$q"/*.yaml ; done >> $LOGFILE 2>&1



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