cpu_count = `cat /proc/cpuinfo | grep processor | wc -l`.to_i # assume linux
Chef::Log.info "[grantoo_resque_monit::start] starting #{cpu_count} workers"

execute 'start_resque_workers' do
  command 'start resque_workers'
end

Chef::Log.info "[grantoo_resque_monit::start] done"
