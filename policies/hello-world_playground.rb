name 'hello-world'

default_source :chef_repo, './../cookbooks'
default_source :supermarket

cookbook 'hello-web-world', '~> 1.0.0'

run_list 'hello-web-world::default'
