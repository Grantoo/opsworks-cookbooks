package "monit"

directory node[:monit][:conf_dir] do
  group "root"
  owner "root"
  action :create
  recursive true
end

include_recipe "grantoo_resque_monit::service"

template File.join(node[:monit][:conf_dir], "grantoo_resque.monitrc") do
  require 'yaml'
  puts node.to_yaml
  source "grantoo_resque.monitrc.erb"
  mode 0644
  #TODO: This should only happen if the service is running, after rebooting
#  notifies :restart, resources(:service => "monit")
end

