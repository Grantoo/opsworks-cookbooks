#ensure that the these directories are emptied before used
%w{conf.d}.each do |dir|
  Dir.glob(File.join(node[:nginx][:dir], dir, "*.conf")).each do |f|
    File.delete(f)
  end
end

service "nginx" do
  action :restart
end