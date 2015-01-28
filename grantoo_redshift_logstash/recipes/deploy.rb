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
    user 'ubuntu'
    group 'ubuntu'
    action :sync
  end
end

Chef::Log.info("confs count should be 3: #{Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].count}")
Chef::Log.info("conf.d count should be 1: #{Dir["/opt/logstash/agent/etc/conf.d/"].count}")

Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].each do |to_file|
  link "/opt/logstash/agent/etc/conf.d/#{File.basename(to_file)}" do
    to to_file
    owner "logstash"
    group "logstash"
    action :create
  end
end
