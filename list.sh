#!/bin/bash

for i in $(grep "^mk" create_dir.sh |awk '{print $NF}');do

  echo "- {path: '$i', owner: hdfs, group: hdfs, mode: 0755, state: directory}"
done
