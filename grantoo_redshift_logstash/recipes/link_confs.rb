#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: link_confs
#
# Copyright (c) 2015 Fuel, All Rights Reserved.

# symlink logstash confs to the repository

Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].each do |to_file|
  link "/opt/logstash/agent/etc/conf.d/#{File.basename(to_file)}" do
    to to_file
    owner "logstash"
    group "logstash"
    action :create
  end
end