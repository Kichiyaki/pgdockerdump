#!/bin/bash

connectionString=$1

downloadBackup() {
  containerName=$1
  user=$2
  dbName=$3
  ssh -o ConnectTimeout=10 "$connectionString" "docker exec $containerName pg_dump -F c -U $user -d $dbName" >"$dbName-$(date +%s).dump"
}
