
#Dependency
package "librsync1" do
  action :install
end

#Copy the .deb from recipe files/
cookbook_file "/var/cache/apt/archives/burp_1.3.20-1_amd64.deb" do
  owner 'root'
  group 'root'
  mode 0644
  backup false
  source "burp_1.3.20-1_amd64.deb"
end

#Install .deb directly
package "burp" do
  action :install
  source "/var/cache/apt/archives/burp_1.3.20-1_amd64.deb"
  provider Chef::Provider::Package::Dpkg
end
