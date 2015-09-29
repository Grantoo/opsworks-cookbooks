include_recipe "deploy"

# example settings: {"resque":{"queues": "*", "layers": [{"name": "railsworkerspriority", "queues": "my_special_queue"}]}}
queues = node[:resque][:queues]
if  !node[:opsworks][:instance].nil? && !node[:opsworks][:instance][:layers].nil? && !node[:resque][:layers].nil?
  # scan for matching layer
  node[:resque][:layers].each do |layer|
    if node[:opsworks][:instance][:layers].include?(layer[:name])
      queues = layer[:queues]
    end
  end
end

cpu_count = `cat /proc/cpuinfo | grep processor | wc -l`.to_i # assume linux

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'rails'
    Chef::Log.debug("Skipping resque setup because application #{application} as it is not a Rails app")
    next
  end

  template File.join(node[:upstart][:conf_dir], "resque_worker.conf") do
    mode 0700
    source 'resque_worker.conf.erb'
    variables(
        :cpu_count => cpu_count,
        :queues => queues,
        :deploy => deploy
    )
  end

  template File.join(node[:upstart][:conf_dir], "resque_workers.conf") do
    mode 0700
    source 'resque_workers.conf.erb'
    variables(:cpu_count => cpu_count)
  end
end
