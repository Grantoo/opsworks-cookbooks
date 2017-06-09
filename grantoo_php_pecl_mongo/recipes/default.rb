case node[:platform]
  when 'ubuntu','debian'
    template node[:mongo][:ini_file] do
      source 'mongo.ini.erb'
      owner 'root'
      group 'root'
      mode 0644
    end

    link node[:mongo][:ini_link] do
      to node[:mongo][:ini_file]
    end

    bash "install pecl/mongo" do
      user "root"
      cwd "/tmp"
      code <<-EOH
      pear install -f pecl/mongo
      yes "" | pecl install -f mongo
      true
      EOH
    end

    service 'apache2' do
      action :restart
      only_if 'service apache2 status', :user => 'root'
    end

  when 'centos','redhat','fedora','amazon'
    # do not know yet
    php_pear 'pecl/mongo' do
      action :install
    end
end