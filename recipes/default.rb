
::Chef::Recipe.send(:include, Opscode::OpenSSL::Password)

node.set_unless['burp']['client_password'] = secure_password

include_recipe 'burp::package'

#Don't let non-root users snoop the SSL key or password
directory "/etc/burp" do
  owner 'root'
  group 'root'
  mode "0750"
end

#Basic client config from template
template "/etc/burp/burp.conf" do
  source "burp.conf.erb"
  owner 'root'
  group 'root'
  mode "0640"
end

#Slightly modify the cron entry
template "/etc/cron.d/burp" do
  source "burp.cron.erb"
  owner 'root'
  group 'root'
  mode "0640"
end

