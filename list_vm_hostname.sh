#!/bin/bash
# list vm hostname



if [[ $1 == 'ubuntu' ]]
then
	qm list | grep ubuntu | grep -v templ | tr -s ' ' | cut -d ' ' -f 3

elif [[ $1 == 'centos' ]]
then
	qm list | grep centos | grep -v templ | tr -s ' ' | cut -d ' ' -f 3

else
	qm list | grep ubuntu | grep -v templ | tr -s ' ' | cut -d ' ' -f 3
	qm list | grep centos | grep -v templ | tr -s ' ' | cut -d ' ' -f 3
fi	
