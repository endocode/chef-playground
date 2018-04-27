Chef Playground
=========================


The primary goal here is to create an environment where you can focus on developing your 
infrastructure configurations (everything that goes in a `chef-repo`). Instead of going down the 
virtualization rabbit hole (this repository), you might want to consider using 
[Chef-Zero](https://github.com/chef/chef-zero) or going all 
[node-only](https://medium.com/@emachnic/using-policyfiles-with-chef-client-local-mode-4f47477b24db)
by exporting your configurations.


__Prerequisites:__

+   Ruby
+   Vagrant

You might also want to install `Chef DK`, which is necessary if you plan to use your host system as
the *workstation* (incl. `knife`).
Additionally, since the root of this repository contains a `.chef/` directory, it is also meant to
be used as your chef-repo. Thus, you probably want to add some more folders like `coockbooks` or 
`data_bags`.


## Stove or microwave???


### Full Environment

The [Chef architecture](https://docs.chef.io/chef_overview.html) consists of three components: 
-   Workstation
-   Node
-   Server

With the help of this repository you can instantiate a whole Chef environment on your local computer.
It spins up at least one vm (chef-server), usually more (one linux and one windows), which is also 
the default (see `./playground.conf` for changing this behaviour) 


### Kitchen

In case the former is to much overhead, you can either use `chef-client --local-mode` in one of the 
nodes or utilize [Test Kitchen](https://kitchen.ci/), which incorporates Chef-Zero 
(in-memory Chef Server) and Vagrant (as node driver) to apply your configuration. For more details 
see `./.kitchen.yml` and its [docs](https://docs.chef.io/config_yml_kitchen.html).


## Installation

1.  
    a)  Adjust `./playground.conf` according to your needs
    b)  (OPTIONAL) Depending on your Chef configuration (cookbooks, attributes, etc) you might want 
        your host system to resolve some node IPs. For that, you have to add some entries in your 
        host system's `etc/hosts` file.  

2.  Spinning up VMs
```bash
cd ./
vagrant up
```

3.  Configure Workstation

```bash
# install servers TLS certificate 
knife ssl fetch
```

*NOTE: If you want the host system resolve Chef server's hostname, change the `./chef/knife.rb` 
and your `etc/hosts` accordingly, otherwise enable the configuration: `ssl_verify_mode :verify_none`*

4. Bootstrap Nodes

Nothing to do here. All nodes (windows as well as linux) are bootstrapped and registered with the 
server automatically during provisioning.


## Usage

### Nodes

How may nodes get spawned is totally up to you. Adjust the amount in `playground.conf`. The 
`chef-client` on every node ist not executed automatically on a regular basis (daemonized). That's 
what the `DAEMONIZE_CHEF_CLIENT` flag is for. Though, on Linux nodes you can simply go into the node
and enable the systemd service `chef-client` to activate this desired behaviour. Change the interval
in `/etc/chef/client.rb` and restart the service.


### Virtual Workstation

If you set `CREATE_WORKSTATION` to `true` in `./playground.conf` you will get an additional vm with 
the *Chef DK* installed, which can then be used as your workstation. This repository is shared
with the vm under `/home/vagrant/chef-repo`.

```bash
vagrant ssh chef-workstation

cd ~/chef-repo
```

### Example(s)

There are two simple *Hello World* examples in this repository located in `/cookbooks` and 
`policies`. One is a simple web server and the other one targets windows. They are here mainly for
test purposes, but feel free to make them somewhat useful.


### Policyfile

If you want to work with `Policyfiles`, and therefore `policy_name` and `policy_group`, you have to
make sure that those two are configured accordingly. In order to do so, please follow: 

1. Connect to the desired machine

*Linux:*
```bash
vagrant ssh chef-linux-node-${NUMBER}
```

*Windows:*
Enable the Graphical user interface in the `Vagrantfile` (within the `WINDOWS_NODES` block go to 
the `node.vm.provider "virtualbox"` section and set `vb.gui = true`) or use Virtualbox to open the 
GUI windows for the node in question.  


2. ...and change the chef client configuration

*Linux:*
```bash
nano /etc/chef/client.rb
```

*Windows:*
Use the GUI or a winrm session to change `c:\chef\client.rb`.
