Chef Playground
=========================


The primary goal here is to create an environment where you can focus on developing your 
infrastructure configurations (everything that goes in a `chef-repo`). Instead of going down the 
virtualization rabbit hole (this repository), you might want to consider using 
[Chef-Zero](https://github.com/chef/chef-zero) or going all 
[node-only](https://medium.com/@emachnic/using-policyfiles-with-chef-client-local-mode-4f47477b24db)


__Prerequisites:__

+   Ruby
+   Vagrant

You might also want to install `Chef DK`, which is necessary if you plan to use your host system as
the *workstation* (incl. `knife`).
Additionally, since the root of this repository contains a `.chef/` directory, it is also meant to
be used as your chef-repo, thus, you probably want to add some more folders like `coockbooks` or 
`data_bags`.


## Stove or microwave???


### Full Environment

Will spin up at least one vm (chef-server), usually more (one linux and one windows) 


### Kitchen

Uses Chef-Zero (in-memory Chef Server) and Vagrant (for the nodes) to apply your configuration


## Installation

1.  
    a)  Adjust `./playground.conf` according to your needs
    b)  Edit the `etc/hosts` file on our host system according to those hostnames and IPs defined in  
        `./playground.conf` and `Vagrantfile`.

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

*NOTE: If you let the host system resolve Chef server's hostname, change the `./chef/knife.rb` 
accordingly, otherwise enable the configuration: `ssl_verify_mode :verify_none`*

4. Bootstrap Nodes

All nodes (windows and linux) are bootstrapped and registered with the server automatically.


## Usage

### Nodes

How may nodes get spawned is totally up to you. Adjust the amount in `playground.conf`. The 
`chef-client` on every node ist not executed automatically on a regular basis (daemonized). That's 
what the `DAEMONIZE_CHEF_CLIENT` flag is for. Though, on Linux nodes you can simply go into the node
and enable the systemd service `chef-client` to activate this desired behaviour. Change the interval
in `/etc/chef/client.rb` and restart the service.


### Virtual Workstation

```bash
vagrant ssh chef-workstation

cd ~/chef-repo

```

### Example(s)




### Policyfile

If you want to utilize `Policyfiles`, and therefore `policy_name` and `policy_group`, you have to
make sure that they are configured accordingly on the node in `/etc/chef/client.rb`. In order to do 
so, please follow: 

1. Connect to the desired machine
```bash
vagrant ssh chef-linux-node-${NUMBER}
```
2. ...and change the chef client configuration
```bash
nano /etc/chef/client.rb
```
