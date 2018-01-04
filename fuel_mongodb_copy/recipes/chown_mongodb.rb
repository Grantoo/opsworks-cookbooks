bash "chown_mongodb" do
  user 'root'
  code <<-EOH
  chown --recursive mongodb:mongodb /mnt/mongodb/
  EOH
end

directory '/mnt/mongodb/data' do
  owner 'mongodb'
  group 'mongodb'
  mode '0755'
  action :create
end

directory '/mnt/mongodb/log' do
  owner 'mongodb'
  group 'mongodb'
  mode '0755'
  action :create
end

directory '/mnt/mongodb/secrets' do
  owner 'mongodb'
  group 'mongodb'
  mode '0755'
  action :create
end

if  !node[:opsworks][:instance].nil? && !node[:opsworks][:instance][:layers].nil? && !node[:mongodb][:layers].nil?
  node[:mongodb][:layers].each do |layer|
    if node[:opsworks][:instance][:layers].include?(layer[:shortname])
      file '/mnt/mongodb/secrets/keyfile' do
        content layer[:key]
        owner 'mongodb'
        group 'mongodb'
        mode '0600'
        action :create_if_missing
      end
    end
  end
end
