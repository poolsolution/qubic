#!/bin/bash

if [ -z "$1" ] || [ -z "$2" ]
  then
    echo "Need at least two arguments."
    echo "Usage: install.sh <NUMBEROFTHREADS> <TOKEN> [ALIAS]"
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

echo $minerAlias
