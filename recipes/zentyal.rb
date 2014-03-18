
include_recipe 'burp::default'

cookbook_file "/etc/burp/pre.d/zentyal" do
  source "zentyal.sh"
  owner 'root'
  mode 0700
end
