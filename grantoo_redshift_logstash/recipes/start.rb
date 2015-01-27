#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: stop
#
# Copyright (c) 2015 Fuel, All Rights Reserved.

# starts logstash agent

service "logstash_agent" do
  action :start
end
