cpu_count = `cat /proc/cpuinfo | grep processor | wc -l`.to_i # assume linux
Chef::Log.info "[grantoo_resque_monit::start] cpu_count #{cpu_count}"

(1..cpu_count).each do | cpu_number |
  Chef::Log.info "[grantoo_resque_monit::start] starting resque_worker_#{cpu_number}"
  `monit start resque_worker_#{cpu_number}`
end

Chef::Log.info "[grantoo_resque_monit::start] done"