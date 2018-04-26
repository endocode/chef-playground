DIR = File.dirname(__FILE__)

load "#{DIR}/conf.env"


log_level               :info
log_location            STDOUT
exit_status             :enabled
chef_server_url         "https://#{CHEF_SERVER_NAME}/organizations/#{ORGA_NAME}"
validation_client_name  "#{ORGA_NAME}-validator"
validation_key          "#{DIR}/#{ORGA_NAME}_org.key"
ssl_ca_file             "#{DIR}/chef-server-tls.crt"

file_cache_path         "#{DIR}/cache"
file_backup_path        "#{DIR}/backup"
cache_options( :path => "#{DIR}/checksums", :skip_expires => true )

data_collector.mode     :client

interval                10    # seconds, default: 1800

#user                    CHEF_NODE_USER
#group                   CHEF_NODE_GROUP
cache_path               "c:/Users/chef"

#use_policyfile          true
#policy_name             'hello-world'   # role
#policy_group            'winground'     # environment
