case node[:platform]
  when 'redhat', 'centos', 'fedora', 'amazon'
  when 'debian', 'ubuntu'
    default[:mongo][:ini_link] = '/etc/php5/apache2/conf.d/20-mongo.ini'
    default[:mongo][:ini_file] = '/etc/php5/mods-available/mongo.ini'
  else
    raise 'Bailing out, unknown platform.'
end