#!/bin/bash
for q in {01..30} ; do kubectl delete ns question-"$q" ; done

