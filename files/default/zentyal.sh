#! /bin/bash

if [ "$(date +%u)" = "1" ]
then
  /usr/bin/perl -w /usr/share/zentyal/make-backup --description "$(date +%F)" --config-backup --progress-id 1
  find /var/lib/zentyal/conf/backups/ -mindepth 1 -maxdepth 1 -type f -name '*.tar' -mtime +90 -delete
fi
