
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
  node.set['burp']['server_only']['restore_client'] = node['fqdn']
  node.save
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
  backup_nodes = search(:node, "burp_server:#{node.fqdn}")
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

#Make sure that the local client connects to create certificate
#execute "burp_initial_connect" do
#  command "/etc/init.d/burp start; sleep 3; /usr/sbin/burp -a l" # Command without any effect, to initiate signing
#  not_if { ::File.exists? "/etc/burp/ssl_cert-client.key" } # Started a signig request
#end

#Beanstalkd configuration for replication queue
#Dependencies
[ "beanstalkd", "php5-cli"].each do |p|
  package p do
    action :install
  end
end

#Restart on config change
execute "beanstalkd-restart" do
  command "/etc/init.d/beanstalkd restart"
  action :nothing
end

#Beanstalk config (localhost)
template "/etc/default/beanstalkd" do #run-parts filename restrictions
  source "beanstalkd.default.erb"
  owner 'root'
  group 'root'
  mode "0660"
  notifies :run, "execute[beanstalkd-restart]"
end

#Tools for queueing job (PHP)
git "burp-bstools" do
  repository "https://git.libeo.com/sysadmin-cookbooks/burp-bstools.git"
  destination "/etc/burp/bstools"
  revision "master"
  user "root"
  action :sync
  enable_submodules false
end

cookbook_file "/etc/burp/queue_replication" do
  owner 'root'
  group 'burp'
  mode 0750
  backup false
  source "queue_replication"
end

