#! /bin/bash

set -e
set -u

mkdir -p /var/backups/debconf-package-list
/usr/bin/debconf-get-selections | gzip > /var/backups/debconf-package-list/list.gz

