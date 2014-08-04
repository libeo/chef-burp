name             'burp'
maintainer       'Kevin Lamontagne'
maintainer_email 'kevin@demarque.com'
license          'MIT'
description      'Installs/Configures burp'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.11.5'

supports 'debian', '>= 6.0'
supports 'ubuntu', '>= 12.04'

depends 'openssl'
depends 'build-essential'
depends 'git'
depends 'managed_directory'

recommends 'apt'
