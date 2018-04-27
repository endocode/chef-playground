# -*- mode: ruby -*-
# vi: set ft=ruby :

DIR = File.dirname(__FILE__)


PROVISION_ROOT_PATH = "#{DIR}/provision"
REMOTE_SOURCE_PATH_LINUX = "/tmp/provision"
REMOTE_SOURCE_PATH_WIN = "C:\\tmp\\provision"
MOUNT_PATH_LINUX = "/mnt/host"
MOUNT_PATH_WIN = "C:\\host"
COMMON_PROVISION_SCRIPTS_LINUX = [ "common-dependencies_centos.sh" ]
COMMON_PROVISION_SCRIPTS_WIN = [ "common-dependencies_win.bat" ]


load "#{DIR}/playground.conf"


CHEF_SERVER_IP = "#{NETWORK_SLASH24_PREFIX}.11"
CHEF_WORKSTATION_IP = "#{NETWORK_SLASH24_PREFIX}.22"



Vagrant.configure("2") do |config|

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :machine
  end


  config.vm.define CHEF_SERVER_NAME do |node|

    instance_ip = CHEF_SERVER_IP
    hostname = CHEF_SERVER_NAME

    provision_scripts = Array.new(COMMON_PROVISION_SCRIPTS_LINUX).push(
      "bootstrap_chef-server_centos.sh #{MOUNT_PATH_LINUX}"
    )

    node.vm.box = "centos/7"

    node.vm.provider "virtualbox" do |vb|
      vb.name = hostname
      vb.memory = 2048
      vb.cpus = 2
    end

    node.vm.hostname = hostname
    node.vm.network "private_network", ip: instance_ip, :adapter => 2

    node.vm.synced_folder "#{DIR}", "/vagrant", disabled: true
    node.vm.synced_folder PROVISION_ROOT_PATH, MOUNT_PATH_LINUX, type: "virtualbox"

    provision_scripts.each do |script|
      filename = script.split(' ').first
      node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/shell/#{filename}", destination: "#{REMOTE_SOURCE_PATH_LINUX}/#{filename}"
    end
    node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/../playground.conf", destination: "#{REMOTE_SOURCE_PATH_LINUX}/conf.env"
    node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/assets/chef/chef-server.rb", destination: "#{REMOTE_SOURCE_PATH_LINUX}/chef-server.rb"

    provision_scripts.each do |script|
      node.vm.provision "shell",
                        inline: "#{REMOTE_SOURCE_PATH_LINUX}/#{script}",
                        privileged: true
    end

  end



  if CREATE_WORKSTATION
    config.vm.define "chef-workstation" do |node|

      instance_ip = CHEF_WORKSTATION_IP
      hostname = "workstation"

      provision_scripts = Array.new(COMMON_PROVISION_SCRIPTS_LINUX).push(
        "bootstrap_chef-workstation_centos.sh #{CHEF_SERVER_IP}"
      )

      node.vm.box = "centos/7"

      node.vm.provider "virtualbox" do |vb|
        vb.name = hostname
        vb.memory = 1024
        vb.cpus = 1
      end

      node.vm.hostname = hostname
      node.vm.network "private_network", ip: instance_ip, :adapter => 2

      node.vm.synced_folder "#{DIR}", "/vagrant", disabled: true
      node.vm.synced_folder PROVISION_ROOT_PATH, MOUNT_PATH_LINUX, type: "virtualbox"
      node.vm.synced_folder "#{DIR}", "/home/vagrant/chef-repo", type: "virtualbox", owner: 'vagrant'

      provision_scripts.each do |script|
        filename = script.split(' ').first
        node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/shell/#{filename}", destination: "#{REMOTE_SOURCE_PATH_LINUX}/#{filename}"
      end
      node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/../playground.conf", destination: "#{REMOTE_SOURCE_PATH_LINUX}/conf.env"

      provision_scripts.each do |script|
        node.vm.provision "shell",
                          inline: "#{REMOTE_SOURCE_PATH_LINUX}/#{script}",
                          privileged: true
      end

    end
  end



  (1..LINUX_NODES).each do |i|

    config.vm.define "chef-linux-node-#{ i }" do |node|
      ipSuffix = 100 + i
      instance_ip = "#{NETWORK_SLASH24_PREFIX}.#{ipSuffix}"
      hostname = "linux-node-#{ i }"

      provision_scripts = Array.new(COMMON_PROVISION_SCRIPTS_LINUX).push(
        "bootstrap_chef-node_centos.sh #{MOUNT_PATH_LINUX} #{CHEF_SERVER_IP}"
      )

      node.vm.box = "centos/7"

      node.vm.provider "virtualbox" do |vb|
        vb.name = hostname
        vb.memory = 512
        vb.cpus = 1
      end

      node.vm.hostname = hostname
      node.vm.network "private_network", ip: instance_ip, :adapter => 2

      node.vm.synced_folder "#{DIR}", "/vagrant", disabled: true
      node.vm.synced_folder PROVISION_ROOT_PATH, MOUNT_PATH_LINUX, type: "virtualbox"

      provision_scripts.each do |script|
        filename = script.split(' ').first
        node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/shell/#{filename}", destination: "#{REMOTE_SOURCE_PATH_LINUX}/#{filename}"
      end
      node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/../playground.conf", destination: "#{REMOTE_SOURCE_PATH_LINUX}/conf.env"
      node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/assets/linux/chef-client.unit", destination: "#{REMOTE_SOURCE_PATH_LINUX}/chef-client.unit"
      node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/assets/chef/client_linux.rb", destination: "#{REMOTE_SOURCE_PATH_LINUX}/client.rb"

      provision_scripts.each do |script|
        node.vm.provision "shell",
                          inline: "#{REMOTE_SOURCE_PATH_LINUX}/#{script}",
                          privileged: true
      end
    end

  end



  (1..WINDOWS_NODES).each do |i|
    config.vm.define "chef-windows-node-#{i}".to_sym do |node|

      ipSuffix = 200 + i
      instance_ip = "#{NETWORK_SLASH24_PREFIX}.#{ipSuffix}"
      hostname = "windows-node-#{ i }"

      provision_scripts = Array.new(COMMON_PROVISION_SCRIPTS_WIN).push(
        "install-chef-user_win.ps1",
        "bootstrap_chef-node_win.bat"
      )
      asset_files = [
        "assets/win/secconfig.cfg"
      ]

      node.vm.box = "opentable/win-2012r2-standard-amd64-nocm"

      node.vm.provider "virtualbox" do |vb|
        vb.name = hostname
        vb.memory = '2048'
        vb.customize [ 'modifyvm', :id, '--memory', '2048' ]
        vb.customize [ 'modifyvm', :id, '--vram', '16' ]
        vb.cpus = 1
        vb.gui = false
      end

      node.vm.hostname = hostname
      node.vm.network "private_network", ip: instance_ip, :adapter => 2
      node.vm.network "forwarded_port", guest: 3389, host: 3389
      node.windows.set_work_network = true

      node.vm.synced_folder "#{DIR}", "/vagrant", disabled: true
      node.vm.synced_folder PROVISION_ROOT_PATH, MOUNT_PATH_WIN, type: "virtualbox"

      asset_files.each do |relFilePath|
        filename = File.basename(relFilePath)
        node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/#{relFilePath}", destination: "#{REMOTE_SOURCE_PATH_WIN}/#{filename}"
      end
      node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/../playground.conf", destination: "#{REMOTE_SOURCE_PATH_WIN}/conf.env"
      node.vm.provision "file", source: "#{PROVISION_ROOT_PATH}/assets/chef/client_win.rb", destination: "#{REMOTE_SOURCE_PATH_WIN}/client.rb"
      node.vm.provision "shell",
                        privileged: true,
                        inline: "Add-Content #{REMOTE_SOURCE_PATH_WIN}\\client.rb \"`nnode_name               '#{hostname}'\""

      # convert conf.env to work with windows
      node.vm.provision "shell",
                        path: "#{PROVISION_ROOT_PATH}/shell/convert-configuration-file_win.ps1",
                        privileged: true,
                        args: [
                          "#{REMOTE_SOURCE_PATH_WIN}\\conf.env"
                        ]

      # # NOTE: install chocolatey
      node.vm.provision "shell",
                        privileged: true,
                        inline: "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))"

      provision_scripts.each do |script|
        node.vm.provision "shell",
                          path: "#{PROVISION_ROOT_PATH}/shell/#{script}",
                          privileged: true,
                          args: [
                            REMOTE_SOURCE_PATH_WIN,
                            MOUNT_PATH_WIN,
                            CHEF_SERVER_IP
                          ]
      end

    end
  end

end
