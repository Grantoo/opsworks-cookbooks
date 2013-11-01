include_attribute 'deploy'
include_attribute 'opsworks_commons::default'

case node[:platform]
when 'centos','redhat','fedora','suse','amazon'
  default[:monit][:conf]     = '/etc/monit.conf'
  default[:monit][:conf_dir] = '/etc/monit.d'
when 'debian','ubuntu'
  default[:monit][:conf]     = '/etc/monit/monitrc'
  default[:monit][:conf_dir] = '/etc/monit/conf.d'
end
