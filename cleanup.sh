#!/bin/bash
for q in {01..27} ; do kubectl delete ns question-"$q" ; done

