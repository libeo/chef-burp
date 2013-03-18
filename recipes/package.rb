
#Dependency
["librsync1", "libssl0.9.8"].each do |p|
  package p do
    action :install
    not_if { node['burp']['install_package?'] != 'true' }
  end
end

#Copy the .deb from recipe files/
cookbook_file "/var/cache/apt/archives/burp_1.3.20-1_amd64.deb" do
  owner 'root'
  group 'root'
  mode 0644
  backup false
  source "burp_1.3.20-1_amd64.deb"
  not_if { node['burp']['install_package?'] != 'true' } #Install by hand?
  only_if { node['kernel']['machine'] == 'x86_64' }
end

#Install .deb directly
package "burp" do
  action :install
  source "/var/cache/apt/archives/burp_1.3.20-1_amd64.deb"
  provider Chef::Provider::Package::Dpkg
  not_if { node['burp']['install_package?'] != 'true' } #Install by hand?
  only_if { node['kernel']['machine'] == 'x86_64' }
end
