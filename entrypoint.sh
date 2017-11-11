#!/bin/bash

nodePort="$1"
numNodes="$2"
args=("${@:3}")

for ((i = 1; i < numNodes; i++, nodePort++)); do
	mkdir $nodePort
	redis-server --daemonize yes --dir ./"$nodePort" --port "$nodePort" "${args[@]}"
done

mkdir /var/log/redis
mkdir "$nodePort"
redis-server --daemonize no --dir ./"$nodePort" --port "$nodePort" "${args[@]}" &>/var/log/redis/cluster.log &

cd /usr/src/redis/src/ && echo "yes" | ./redis-trib.rb create --replicas 1 127.0.0.1:7379\
 127.0.0.1:7380 127.0.0.1:7381 127.0.0.1:7382 127.0.0.1:7383 127.0.0.1:7384

echo "This script is running now so cluster is up! @@0"

tail -f /var/log/redis/cluster.log