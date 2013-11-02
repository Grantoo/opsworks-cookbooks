package "monit"
include_recipe "deploy"

directory node[:monit][:conf_dir] do
  group "root"
  owner "root"
  action :create
  recursive true
end

include_recipe "grantoo_resque_monit::service"

node[:deploy].each do |application, deploy|
  template File.join(node[:monit][:conf_dir], "grantoo_resque.monitrc") do
    source "grantoo_resque.monitrc.erb"
    mode 0644
    variables(
        :application => application,
        :deploy => deploy
    )
    #TODO: This should only happen if the service is running, after rebooting
    #notifies :restart, resources(:service => "monit")
  end
end
