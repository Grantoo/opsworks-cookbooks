#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: stop
#
# Copyright (c) 2015 Fuel, All Rights Reserved.

# starts logstash agent

bash "unzip and move s3cmd" do
  code <<-EOL
    service logstash_agent start
  EOL
end