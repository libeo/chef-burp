default['burp']['server'] = 'backup02.backup.libeo.com'
default['burp']['port'] = 4971
default['burp']['statusport'] = 4972
default['burp']['network_timeout'] = 300
default['burp']['pidfile'] = '/var/run/burp.client.pid'
#Initialized in the recipe
#default['burp']['client_password'] = 'abcdefgh1'

default['burp']['ratelimit'] = 'no'
default['burp']['ratelimit_mbps'] = '5'

default['burp']['excludes'] = []

#Random sleep time for cron job
default['burp']['cron_sleeptime'] = '300'
#Start time for cron job
default['burp']['cron_starttime'] = '7,27,47 * * * *'


default['burp']['max_children'] = 5
default['burp']['max_status_children'] = 5

default['burp']['umask'] = '0027'

default['burp']['ca_server_name'] = 'backup.libeo.com'

#Server-only settings
#default['burp']['server_only'] = {}
default['burp']['server_only']['restore_client'] = [ 'localclient' ]
default['burp']['server_only']['ratelimit_server'] = 'no'
default['burp']['server_only']['ratelimit_server_mbps'] = '5'
default['burp']['server_only']['notify_success_mail'] = 'kevin.lamontagne@libeo.com'
default['burp']['server_only']['notify_failure_mail'] = 'kevin.lamontagne@libeo.com'

