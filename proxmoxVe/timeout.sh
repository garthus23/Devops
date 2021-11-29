#!/bin/bash

for ((ip=2;ip != 255;ip++))
do
	timeout 0.005 ping -c 1 10.10.10.$ip
        if [[ $? == 0 ]]
        then
        	echo "zero"
        fi
done

