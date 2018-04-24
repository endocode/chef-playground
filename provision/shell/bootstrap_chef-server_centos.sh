#!/usr/bin/env bash



CWD=$( pwd )
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd ${DIR}


source "${DIR}/conf.env"

HOST_SHARE=${1:-/tmp}
HOST_NAME=$(hostname)


CHEF_SERVER_PKG_URL="https://packages.chef.io/files/stable/chef-server/${CHEF_SERVER_VERSION}/el/7/chef-server-core-${CHEF_SERVER_VERSION}-1.el7.x86_64.rpm"


yum check-update -y
yum update -y


CHEF_SERVER_PKG_FILE="/tmp/chef-server-core-${CHEF_SERVER_VERSION}.rpm"
curl --output "${CHEF_SERVER_PKG_FILE}" \
     --location \
     --silent \
     "${CHEF_SERVER_PKG_URL}"

rpm -Uvh "${CHEF_SERVER_PKG_FILE}"

mkdir -p "/etc/opscode"
cp -rf "${DIR}/chef-server.rb" "/etc/opscode"
sed -i '/^api_fqdn/d' "/etc/opscode/chef-server.rb"
echo "" >> "/etc/opscode/chef-server.rb"
echo "# Following lines have been added automatically during provision:" >> "/etc/opscode/chef-server.rb"
echo "api_fqdn          '${CHEF_SERVER_NAME}'" >> "/etc/opscode/chef-server.rb"

chef-server-ctl reconfigure

CHEF_KEYS_PATH="/etc/chef/keys"
mkdir -p "${CHEF_KEYS_PATH}"
chmod 777 "${CHEF_KEYS_PATH}" -R
chef-server-ctl user-create "${USER_NAME}" Myfirst Mylast "${USER_NAME}@chef.local" "${USER_PW}" \
                --filename "${CHEF_KEYS_PATH}/${USER_NAME}.key"
chef-server-ctl org-create "${ORGA_NAME}" "Orga Name" \
                --association_user "${USER_NAME}" \
                --filename "${CHEF_KEYS_PATH}/${ORGA_NAME}.key"

chef-server-ctl install chef-manage
chef-server-ctl reconfigure
chef-manage-ctl reconfigure
chef-manage-ctl reconfigure --accept-license
chef-server-ctl install opscode-push-jobs-server
opscode-push-jobs-server-ctl reconfigure


cp -rf "${CHEF_KEYS_PATH}/${ORGA_NAME}.key" "${HOST_SHARE}/${ORGA_NAME}_org.key"
cp -rf "${CHEF_KEYS_PATH}/${USER_NAME}.key" "${HOST_SHARE}/${USER_NAME}_user.key"
cp -rf "/var/opt/opscode/nginx/ca/${HOST_NAME}.crt" "${HOST_SHARE}/chef-server-tls.crt"


echo " IMPORTANT: Chef Server is accessible under https://#{CHEF_SERVER_NAME} or https://#{CHEF_SERVER_IP} (You might want to add this to your /etc/hosts)"