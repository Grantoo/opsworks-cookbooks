
template File.join("etc", "mongod.conf") do
  mode 0744
  source "mongod.conf.erb"
  variables(
      :port => node[:mongodb][:config][:port],
      :bind_ip => node[:mongodb][:config][:bindIp],
      :repl_set => node[:mongodb][:config][:replSet],
      :dbpath => node[:mongodb][:config][:dbpath],
  )
end

bash "restart_mongod" do
  user 'root'
  code <<-EOH
  initctl restart mongod
  EOH
end