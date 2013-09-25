#Server-only settings
default['burp']['server_only']['client_can_force_backup'] = false
default['burp']['server_only']['restrict_to_same_environment'] = false
default['burp']['server_only']['hardlinked_archive'] = true
default['burp']['server_only']['pidfile'] = "/var/lock/burp-server.pid" # server not running as root... can't write to /var/run !
default['burp']['server_only']['restore_client'] = []
default['burp']['server_only']['ratelimit_server'] = 'no'
default['burp']['server_only']['ratelimit_server_mbps'] = '5'
default['burp']['server_only']['notify_success_mail'] = 'kevin.lamontagne@libeo.com'
default['burp']['server_only']['notify_failure_mail'] = 'kevin.lamontagne@libeo.com'

# Auto remove clients: enable only if a client disappearence can be detected by reporting!
default['burp']['server_only']['auto_remove_clients'] = false


