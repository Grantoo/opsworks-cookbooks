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

group = node[:monit][:user_group]
cpu_count = `cat /proc/cpuinfo | grep processor | wc -l`.to_i # assume linux

node[:deploy].each do |application, deploy|
  Dir.glob(File.join(node[:monit][:conf_dir], "grantoo_resque*.monitrc")).each do |f|
    File.delete(f)
  end

  (1..cpu_count).each do | cpu_number |
    Chef::Log.info("cpu_number #{cpu_number.to_s}")
    template File.join(node[:monit][:conf_dir], "grantoo_resque_#{cpu_number.to_s}.monitrc") do
      source "grantoo_resque.monitrc.erb"
      variables(
          :application => application,
          :deploy => deploy,
          :group => group,
          :worker => cpu_number.to_s
      )
      notifies :restart, resources(:service => "monit"), :delayed
    end
  end

end
