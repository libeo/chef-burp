name             "burp"
maintainer       "Libeo"
maintainer_email "sysadmins@libeo.com"
license          "MIT"
description      "Installs/Configures burp"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.7.0"

supports 'debian'
supports 'ubuntu'
supports 'rhel'

depends "openssl"
