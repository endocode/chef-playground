DIR = File.dirname(__FILE__)

load "#{DIR}/../playground.conf"


log_level               :info
log_location            STDOUT

node_name               USER_NAME

client_key              "#{DIR}/../provision/#{USER_NAME}_user.key"

# without changes to /etc/hosts
chef_server_url         "https://#{NETWORK_SLASH24_PREFIX}.11/organizations/#{ORGA_NAME}"
ssl_verify_mode         :verify_none
# OR with hostname resolution due to changes to /etc/hosts
#chef_server_url         "https://#{CHEF_SERVER_NAME}/organizations/#{ORGA_NAME}"
#ssl_verify_mode         :verify_peer

cache_type              'BasicFile'
cache_options( :path => "#{DIR}/checksums" )

cookbook_path           [ "#{DIR}/../cookbooks" ]
