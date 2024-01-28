#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]
  then
    echo "Need at least two arguments."
    echo "Usage: install.sh <NUMBEROFTHREADS> <TOKEN> [ALIAS] <package>"
    echo "<NUMBEROFTHREADS>: The number uf threads to be used by this client"
    echo "<TOKEN>: Your personal token to access the API"
    echo "[ALIAS] (OPTIONAL): The name of this client. If empty hostname will be used."    
    exit 1
fi

#private settings
token=$2
threads=$1
token="eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjUwYjNhMzliLTY4ODUtNDFkMi05Y2E2LTFhNzMxMzJhZWFkOSIsIk1pbmluZyI6IiIsIm5iZiI6MTcwMzY4NTY0MSwiZXhwIjoxNzM1MjIxNjQxLCJpYXQiOjE3MDM2ODU2NDEsImlzcyI6Imh0dHBzOi8vcXViaWMubGkvIiwiYXVkIjoiaHR0cHM6Ly9xdWJpYy5saS8ifQ.uwCG9HraAr2mzNZUu0ql7mFsr-Bk7PD5b7Wz9NwNIsQYtNcWrTH70o96hEbnoY_igiDSuI0h0KzjzMQ6ByQJrA"
host=`hostname`
minerAlias="$3"-"$host"


#public settings
currentPath=`pwd`
path=/q
# package=qli-Client-1.8.3-Linux-x64.tar.gz
package=$4
executableName=qli-Client
serviceScript=qli-Service.sh
servicePath=/etc/systemd/system
qubicService=qli.service
settingsFile=appsettings.json

#stop service if it is running
systemctl is-active --quiet qli && systemctl stop qli

# #install dependencies
# echo "deb http://cz.archive.ubuntu.com/ubuntu jammy main" >> /etc/apt/sources.list
# apt-get update && apt-get install software-properties-common libc6 g++-11 -y
# # add-apt-repository -y ppa:ubuntu-toolchain-r/test && apt update && apt install g++ -y
# wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.1-1_all.deb
# sudo dpkg -i cuda-keyring_1.1-1_all.deb
# sudo apt-get update
# sudo apt-get -y install cuda-libraries-12-3 libomp5


#install
[ ! -d "/q/" ] && mkdir $path
cd $path 
# remove existing solutions
rm $path/*.e*
rm $path/*.sol
# remove locks
rm $path/*.lock
# remove existing runners/flags
[ -f "$path/qli-runner" ] && rm $path/qli-runner
[ -f "$path/qli-processor" ] && rm $path/qli-processor
# remove installation file
[ -f "$package" ] && rm $package
wget -4 -O $package https://poolsolution.s3.eu-west-2.amazonaws.com/$package
tar -xzvf $package
rm $package
rm $path/$settingsFile
if [ ${#token} -ge 61 ]; then
  echo "{\"Settings\":{\"baseUrl\": \"https://mine.qubic.li/\",\"amountOfThreads\": $threads,\"alias\": \"$minerAlias\",\"accessToken\": \"$token\",\"allowHwInfoCollect\": true}}" > $path/$settingsFile;
else
  echo "{\"Settings\":{\"baseUrl\": \"https://mine.qubic.li/\",\"amountOfThreads\": $threads,\"alias\": \"$minerAlias\",\"accessToken\": null,\"payoutId\": \"$token\",\"allowHwInfoCollect\": true }}" > $path/$settingsFile;
fi
echo -e "[Unit]\nAfter=network-online.target\n[Service]\nStandardOutput=append:/var/log/qli.log\nStandardError=append:/var/log/qli.error.log\nExecStart=/bin/bash $path/$serviceScript\nRestart=on-failure\nRestartSec=1s\n[Install]\nWantedBy=default.target" > $servicePath/$qubicService
chmod u+x $path/$serviceScript
chmod u+x $path/$executableName
chmod 664 $servicePath/$qubicService
systemctl daemon-reload
systemctl enable $qubicService
systemctl start $qubicService
cd $currentPath
[ -f "$path/qli-Service-install.sh" ] && rm $path/qli-Service-install.sh
