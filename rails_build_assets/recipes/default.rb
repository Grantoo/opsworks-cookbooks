include_recipe "deploy"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping unicorn::rails application #{application} as it is not an Rails app")
    next
  end

  script "build assets" do
    user 'deploy'
    cwd deploy[:deploy_to] + "/current"
    code "RAILS_ENV=#{deploy[:rails_env]} /usr/local/bin/bundle exec rake assets:precompile"
  end
end