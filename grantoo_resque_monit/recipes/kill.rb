puts "pkill -QUIT -f resque"
`pkill -QUIT -f resque`

puts "rm -f \"<%= @deploy[:deploy_to] %>/shared/pids/grantoo_resque_#{@worker}.pid\""
`rm -f "<%= @deploy[:deploy_to] %>/shared/pids/grantoo_resque_<%= @worker %>.pid"`