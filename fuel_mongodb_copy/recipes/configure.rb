
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

template File.join("etc", "mongod.user.conf") do
  mode 0744
  source "mongod.conf.erb"
  variables(
      :port => node[:mongodb][:config][:userPort],
      :bind_ip => node[:mongodb][:config][:bindIp],
      :repl_set => node[:mongodb][:config][:userReplSet],
      :dbpath => node[:mongodb][:config][:dbpath],
  )
end

file '/mnt/mongodb/readme' do
  content <<-EOH
for starting default database, use upstart commands
stop mongod
start mongod

for starting the user database, ensure that the mongod default is not running
stop mongod
and then start it using command line start with background fork
mongod -f /etc/mongo.user.conf --fork
  EOH
  owner 'mongodb'
  group 'mongodb'
  mode '0600'
  action :create_if_missing
end

bash "restart_mongod" do
  user 'root'
  code <<-EOH
  initctl restart mongod
  EOH
end