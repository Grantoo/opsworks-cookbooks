#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: default
#
# Copyright (c) 2014 Fuel, All Rights Reserved.

# create csv directory
directory "/mnt/ebs1/logstash/redshift-csv/" do
  owner 'logstash'
  group 'logstash'
  mode '0755'
  action :create
  recursive true
end

# create unique csv directory (deprecated)
directory "/mnt/ebs1/logstash/redshift-uniq-csv" do
  owner 'ubuntu'
  group 'ubuntu'
  mode '0755'
  action :create
  recursive true
end

# get s3cmd
remote_file "/home/ubuntu/s3cmd-1.5.0-rc1.zip" do
  source "https://github.com/s3tools/s3cmd/archive/v1.5.0-rc1.zip"
  action :create
end

# unzip s3cmd
batch "unzip and move s3cmd" do
  code <<-EOF
    unzip /home/ubuntu/s3cmd-1.5.0-rc1.zip -d /home/ubuntu/
    mv /home/ubuntu/s3cmd-1.5.0-rc1/ /home/ubuntu/s3cmd/
  EOF
end

# setup s3cmd
template "/home/ubuntu/.s3cfg" do
  source ".s3cfg.erb"
  owner 'ubuntu'
  group 'ubuntu'
  mode '0600'
  action :create
end