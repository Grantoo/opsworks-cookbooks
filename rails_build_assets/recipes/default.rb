include_recipe "deploy"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping unicorn::rails application #{application} as it is not an Rails app")
    next
  end

  script "build assets" do
    Chef::Log.debug("set to user 'deploy'")
    user 'deploy'
    Chef::Log.debug("set to interpreter 'bash'")
    interpreter 'bash'
    Chef::Log.debug("set to cwd #{deploy[:deploy_to]}/current")
    cwd deploy[:deploy_to] + "/current"
    Chef::Log.debug("RAILS_ENV=#{deploy[:rails_env]} /usr/local/bin/bundle exec rake assets:precompile")
    Chef::Log.debug(`RAILS_ENV=#{deploy[:rails_env]} /usr/local/bin/bundle exec rake assets:precompile`)
  end
end