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

  bash "symlink-conf" do
    code "ln -nsf ~ubuntu/redshift-pipeline/logstash/confs/100_input_s3.conf ~ubuntu/redshift-pipeline/logstash/confs/200_filters.conf ~ubuntu/redshift-pipeline/logstash/confs/300_output_csv.conf /opt/logstash/agent/etc/conf.d/"
    user "logstash"
    group "logstash"
    action :run
  end

  bash "symlink-certs" do
    code "ln -nsf ~ubuntu/redshift-pipeline/certificates /opt/logstash/agent/certificates"
    user "logstash"
    group "logstash"
    action :run
  end

  bash "logstash-plugins" do
    code "/opt/logstash/agent/bin/plugin install contrib"
    user "logstash"
    group "logstash"
    action :run
  end
end
