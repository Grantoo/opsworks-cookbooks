bash "install_mongodb" do
  user 'root'
  code <<-EOH
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
  echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
  apt-get update
  apt-get install -y --force-yes mongodb-org=3.2.11 mongodb-org-server=3.2.11 mongodb-org-shell=3.2.11 mongodb-org-mongos=3.2.11 mongodb-org-tools=3.2.11
  "mongodb-org hold" | sudo dpkg --set-selections
  "mongodb-org-server hold" | sudo dpkg --set-selections
  "mongodb-org-shell hold" | sudo dpkg --set-selections
  "mongodb-org-mongos hold" | sudo dpkg --set-selections
  "mongodb-org-tools hold" | sudo dpkg --set-selections
  EOH
end

template File.join("etc", "mongod.conf") do
  mode 0700
  source "mongo.conf.erb"
  variables(
      :port => node[:mongodb][:config][:port],
      :bind_ip => node[:mongodb][:config][:bindIp],
      :repl_set => node[:mongodb][:config][:replSet],
      :dbpath => node[:mongodb][:config][:dbpath],
  )
  notifies :restart, resources(:service => "mongod"), :immediately
end