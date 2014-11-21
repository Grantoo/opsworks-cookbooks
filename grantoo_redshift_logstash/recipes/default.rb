#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: default
#
# Copyright (c) 2014 Fuel, All Rights Reserved.

directory "/mnt/ebs1/logstash/redshift-csv/" do
  owner 'logstash'
  group 'logstash'
  mode '0644'
  action :create
  recursive true
end

directory "/mnt/ebs1/logstash/redshift-uniq-csv" do
  owner 'logstash'
  group 'logstash'
  mode '0644'
  action :create
  recursive true
end