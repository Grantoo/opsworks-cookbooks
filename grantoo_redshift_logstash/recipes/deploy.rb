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

  prepare_git_checkouts(
    :user => 'ubuntu',
    :group => 'ubuntu',
    :home => '/home/ubuntu',
    :ssh_key => deploy[:scm][:ssh_key]
  ) if deploy[:scm][:scm_type].to_s == 'git'

  git '/home/ubuntu/redshift-pipeline' do
    repository deploy[:scm][:repository]
    revision deploy[:scm][:revision]
    action :sync
  end
end