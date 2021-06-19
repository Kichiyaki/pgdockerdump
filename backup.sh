#!/bin/bash

connectionString=$1

downloadBackup() {
  containerName=$1
  user=$2
  dbName=$3
  if [ -z "$containerName" ] || [ -z "$user" ] || [ -z "$dbName" ]; then
    echo "downloadBackup error: not enough arguments passed to this function"
    return
  fi
  filename="$dbName-$(date +%s).dump"
  ssh -o ConnectTimeout=10 "$connectionString" "docker exec $containerName pg_dump -F c -U $user -d $dbName" >"$filename"
  zip "$filename.zip" "$filename"
  rm -rf "$filename"
}

deleteOldBackups() {
  dbName=$1
  sub=$2
  if [ -z "$dbName" ] || [ -z "$sub" ]; then
    echo "deleteOldBackups error: not enough arguments passed to this function"
    return
  fi
  files=($(ls *.dump.zip))
  timestamp="$(date +%s)"
  difference="$((timestamp - sub))"
  for f in "${files[@]}"; do
    IFS='-' read -ra parts <<<"${f/.dump.zip/}"
    if [ "${#parts[@]}" != "2" ] || [ "${parts[0]}" != "$dbName" ] || [[ ${parts[1]} -ge $difference ]]; then
      continue
    fi
    echo "deleting: $f"
    rm -rf "$f"
  done
}
