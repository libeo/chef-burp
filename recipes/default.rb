
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

node.set_unless['burp']['client_password'] = secure_password

include_recipe "burp::#{node['burp']['install_method']}"

# Don't let non-root users snoop the SSL key or password
unless node.recipe?('burp::server')
  directory '/etc/burp' do
    owner 'root'
    group 'root'
    mode 0750
  end
end

# Basic client config from template
template '/etc/burp/burp.conf' do
  source 'burp.conf.erb'
  owner 'root'
  group 'root'
  mode 0640
  variables(
    # hostname custom?
    cname: (node['burp']['cname'] || node['fqdn']),
    excludes: node['burp']['excludes'],
    excludesregex: node['burp']['excludesregex'],
    includesglob: node['burp']['includesglob'],
    includes: node['burp']['includes']
  )
end

# TODO: replace with a 'cron' block
# Don't want to manage cron (yet), just reload it...
# first, set service path according to platform
service_path = { 'debian' => '/usr/sbin/service',
               'ubuntu' => '/usr/sbin/service',
               'redhat' => '/sbin/service'
                                 }[ node['platform'] ]
service_name = { 'debian' => 'cron',
               'ubuntu' => 'cron',
               'redhat' => 'crond'
                                 }[ node['platform'] ]
execute "reload_cron" do
  action :nothing #do nothing, unless receiving a notification
  command "#{service_path} #{service_name} reload"
  only_if "#{service_path} #{service_name} status"
end
# Slightly modify the cron entry
template "/etc/cron.d/burp" do
  source "burp.cron.erb"
  owner 'root'
  group 'root'
  mode "0640"
  notifies :run, "execute[reload_cron]"
end

# Create a directory for backup "plug-ins"
['/etc/burp/pre.d', '/etc/burp/post.d'].each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode 0750
  end
end

# Basic scripts to run the plugins
['pre.sh', 'post.sh'].each do |f|
  template '/etc/burp/' + f do
    owner 'root'
    group 'root'
    mode 0754
    backup false
    source f
  end
end

# TODO: Create a burp_plugin LWRP
# Script to backup package list via debconf for debian
if platform?('debian') || platform?('ubuntu')

  cookbook_file '/etc/burp/pre.d/debconf-sh' do
    action :create
    backup false
    owner 'root'
    group 'root'
    mode 0754
    source 'debconf-backup.sh'
  end

  package 'debconf-utils' do
    action :install
  end
end
