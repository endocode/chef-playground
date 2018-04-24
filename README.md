Chef Playground
=========================


Primary goal here is to create an environment where you can focus on developing our infrastructure
configurations (everything that goes in a `chef-repo`)


__Prerequisites:__

+   Ruby
+   Vagrant

You might also want to install `Chef DK`, which is necessary if you plan to use your host system as
the *workstation* (incl. `knife`).
Additionally, since the root of this repository contains a `.chef/` directory, it is also meant to
be used as your chef-repo, so you probably what to add some more folders like `coockbooks` or 
`data_bags`.


## Stove or microwave???


### Full Environment

Will spin up at least one vm (chef-server), usually more (one linux and one windows) 


### Kitchen

Uses CHef-Zero (in-memory Chef Server) and Vagrant (for the nodes) to apply your configuration


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

*NOTE: linux nodes are bootstrapped and registered with the server automatically, whereas windows 
nodes need a jump start with `knife bootstrap`*


## Usage

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
vagrant ssh chef-node-linux-${NUMBER}
```
2. ...and change the chef client configuration
```bash
nano /etc/chef/client.rb
```