include_attribute 'deploy::deploy'
include_attribute 'opsworks_commons::default'

#default[:deploy] = {}
#node[:deploy].each do |application, deploy|
#  default[:deploy][application][:deploy_to] = "/srv/www/#{application}"
#end

case node[:platform]
when 'centos','redhat','fedora','suse','amazon'
  default[:monit][:conf]     = '/etc/monit.conf'
  default[:monit][:conf_dir] = '/etc/monit.d'
when 'debian','ubuntu'
  default[:monit][:conf]     = '/etc/monit/monitrc'
  default[:monit][:conf_dir] = '/etc/monit/conf.d'
end
