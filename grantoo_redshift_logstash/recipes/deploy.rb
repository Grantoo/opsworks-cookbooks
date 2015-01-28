#
# Cookbook Name:: grantoo_redshift_logstash
# Recipe:: deploy
#
# Copyright (c) 2015 Fuel, All Rights Reserved.

include_recipe 'deploy'

repo = nil
revision = nil

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
  #
  #
  # deploy deploy[:deploy_to] do
  #   repository deploy[:scm][:repository]
  #   user 'ubuntu'
  #   group 'ubuntu'
  #   migrate deploy[:migrate]
  #   migration_command deploy[:migrate_command]
  #   environment deploy[:environment].to_hash
  #   action deploy[:action]
  #
  #   case deploy[:scm][:scm_type].to_s
  #     when 'git'
  #       scm_provider :git
  #       enable_submodules deploy[:enable_submodules]
  #       shallow_clone deploy[:shallow_clone]
  #     else
  #       raise "unsupported SCM type #{deploy[:scm][:scm_type].inspect}"
  #   end
  # end


  repo =  deploy[:scm][:repository]
  revision = deploy[:scm][:revision]

  Chef::Log.info("inside git, #{repo}, #{revision}")
  git '/home/ubuntu/redshift-pipeline' do
    repository deploy[:scm][:repository]
    revision deploy[:scm][:revision]
    user 'ubuntu'
    group 'ubuntu'
    notifies :run, "ruby[symlink-conf]", :deplayed
    action :sync
  end


  Chef::Log.info("inside confs count should be 3: #{Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].count}")
  Chef::Log.info("inside conf.d count should be 1: #{Dir["/opt/logstash/agent/etc/conf.d/"].count}")

  Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].each do |to_file|
    link "/opt/logstash/agent/etc/conf.d/#{File.basename(to_file)}" do
      to to_file
      owner "logstash"
      group "logstash"
      action :create
    end
  end
end

ruby "symlink-conf" do
  Chef::Log.info("ruby block confs count should be 3: #{Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].count}")
  Chef::Log.info("ruby block conf.d count should be 1: #{Dir["/opt/logstash/agent/etc/conf.d/"].count}")

  Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].each do |to_file|
    link "/opt/logstash/agent/etc/conf.d/#{File.basename(to_file)}" do
      to to_file
      owner "logstash"
      group "logstash"
      action :create
    end
  end
end
#
# Chef::Log.info("outside git, #{repo}, #{revision}")
# git '/home/ubuntu/redshift-pipeline' do
#   repository repo
#   revision revision
#   user 'ubuntu'
#   group 'ubuntu'
#   action :sync
# end
#
# Chef::Log.info("outside confs count should be 3: #{Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].count}")
# Chef::Log.info("outside conf.d count should be 1: #{Dir["/opt/logstash/agent/etc/conf.d/"].count}")
#
# Dir["/home/ubuntu/redshift-pipeline/logstash/confs/*"].each do |to_file|
#   link "/opt/logstash/agent/etc/conf.d/#{File.basename(to_file)}" do
#     to to_file
#     owner "logstash"
#     group "logstash"
#     action :create
#   end
# end
#
