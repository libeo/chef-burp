
include_recipe 'burp::default'

#Create system user
user "burp" do
  comment "BURP"
  system true
  shell "/bin/bash"
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
  # TODO don't overwrite if there are other restore clients? would that even make sense?
  node.set['burp']['server_only']['restore_client'] = [ node['fqdn'] ]
  node.save
end


#Server configuration
template "/etc/burp/burp-server.conf" do
  source "burp-server.conf.erb"
  owner 'root'
  group 'burp'
  mode "0640"
  variables( :client_can_force_backup => node['burp']['server_only']['client_can_force_backup'])
end
template "/etc/default/burp" do
  source "burp.default.erb"
  owner 'root'
  group 'root'
  mode "0644"
end

#Default linux excludes
directory "/etc/burp/clientconfdir/incexc" do
  owner 'root'
  group 'burp'
  mode "0655"
end
cookbook_file "/etc/burp/clientconfdir/incexc/linux_excludes" do
  owner 'root'
  group 'root'
  mode "0644"
  source "linux_excludes"
end

if Chef::Config[:solo]
  #Chef Solo, used for testing, I only backup myself
  backup_nodes = [node]
else
  #Real server, Chef search is available
  #Search for all BURP clients in Chef (their attribute node.burp.server == me)
  query = "burp_server:#{node.fqdn}"
  if (node['burp']['server_only']['restrict_to_same_environment'])
    query += " AND chef_environment:#{node.environment}"
  end
  backup_nodes = search(:node, query)
end

#Create client files
backup_nodes.each do |n|
  cname = (n['burp']['cname'] or n['fqdn']) #default name is FQDN
  if n['os'] == 'linux'
    #Create a default linux config

    template "/etc/burp/clientconfdir/#{cname}" do
      :create_if_missing #Never overwrite, or other backup clients could be impersonated!
      source "burp-clientconfdir-linux.erb"
      owner 'root'
      group 'burp'
      mode "0640"
      variables(
        :client_password => n['burp']['client_password'],
        :cname => cname,
        :excludes => n['burp']['excludes'],
        :excludesregex => (n['burp']['excludesregex'] or []),
        :email_all_from => (n['burp']['email_all_from'] or ""),
        :email_all_to => (n['burp']['email_all_to'] or ""),
        :email_failure_from => (n['burp']['email_failure_from'] or ""),
        :email_failure_to => (n['burp']['email_failure_to'] or ""),
        :timer_args => n['burp']['timer_args'],
	:restore_clients => (n['burp']['restore_clients'] or [])
      )
    end
  end
end

# Remove unmanaged files ?
include_recipe 'managed_directory'
managed_directory "/etc/burp/clientconfdir" do
  action :clean
  only_if { node['burp']['server_only']['auto_remove_clients'] }
end

# Enable server
service "burp" do
  action [ :enable, :start ]
end


