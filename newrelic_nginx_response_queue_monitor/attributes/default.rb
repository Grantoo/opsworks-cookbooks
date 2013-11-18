default[:nginx][:dir]     = '/etc/nginx'
default[:nginx][:log_dir] = '/var/log/nginx'
default[:nginx][:binary]  = '/usr/sbin/nginx'
case node[:platform]
when 'debian','ubuntu'
  default[:nginx][:user]    = 'www-data'
when 'centos','redhat','fedora','amazon'
  default[:nginx][:user]    = 'nginx'
else
  Chef::Log.error "Cannot configure nginx, platform unknown"
end