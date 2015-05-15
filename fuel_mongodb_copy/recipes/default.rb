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
  code 'gem install aws-sdk'
end

require "aws-sdk"

server_descriptions = {"ds051207" => "default", "ds057781" => "users_db_session"}
latest_snapshots = {"default" => nil, "users_db_session" => nil}
volume_devices = {"default" => "xvdm", "users_db_session" => "xvdn"}

::Aws.config.update({
  :region => 'us-east-1',
  :credentials => ::Aws::Credentials.new(node[:awsAccessKeyId], node[:awsSecretKey])
})

ec2_resource = ::Aws::EC2::Resource.new({:region => 'us-east-1'})
snapshots = ec2_resource.snapshots({:filters => [{ name: 'owner-id', values:['060273974422'] }]})

snapshots.each do |snapshot|
  snapshot_key = nil
  server_descriptions.keys.each do |key|
    if snapshot.description.include?(key)
      snapshot_key = server_descriptions[key]
      break
    end
  end

  if latest_snapshots[snapshot_key] == nil || snapshot.start_time > latest_snapshots[snapshot_key].start_time
    latest_snapshots[snapshot_key] = snapshot
  end
end

availability_zone = 'us-east-1b'
latest_snapshots.each_pair do |key, snapshot|
  snapshot_id = snapshot.id
  ec2_client = ::Aws::EC2::Client.new({:region => 'us-east-1'})
  params = {
    :availability_zone => availability_zone,
    :snapshot_id => snapshot_id,
    :volume_type => 'gp2',
  }
  response = ec2_client.create_volume(params)
  sleep(10)
  
  instance_id = node[:opsworks][:instance][:aws_instance_id]
  volume_id = response.volume_id
  ec2_client = ::Aws::EC2::Client.new({:region => 'us-east-1'})
  params = {
    :volume_id => volume_id,
    :instance_id => instance_id,
    :device => volume_devices[key],
  }
  response = ec2_client.attach_volume(params)
  db_identifier = key
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
