bash "install_mongodb" do
  user 'root'
  code <<-EOH
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
  echo "deb http://repo.mongodb.org/apt/ubuntu trusty/mongodb-org/3.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.2.list
  apt-get update
  apt-get install -y mongodb-org=3.2.11 mongodb-org-server=3.2.11 mongodb-org-shell=3.2.11 mongodb-org-mongos=3.2.11 mongodb-org-tools=3.2.11
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

  chown --recursive mongodb:mongodb /mnt/mongodb/
  EOH
end
