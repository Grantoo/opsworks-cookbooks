package "monit"
include_recipe "deploy"

directory node[:monit][:conf_dir] do
  group "root"
  owner "root"
  action :create
  recursive true
end

service "monit" do
  supports :status => false, :restart => true, :reload => true, :start => true
  action [:enable, :nothing]
end

node[:deploy].each do |application, deploy|
  template File.join(node[:monit][:conf_dir], "grantoo_resque.monitrc") do
    source "grantoo_resque.monitrc.erb"
    mode 0644
    variables(
        :application => application,
        :deploy => deploy
    )
    notifies :restart, resources(:service => "monit")
  end
end
