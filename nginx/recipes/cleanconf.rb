#ensure that the these directories are emptied before used
Dir.glob(File.join(node[:nginx][:dir], 'conf.d', "*.conf")).each do |f|
  File.delete(f)
end

include_recipe "nginx::service"

service "nginx" do
  action :restart
end