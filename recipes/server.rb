
#TODO
#Make sure that "localclient" connects to create certificate

include_recipe 'burp::package'

#Create system user
user "burp" do
  comment "BURP"
  system true
  shell "/bin/false"
end

#Secure configuration.
directory "/etc/burp" do
  owner 'burp'
  group 'root'
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

#Default linux excludes
cookbook_file "/etc/burp/clientconfdir/incexc/linux_excludes" do
  owner 'root'
  group 'root'
  mode 0644
  source "linux_excludes"
end

#Create client files for all new BURP clients in Chef (node.burp.server is defined)
search(:node, "burp_server:#{node.fqdn}") do |n|
    if n['os'] == 'linux'
      #Create a default linux config
      template "/etc/burp/clientconfdir/#{n.fqdn}" do
        :create_if_missing #Important, sinon risque d'impersonation par un autre client!
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


