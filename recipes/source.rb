
# No RHEL support for source install,
# need to find a way to get librsync dev reliably

include_recipe 'build-essential'

# http://burp.grke.org/howto.html
%w(
  librsync-dev
  libz-dev
  libssl-dev
  uthash-dev
  autotools-dev
  libncurses5-dev
  libacl1-dev
  libattr1-dev
).each do |p|
  package p
end

workdir = "#{node['burp']['git_cache']}/#{node['burp']['git_ref']}"

# clone github repo
include_recipe 'git'
directory node['burp']['git_cache']
git 'burp_cache' do
  repository node['burp']['git_remote']
  reference node['burp']['git_ref']
  destination workdir
  action :checkout
  notifies :run, 'execute[compile burp]', :immediate
end

# configure
execute 'compile burp' do
  cwd workdir
  # static build (broken) : --enable-static --disable-libtool
  command './configure --disable-ipv6'
  action node['burp']['force_install'] ? :run : :nothing
  notifies :run, 'execute[install burp source]', :immediate
end

# make install
execute 'install burp source' do
  cwd workdir
  command 'make install'
  if node['burp']['force_install']
    action :run
    node.set['burp']['force_install'] = false
    node.save
  else
    action :nothing
  end
end

# install init script
cookbook_file '/etc/init.d/burp' do
  source 'burp.init.sh'
  owner 'root'
  mode 0755
end

# remove testclient
file '/etc/burp/clientconfdir/testclient' do
  action :delete
end
