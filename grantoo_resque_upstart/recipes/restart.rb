cpu_count = `cat /proc/cpuinfo | grep processor | wc -l`.to_i # assume linux
Chef::Log.info "[grantoo_resque_monit::start] stopping #{cpu_count} workers"

num_upstart_resques_running = `initctl list | grep -E "resque_worker.*running" | wc -l`.to_i
if num_upstart_resques_running > 0
  include_recipe 'grantoo_resque_upstart::stop'
end

include_recipe 'grantoo_resque_upstart::start'

Chef::Log.info "[grantoo_resque_monit::stop] done"
