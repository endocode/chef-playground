DIR = File.dirname(__FILE__)

load "#{DIR}/conf.env"


log_level               :info
log_location            STDOUT
exit_status             :enabled
chef_server_url         "https://#{CHEF_SERVER_NAME}/organizations/#{ORGA_NAME}"
validation_client_name  "#{ORGA_NAME}-validator"
validation_key          "/etc/chef/#{ORGA_NAME}_org.key"
ssl_ca_file             '/etc/chef/chef-server-tls.crt'

file_cache_path         CHEF_NODE_DIR_CACHE
file_backup_path        CHEF_NODE_DIR_BACKUP
cache_options( :path => CHEF_NODE_DIR_CHECKSUMS, :skip_expires => true )

data_collector.mode     :client

interval                10    # seconds, default: 1800

#user                    PLATFORM_USER_NAME
#group                   PLATFORM_USER_GROUP
cache_path              "/home/#{PLATFORM_USER_NAME}"

#use_policyfile          true
#policy_name             'hello-world'   # role
#policy_group            'playground'  # environment
