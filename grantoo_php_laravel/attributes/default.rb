case node[:platform]
  when 'redhat', 'centos', 'fedora', 'amazon'
  when 'debian', 'ubuntu'
    default[:laravel][:storage] = '/app/storage'
    default[:laravel][:logs] = '/app/storage/logs'
    default[:shared][:logs] = '/log'
  else
    raise 'Bailing out, unknown platform.'
end