
template File.join("etc", "mongod.conf") do
  mode 0700
  source "mongo.conf.erb"
  variables(
      :port => node[:mongodb][:config][:port],
      :bind_ip => node[:mongodb][:config][:bindIp],
      :repl_set => node[:mongodb][:config][:replSet],
      :dbpath => node[:mongodb][:config][:dbpath],
  )
  notifies :restart, resources(:service => "mongod")
end