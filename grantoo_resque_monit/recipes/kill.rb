log "grantoo_resque_monit::kill: pkill -QUIT -f resque"
log `pkill -QUIT -f resque`

log "grantoo_resque_monit::kill: rm -f \"<%= deploy[:deploy_to] %>}/shared/pids/grantoo_resque_*.pid\""
log `rm -f "<%= @deploy[:deploy_to] %>/shared/pids/grantoo_resque_*.pid"`