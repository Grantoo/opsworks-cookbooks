#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: default
#
# Copyright (c) 2014 Fuel, All Rights Reserved.

# create the logstash directory for sincedb_path
directory "/mnt/logstash/" do
  owner 'logstash'
  group 'logstash'
  mode '0755'
  action :create
  recursive true
end
