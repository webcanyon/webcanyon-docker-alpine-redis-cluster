#!/bin/bash

nodePort="$1"
numNodes="$2"
args=("${@:3}")

SET_CLUSTER="cd /usr/src/redis/src/ && echo 'yes' | ./redis-trib.rb create --replicas 1"

mkdir /var/log/redis

for ((i = 1; i <= numNodes; i++, nodePort++)); do
    SET_CLUSTER+=" 127.0.0.1:$nodePort"
	mkdir $nodePort
	redis-server --daemonize yes --dir ./"$nodePort" --port "$nodePort" "${args[@]}" &>"/var/log/redis/cluster.$nodePort.log" &
done

echo "Set nodes as cluster"
echo "$SET_CLUSTER"

eval $SET_CLUSTER

echo "This script is running now so cluster is up! @@0"

tail -f /var/log/redis/cluster*