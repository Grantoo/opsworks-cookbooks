include_recipe "deploy"
include_recipe "unicorn::rails"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping unicorn::rails application #{application} as it is not an Rails app")
    next
  end

  bash "build_assets" do
    user 'deploy'
    cwd deploy[:deploy_to] + "/current"
    code "RAILS_ENV=#{deploy[:rails_env]} /usr/local/bin/bundle exec rake assets:precompile"
    notifies :restart, resources(:service => "unicorn_#{application}")
    only_if do
      File.exists?("#{deploy[:deploy_to]}/shared/config/unicorn.conf")
    end
  end
end