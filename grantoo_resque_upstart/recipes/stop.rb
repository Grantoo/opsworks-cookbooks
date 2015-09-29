cpu_count = `cat /proc/cpuinfo | grep processor | wc -l`.to_i # assume linux
Chef::Log.info "[grantoo_resque_monit::start] stopping #{cpu_count} workers"

(1..cpu_count).each do |cpu_number|
  execute "stop_resque_worker_#{cpu_number}" do
    command "stop resque_worker ID=#{cpu_number}"
  end
end

Chef::Log.info "[grantoo_resque_monit::stop] done"