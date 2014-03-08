default['burp']['install_method'] = "source"
default['burp']['git_cache'] = "/var/cache/burp"
default['burp']['git_remote'] = "https://github.com/grke/burp.git"
default['burp']['git_ref'] = "c287305801d567981b4c0f22f2805a81c01f5dfd" # 1.4.10 2013-12-01
default['burp']['force_install'] = false # Set to true to force a one-time reinstall

default['burp']['dependencies'] = %w{ librsync-dev libz-dev libssl-dev uthash-dev autotools-dev libncurses5-dev libacl1-dev libattr1-dev }
# RHEL not supported

default['burp']['server'] = 'backup02.backup.libeo.com'
default['burp']['port'] = 4971
default['burp']['statusport'] = 4972
default['burp']['network_timeout'] = 3600
default['burp']['pidfile'] = '/var/run/burp.client.pid'
#Initialized in the recipe
#default['burp']['client_password'] = 'abcdefgh1'

default['burp']['ratelimit'] = 'no'
default['burp']['ratelimit_mbps'] = '5'

default['burp']['excludes'] = []
default['burp']['excludesregex'] = []
default['burp']['includesglob'] = []

# Set this value to use other hostname than FQDN
#default['burp']['cname'] = 'other'


#Random sleep time for cron job
default['burp']['cron_sleeptime'] = '300'
#Start time for cron job
default['burp']['cron_starttime'] = '7,27,47 * * * *'
#Hours for server backup
#Use array containing ex.:
#"Mon,Tue,Wed,Thu,Fri,00,01,02,03,04,05,06,07,08,17,18,19,20,21,22,23",
#"Sat,Sun,00,01,02,03,04,05,06,07,08,17,18,19,20,21,22,23"
default['burp']['timer_args'] = nil

default['burp']['max_children'] = 5
default['burp']['max_status_children'] = 5

default['burp']['umask'] = '0027'

default['burp']['ca_server_name'] = 'backup.libeo.com'

#e-mail settings
default['burp']['email_all_from'] = '"=?ISO-8859-1?Q?Sauvegarde=20Lib=E9o?=" <backupmaster@libeo.com>'
#A string is enough for a single recipient.
default['burp']['email_all_to'] = ''
default['burp']['email_failure_from'] = '"=?ISO-8859-1?Q?Sauvegarde=20Lib=E9o?=" <backupmaster@libeo.com>'
default['burp']['email_failure_to'] = ''

