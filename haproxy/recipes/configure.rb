service "haproxy" do
  supports :restart => true, :status => true, :reload => true
  action :nothing # only define so that it can be restarted if the config changed
end

require 'json'
Chef::Log.error(node.to_json)


# go through these
# node:opsworks:layersLAYER_NAME:instances
# fill in these
#node[:haproxy][:goapp_applications]
# "goapp": {
#           "domains": [
#             "a.example.com",
#             "b.example.com"
#           ],
#           "application_type": "goapp",
#           "mounted_at": null
#         }
# node[:haproxy][:goapp_backends]
# {
#     "ip": "10.123.141.159",
#     "name": "lychee",
#     "backends": 16
# }

node[:opsworks][:layers][:goappserver][:instances].each do |server_name, details|
  node.normal[:haproxy][:goapp_backends] << { :name => server_name, :ip => details[:ip], :backends => 16 }
end

template "/etc/haproxy/haproxy.cfg" do
  cookbook "haproxy"
  source "haproxy.cfg.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :reload, "service[haproxy]"
end

execute "echo 'checking if HAProxy is not running - if so start it'" do
  not_if "pgrep haproxy"
  notifies :start, "service[haproxy]"
end

