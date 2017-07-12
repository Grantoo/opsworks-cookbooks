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

file '/mnt/mongodb/secrets/keyfile' do
  content 'fill'
  owner 'mongodb'
  group 'mongodb'
  mode '0600'
  action :create
end