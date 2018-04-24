DIR = File.dirname(__FILE__)

load "#{DIR}/conf.env"


log_level               :info
log_location            STDOUT
exit_status             :enabled
chef_server_url         "https://#{CHEF_SERVER_NAME}/organizations/#{ORGA_NAME}"
validation_client_name  "#{ORGA_NAME}-validator"
validation_key          "/etc/chef/#{ORGA_NAME}_org.key"
ssl_ca_file             '/etc/chef/chef-server-tls.crt'

data_collector.mode     :client

interval                10    # seconds, default: 1800

#user                    CHEF_NODE_USER
#group                   CHEF_NODE_GROUP
cache_path              CHEF_NODE_DIR_CACHE

#use_policyfile          true
#policy_name             'hello-world'   # role
#policy_group            'playground'  # environment
