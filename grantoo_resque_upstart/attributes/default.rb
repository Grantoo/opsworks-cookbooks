include_attribute 'rails::rails'

node.set[:upstart] = {:conf_dir => '/etc/init'}

default[:resque][:queues] = "*" unless node[:resque][:queues]