include_recipe "grantoo_resque_monit::service"

service "monit" do
  action :stop
end
