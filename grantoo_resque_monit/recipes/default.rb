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

# example settings: {"resque":{"queues": "*", "layers": [{"name": "railsworkerspriority", "queues": "my_special_queue"}]}}
queues = node[:resque][:queues]
if  !node[:opsworks][:instance].nil? && !node[:opsworks][:instance][:layers].nil? && !node[:resque][:layers].nil?
  # scan for matching layer
  node[:resque][:layers].each do |layer|
    if node[:opsworks][:instance][:layers].include?(layer[:name])
      queues = layer[:queues]
    end
  end
end

node[:deploy].each do |application, deploy|
  Dir.glob(File.join(node[:monit][:conf_dir], "grantoo_resque*.monitrc")).each do |f|
    File.delete(f)
  end

  (1..cpu_count).each do | cpu_number |
    Chef::Log.info("cpu_number #{cpu_number.to_s}")
    template File.join(node[:monit][:conf_dir], "grantoo_resque_#{cpu_number.to_s}.monitrc") do
      mode 0700
      source "grantoo_resque.monitrc.erb"
      variables(
          :application => application,
          :deploy => deploy,
          :group => group,
          :worker => cpu_number.to_s,
          :queues => queues
      )
      notifies :restart, resources(:service => "monit"), :delayed
    end

    bash "stop resque workers" do
      user "root"
      cwd "/tmp"
      code <<-EOH
      pkill -QUIT -f resque
      rm -f '<%= @deploy[:deploy_to] %>/shared/pids/grantoo_resque_<%= @worker %>.pid'
      true
      EOH
    end
  end
end

bash "start monit resque workers" do
  user "root"
  cwd "/tmp"
  code <<-EOH
  monit validate
  true
  EOH
end