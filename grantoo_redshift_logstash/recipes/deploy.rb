#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: deploy
#
# Copyright (c) 2015 Fuel, All Rights Reserved.

include_recipe 'deploy'

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'other' && application != 'redshift-pipeline'
    Chef::Log.debug("Skipping grantoo_redshift_logstash::deploy application #{application} as it is not the redshift-pipeline project")
    next
  end

  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path '/home/ubuntu'
  end

  opsworks_deploy do
    deploy_data deploy
    app application
  end
end