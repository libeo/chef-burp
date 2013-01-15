# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::Config.run do |config|

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "squeeze64"

  # The url from where the 'config.vm.box' box will be fetched if it
  # doesn't already exist on the user's system.
  # config.vm.box_url = "http://domain.com/path/to/above.box"

  # Boot with a GUI so you can see the screen. (Default is headless)
  # config.vm.boot_mode = :gui

  config.vm.provision :shell, :inline => "/usr/bin/apt-get update"

  # Enable provisioning with chef solo, specifying a cookbooks path, roles
  # path, and data_bags path (all relative to this Vagrantfile), and adding 
  # some recipes and/or roles.
  #
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "../../cookbooks"
    chef.roles_path = "../../roles"
    chef.data_bags_path = "/home/klamontagne/chef-repo/data_bags"
    chef.add_recipe "burp::server"
    chef.add_recipe "libeo-mysql"
    chef.json = { :burp => {:server => "localhost"} }
  end

  config.vm.provision :shell, :inline => "chown burp.burp /var/spool/burp ; /etc/init.d/burp start"
  config.vm.provision :shell, :inline => "sudo burp -a l" #Vérifier pour des erreurs?


end
