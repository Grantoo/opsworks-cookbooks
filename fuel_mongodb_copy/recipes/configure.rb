
if  !node[:opsworks][:instance].nil? && !node[:opsworks][:instance][:layers].nil? && !node[:mongodb][:layers].nil?
  node[:mongodb][:layers].each do |layer|
    if node[:opsworks][:instance][:layers].include?(layer[:shortname])
      template File.join("etc", "mongod.conf") do
        mode 0744
        source "mongod.conf.erb"
        variables(
            :port => layer[:port],
            :bind_ip => layer[:bindIp],
            :repl_set => layer[:replSet],
            :dbpath => layer[:dbpath],
        )
      end
    end
  end
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