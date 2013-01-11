
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
  notifies :reload, "service[cron]"
end

#Create a directory for backup "plug-ins"
["/etc/burp/pre.d", "/etc/burp/post.d"].each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode "0750"
  end
end

#Basic scripts to run the plugins
["pre.sh", "post.sh"].each do |f|
  cookbook_file "/etc/burp/" + f do
    owner 'root'
    group 'root'
    mode 0754
    backup false
    source f
  end
end
