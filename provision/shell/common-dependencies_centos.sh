#!/usr/bin/env bash



CWD=$( pwd )
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd ${DIR}



yum check-update -y
yum update -y


yum install wget curl git nano -y
yum install ruby -y