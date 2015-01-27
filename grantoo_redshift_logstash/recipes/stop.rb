#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: stop
#
# Copyright (c) 2015 Fuel, All Rights Reserved.

# stops logstash agent

service "logstash_agent" do
  action :stop
end
