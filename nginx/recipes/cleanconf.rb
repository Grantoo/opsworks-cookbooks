directory = File.join(node[:nginx][:dir], 'conf.d', "*.conf")
Chef::Log.info "Ensuring that the nginx #{directory} is emptied before use"

Dir.glob(directory).each do |f|
  Chef::Log.info "removing #{f.to_s}"
  File.delete(f)
end

include_recipe "nginx::service"

service "nginx" do
  action :restart
end