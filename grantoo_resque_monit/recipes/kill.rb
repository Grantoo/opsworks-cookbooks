cpu_count = `cat /proc/cpuinfo | grep processor | wc -l`.to_i # assume linux
Chef::Log.info "grantoo_resque_monit::kill starting with cpu_count #{cpu_count}"

(1..cpu_count).each do | cpu_number |
  Chef::Log.info "grantoo_resque_monit::kill stopping resque_worker_#{cpu_number}"
  `monit stop resque_worker_#{cpu_number}`
end

Chef::Log.info "grantoo_resque_monit::kill done"