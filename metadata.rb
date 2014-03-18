name             "burp"
maintainer       "Libeo"
maintainer_email "sysadmins@libeo.com"
license          "All rights reserved"
description      "Installs/Configures burp"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.11.2"

supports 'debian', ">= 6.0"
supports 'ubuntu', ">= 12.04"

depends 'openssl'
depends 'build-essential'
depends 'git'
depends 'managed_directory'

recommends 'apt'
