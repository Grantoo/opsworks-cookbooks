bash "install_mongodb" do
  user 'root'
  code <<-EOH
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
  echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
  apt-get update
  apt-get install -y mongodb-org=2.6.6 mongodb-org-server=2.6.6 mongodb-org-shell=2.6.6 mongodb-org-mongos=2.6.6 mongodb-org-tools=2.6.6
  "mongodb-org hold" | sudo dpkg --set-selections
  "mongodb-org-server hold" | sudo dpkg --set-selections
  "mongodb-org-shell hold" | sudo dpkg --set-selections
  "mongodb-org-mongos hold" | sudo dpkg --set-selections
  "mongodb-org-tools hold" | sudo dpkg --set-selections
  EOH
end

bash "gem_install_aws_sdk" do
  user 'root'
  code <<-EOH
  gem install aws-sdk
  EOH
end

template "/home/ubuntu/create_volume.rb" do
  source "create_volume.rb.erb"
  owner 'ubuntu'
  group 'ubuntu'
  mode '0600'
  action :create
end

bash "create_volume" do
  user 'ubuntu'
  code <<-EOH
  ruby /home/ubuntu/create_volume.rb
  EOH
end

bash "mount_devices" do
  user 'root'
  code <<-EOH
  mkdir -p /mnt/mongodb/default
  mount /dev/xvdm /mnt/mongodb/default/
  
  mkdir -p /mnt/mongodb/users_db_session
  mount /dev/xvdn /mnt/mongodb/users_db_session/

  chown --recursive mongodb:mongodb /mnt/mongodb/default/
  EOH
end

# TODO: Script to modify mongod.conf
# <<-BASH
#   /var/lib/mongodb
#   /etc/mongod.conf

#   dbpath=/mnt/mongodb/default/data/s-ds051207-a0
#   directoryperdb = true

# BASH
