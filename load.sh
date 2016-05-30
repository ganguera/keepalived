#!/bin/bash

trap "trap - SIGTERM && kill -- -$$" SIGINT SIGTERM EXIT

function load {
  while true
  do
    ab -n 1000 -c 10 http://172.16.10.10/
  done
}

counter=0
while [ $counter -lt $1 ]
do
  load &
  counter=$[$counter + 1]
done

while true
do
  sleep 1
done
