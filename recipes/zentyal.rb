
include_recipe 'burp::default'

# TODO: move to LWRP
cookbook_file '/etc/burp/pre.d/zentyal' do
  source 'zentyal.sh'
  owner 'root'
  mode 0700
end
