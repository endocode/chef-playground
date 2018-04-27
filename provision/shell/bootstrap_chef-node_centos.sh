#!/usr/bin/env bash



CWD=$( pwd )
DIR="$( cd "$(dirname "$0")" ; pwd -P )"
cd ${DIR}


source "${DIR}/conf.env"

HOST_SHARE=${1:-/tmp}
CHEF_SERVER_IP=${2}


CHEF_CLIENT_INSTALL_SCRIPT_URL="https://omnitruck.chef.io/install.sh"


CHEF_CLIENT_INSTALL_SCRIPT_FILE_PATH="/tmp/install-chef-client.sh"
curl --output "${CHEF_CLIENT_INSTALL_SCRIPT_FILE_PATH}" \
     --location \
     --silent \
     "${CHEF_CLIENT_INSTALL_SCRIPT_URL}"

bash "${CHEF_CLIENT_INSTALL_SCRIPT_FILE_PATH}" -v "${CHEF_CLIENT_VERSION}"


mkdir -p "${CHEF_NODE_CONF_DIR}" "${CHEF_NODE_DIR_CACHE}" "${CHEF_NODE_DIR_BACKUP}"
cp -rf "${DIR}/client.rb" "${CHEF_NODE_CONF_DIR}/"
cp -rf "${HOST_SHARE}/${ORGA_NAME}_org.key" "${CHEF_NODE_CONF_DIR}/"
cp -rf "${HOST_SHARE}/chef-server-tls.crt" "${CHEF_NODE_CONF_DIR}/"
chown "${PLATFORM_USER_NAME}:${PLATFORM_USER_GROUP}" -R \
    "${CHEF_NODE_CONF_DIR}" "${CHEF_NODE_DIR_CACHE}" "${CHEF_NODE_DIR_BACKUP}"

cp -rf "${DIR}/conf.env" "${CHEF_NODE_CONF_DIR}/"
cp -rf "${DIR}/chef-client.unit" "/etc/systemd/system/chef-client.service"
chown root:root "/etc/systemd/system/chef-client.service"
if [ "${DAEMONIZE_CHEF_CLIENT}" = true ]; then
    systemctl enable chef-client.service
    systemctl start chef-client.service
fi


echo "${CHEF_SERVER_IP} ${CHEF_SERVER_NAME}" >> /etc/hosts


/usr/bin/chef-client --once
