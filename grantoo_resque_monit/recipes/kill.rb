log "grantoo_resque_monit::kill: pkill -QUIT -f resque"
`pkill -QUIT -f resque`

log "grantoo_resque_monit::kill: rm -f \"<%= @deploy[:deploy_to] %>/shared/pids/grantoo_resque_#{@worker}.pid\""
`rm -f "<%= @deploy[:deploy_to] %>/shared/pids/grantoo_resque_<%= @worker %>.pid"`