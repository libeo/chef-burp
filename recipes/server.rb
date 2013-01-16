
include_recipe 'burp::package'
include_recipe 'burp::default'

#Create system user
user "burp" do
  comment "BURP"
  system true
  shell "/bin/false"
end

#Secure configuration (not the same as client)
directory "/etc/burp" do
  owner 'burp'
  group 'root'
  mode "0770"
end

#Burp doesn't need to change these
directory "/etc/burp/clientconfdir" do
  owner 'root'
  group 'burp'
  mode "0750"
end

#Create directory for pid files
directory "/var/run/burp" do
  owner "burp"
  group "root"
  mode 00770
  action :create
end

#Set myself as a restore client
if not node['burp']['server_only']['restore_client'].include? node['fqdn']
  node['burp']['server_only']['restore_client'] << node['fqdn']
end


#Server configuration
template "/etc/burp/burp-server.conf" do
  source "burp-server.conf.erb"
  owner 'root'
  group 'burp'
  mode "0640"
end
template "/etc/default/burp" do
  source "burp.default.erb"
  owner 'root'
  group 'root'
  mode "0644"
end

#Default linux excludes
cookbook_file "/etc/burp/clientconfdir/incexc/linux_excludes" do
  owner 'root'
  group 'root'
  mode 0644
  source "linux_excludes"
end

if Chef::Config[:solo]
  #Chef Solo, used for testing, I only backup myself
  backup_nodes = [node]
else
  #Real server, Chef search is available
  #Search for all BURP clients in Chef (their attribute node.burp.server == me)
  backup_nodes = search(:node, "burp_server:#{node.fqdn}")
end

#Create client files
backup_nodes.each do |n|
  if n['os'] == 'linux'
    #Create a default linux config
    template "/etc/burp/clientconfdir/#{n.fqdn}" do
      :create_if_missing #Never overwrite, or other backup clients could be impersonated!
      source "burp-clientconfdir-linux.erb"
      owner 'root'
      group 'burp'
      mode "0640"
      variables(
        :client_password => n['burp']['client_password'],
        :fqdn => n['fqdn']
      )
    end
  end
end

#TODO
#Make sure that "localclient" connects to create certificate

