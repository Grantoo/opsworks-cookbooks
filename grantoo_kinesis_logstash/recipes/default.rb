#
# Cookbook Name:: grantoo_kinesis_logstash
# Recipe:: default
#
# Copyright (C) 2014 Fuel Powered
#
# All rights reserved - Do Not Redistribute
#
# / end of enterprisy boiler plate...
#
#
# This recipe setup a template for importing kinesis json
# files stored on S3 into Elastic Search.
#
# It relies on logstash/agent cookbook.

name = 'agent'

Chef::Application.fatal!("attribute hash node['logstash']['instance']['#{name}'] must exist.") if node['logstash']['instance'][name].nil?

logstash_config name do
  input_vars = node['kinesis_logstash']['input']
  variables(
    'aws_credentials' => input_vars.fetch('aws_credentials'),
    'bucket' => input_vars.fetch('bucket'),
    'region_endpoint' => input_vars.fetch('region_endpoint'),
    'sincedb_path' => input_vars.fetch('sincedb_path')
  )
  templates({'input_s3.conf' => 'input_s3.conf.erb'})
  templates_cookbook('grantoo_kinesis_logstash')
  notifies :restart, "logstash_service[#{name}]"
  action [:create]
end

logstash_config name do
  templates({'filters.conf' => 'filters.conf.erb'})
  templates_cookbook('grantoo_kinesis_logstash')
  notifies :restart, "logstash_service[#{name}]"
  action [:create]
end

logstash_config name do
  output_vars = node['kinesis_logstash']['output']
  variables(
    'host' => output_vars.fetch('host'),
    'port' => output_vars.fetch('port', "80"),
    'user' => output_vars.fetch('user', ''),
    'password' => output_vars.fetch('password', '')
  )
  templates({'output_elastic.conf' => 'output_elastic.conf.erb'})
  templates_cookbook('grantoo_kinesis_logstash')
  notifies :restart, "logstash_service[#{name}]"
  action [:create]
end
