package "monit"
#include_recipe "deploy"

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

group = node[:monit][:user_group]

node[:deploy].each do |application, deploy|
  Dir.glob(File.join(node[:monit][:conf_dir], "grantoo_resque_scheduler.monitrc")).each do |f|
    File.delete(f)
  end

  template File.join(node[:monit][:conf_dir], "grantoo_resque_scheduler.monitrc") do
    source "grantoo_resque.monitrc.erb"
    mode 0644
    variables(
        :application => application,
        :deploy => deploy,
        :group => group,
        :worker => cpu_number.to_s
    )
    notifies :restart, resources(:service => "monit"), :delayed
  end

end
