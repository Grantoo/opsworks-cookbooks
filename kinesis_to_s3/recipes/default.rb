package "monit"

app_root_dir = "/opt/kinesis_to_s3"

directory app_root_dir do
  action :create
end

remote_file File.join(app_root_dir, 'kinesis-to-s3.jar') do
  source "https://github.com/codeflows/kinesis-to-s3/releases/download/0.1/kinesis-to-s3-0.1.jar"
  action :create
end

template File.join(app_root_dir, 'kinesis-to-s3.properties') do
  source 'kinesis-to-s3.properties.erb'
end

template '/etc/init.d/kinesis-to-s3' do
  source 'kinesis-to-s3.init.erb'
  mode 0755
  owner 'deploy'
end

template '/etc/monit/conf.d/kinesis-to-s3.monitrc' do
  source 'kinesis-to-s3.monitrc.erb'
end

service "monit" do
  supports :status => false, :restart => true, :reload => true, :start => true
  action [:enable, :reload, :start]
end