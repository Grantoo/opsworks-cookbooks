node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping setup because application #{application} as it is not a php app")
    next
  end
  # adjust the log output folder to capture laravel logs
  case node[:platform]
    when 'ubuntu','debian'

      Chef::Log.info("fix log directory")
      Chef::Log.info("in #{deploy[:deploy_to]}/current#{node[:laravel][:storage]}")
      Chef::Log.info("as #{deploy[:deploy_to]}/current#{node[:shared][:logs]} -> logs")

      bash "fix log directory" do
        user "root"
        cwd "#{deploy[:deploy_to]}/current#{node[:laravel][:storage]}"
        code <<-EOH
          echo fix logs to point to the right place
          echo #{deploy[:deploy_to]}
          echo #{node[:shared][:logs]}
          rm -rf logs
          ln -nfs "#{deploy[:deploy_to]}/current#{node[:shared][:logs]}" logs
          chmod ugo+rw *
        EOH
      end

      # support apache2 restart
      service 'apache2' do
        action :restart
        only_if 'service apache2 status', :user => 'root'
      end
      # support nginx php-fpm restart
      # service 'php5-fpm' do
      #   action :restart
      #   only_if 'service php5-fpm status', :user => 'root'
      # end

    when 'centos','redhat','fedora','amazon'
      # do not know yet
  end

end

