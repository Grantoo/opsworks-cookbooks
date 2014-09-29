package "monit"

remote_file "/opt/kinesis_to_s3/kinesis-to-s3.jar" do
  source "https://github.com/codeflows/kinesis-to-s3/releases/download/0.1/kinesis-to-s3-0.1.jar"
  action :nothing
end

template '/etc/monit/conf.d/kinesis-to-s3.monitrc' do
  source 'kinesis-to-s3.properties.erb'
end

template '/opt/kinesis_to_s3/kinesis-to-s3.jar' do
  source 'kinesis-to-s3.properties.erb'
end

service "monit" do
  supports :status => false, :restart => true, :reload => true, :start => true
  action [:enable, :reload, :start]
end