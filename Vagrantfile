# -*- mode: ruby -*-
# vi: set ft=ruby :

# Node definition
nodes = [
  # vip = 172.16.10.10
  {
    :hostname => 'lb-01',
    :cpus     => 1,
    :memory   => 256,
    :box      => 'centos/7',
    :forwarded_ports => [],
    :synced_folders => [],
    :networks => [
      {
        :ip => '172.16.10.11',
        :auto_config => true,
      },
    ],
  },
  {
    :hostname => 'lb-02',
    :cpus     => 1,
    :memory   => 256,
    :box      => 'centos/7',
    :forwarded_ports => [],
    :synced_folders => [],
    :networks => [
      {
        :ip => '172.16.10.12',
        :auto_config => true,
      },
    ],
  },
  {
    :hostname => 'web-01',
    :cpus     => 1,
    :memory   => 256,
    :box      => 'centos/7',
    :forwarded_ports => [],
    :synced_folders => [],
    :networks => [
      {
        :ip => '172.16.10.21',
        :auto_config => true,
      },
    ],
  },
  {
    :hostname => 'web-02',
    :cpus     => 1,
    :memory   => 256,
    :box      => 'centos/7',
    :forwarded_ports => [],
    :synced_folders => [],
    :networks => [
      {
        :ip => '172.16.10.22',
        :auto_config => true,
      },
    ],
  },
]

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
      node_config.vm.hostname = node[:hostname]
      node_config.vm.box = node[:box]

      node_config.ssh.forward_x11 = true

      node[:forwarded_ports].each do |forwarded_port|
        node_config.vm.network "forwarded_port", guest: forwarded_port[:guest], host: forwarded_port[:host]
      end

      node[:synced_folders].each do |synced_folder|
        node_config.vm.synced_folder synced_folder[:host], synced_folder[:guest]
      end

      node[:networks].each do |network|
        if network[:ip]
          node_config.vm.network "private_network", ip: network[:ip], auto_config: network[:auto_config]
        end

        if network[:type]
          node_config.vm.network "private_network", type: network[:type], auto_config: network[:auto_config]
        end

        if network[:promiscuous]
          node_config.vm.provider "virtualbox" do |v|
            v.customize [
              "modifyvm", :id,
              "--nicpromisc#{network[:nic]}", network[:promiscuous]
            ]
          end
        end
      end

      node_config.vm.provider "virtualbox" do |v|
        v.name = node[:hostname]
        v.cpus = node[:cpus]
        v.memory = node[:memory]
      end

      node_config.vm.provision :shell, :path => node[:hostname] + ".sh"

    end
  end
end
