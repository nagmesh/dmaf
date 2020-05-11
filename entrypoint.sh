#!/bin/bash

function script_usage {
  echo " Script Usage: ./entrypoint.sh /path/to/file"
}


INPUT=$1
if [[ ($# -le 0) || ($# -ge 2) || ( $# == "--help") ||  ($# == "-h")]]
  then 
    script_usage
    exit 1
fi 
docker pull busybox
docker volume create --name dmaf
docker run -d --name input-copy-container -v dmaf:/dmaf busybox
docker cp $1 input-copy-container:/dmaf/schemas.csv
docker rm -f input-copy-container
docker run -d -it -e SCHEMA_FILE=schemas.csv -e SCHEMA_VOLUME=/dmaf -v dmaf:/dmaf -p 80:80 nagmesh/dmaf
