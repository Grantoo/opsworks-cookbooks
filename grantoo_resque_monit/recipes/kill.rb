Chef::Log.info "grantoo_resque_monit::kill: pkill -QUIT -f resque"
Chef::Log.info `pkill -QUIT -f resque`

node[:deploy].each do |application, deploy|
  Dir.glob(File.join(deploy[:deploy_to], "shared/pids/grantoo_resque_*.pid")).each do |f|
    Chef::Log.info("deleting #{f}")
    File.delete(f)
  end
end