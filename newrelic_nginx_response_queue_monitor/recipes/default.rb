template File.join(node[:nginx][:dir],"sites-enabled","0_newrelic_request_queue.conf") do
  source "newrelic_request_queue.conf.erb"
  owner "root"
  group "root"
  mode 0644
end