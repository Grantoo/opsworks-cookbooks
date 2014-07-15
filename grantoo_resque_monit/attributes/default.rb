include_attribute 'rails::rails'

case node[:platform]
  when 'centos', 'redhat', 'fedora', 'suse', 'amazon'
    default[:monit][:conf] = '/etc/monit.conf'
    default[:monit][:conf_dir] = '/etc/monit.d'
    default[:monit][:user_group] = node['opsworks']['rails_stack']['name'] == 'nginx_unicorn' ? 'nginx' : 'apache'
  when 'debian', 'ubuntu'
    default[:monit][:conf] = '/etc/monit/monitrc'
    default[:monit][:conf_dir] = '/etc/monit/conf.d'
    default[:monit][:user_group] = 'www-data'
end

default[:resque][:queues] = "*" unless node[:resque][:queues]
