#!/usr/bin/env bash



CWD=$( pwd )
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd ${DIR}


source "${DIR}/conf.env"

CHEF_SERVER_IP=${1}


yum install -y zip unzip vim screen


curl --output "/tmp/chef-dk_${CHEF_DK_VERSION}.rpm" \
     --location \
     --silent \
     "https://packages.chef.io/files/stable/chefdk/${CHEF_DK_VERSION}/el/7/chefdk-${CHEF_DK_VERSION}-1.el7.x86_64.rpm"

rpm -Uvh "/tmp/chef-dk_${CHEF_DK_VERSION}.rpm"


echo "" >> /etc/ssh/sshd_config
echo "Match User ${PLATFORM_USER_NAME}" >> /etc/ssh/sshd_config
echo "    PasswordAuthentication yes" >> /etc/ssh/sshd_config
systemctl restart sshd


echo "${CHEF_SERVER_IP} ${CHEF_SERVER_NAME}" >> /etc/hosts
