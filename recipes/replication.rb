include_recipe 'burp::package'
include_recipe 'burp::default'
include_recipe 'burp::server'

#Don't want beanstalk running on the replica, taking the 11300 port
service "beanstalkd" do
  action :stop 
end

#Make sure that the autossh in this command can be
#launched by the burp user on the replication server.
cookbook_file "/etc/burp/server.rc.local" do
  owner 'root'
  group 'burp'
  mode 0754
  source "server.rc.local"
end

cookbook_file "/etc/burp/do_replication" do
  owner 'root'
  group 'burp'
  mode 0750
  backup false
  source "do_replication"
end

cron "burp_replicate" do
  minute "*/10"
  hour "*"
  day "*"
  month "*"
  weekday "*"
  user "burp"
  command "/etc/burp/do_replication 1>/dev/null 2>/dev/null"
  action :create
end

