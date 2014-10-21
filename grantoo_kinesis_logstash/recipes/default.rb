# This recipe setup templates for importing kinesis json
# files stored on S3 into Elastic Search.
#
# It relies on resources defined in chef-logstash cookbook.

name = 'agent'

Chef::Application.fatal!("attribute hash node['logstash']['instance']['#{name}'] must exist.") if node['logstash']['instance'][name].nil?

# Generate input file
logstash_config name do
  input_vars = node.fetch('kinesis_logstash').fetch('input')

  sincedb_path = input_vars.fetch('sincedb_path')
  unless sincedb_path[0] == '/' # relative path
    sincedb_path = Logstash.get_attribute_or_default(node, name, 'homedir') + '/' + sincedb_path
    # default is /var/lib/logstash/last-s3-file
  end

  variables(
    'aws_credentials' => input_vars.fetch('aws_credentials'),
    'bucket'          => input_vars.fetch('bucket'),
    'region_endpoint' => input_vars.fetch('region_endpoint'),
    'sincedb_path'    => sincedb_path
  )
  templates({'100_input_s3.conf' => '100_input_s3.conf.erb'})
  templates_cookbook('grantoo_kinesis_logstash')
  notifies :restart, "logstash_service[#{name}]"
  action [:create]
end

# Generate filter file
logstash_config name do
  templates({'200_filters.conf' => '200_filters.conf.erb'})
  templates_cookbook('grantoo_kinesis_logstash')
  notifies :restart, "logstash_service[#{name}]"
  action [:create]
end

# Generate output file
logstash_config name do
  output_vars = node.fetch('kinesis_logstash').fetch('output')
  variables(
    'host' => output_vars.fetch('host'),
    'port' => output_vars.fetch('port', "80"),
    'user' => output_vars.fetch('user', ''),
    'password' => output_vars.fetch('password', '')
  )
  templates({'300_output_elastic.conf' => '300_output_elastic.conf.erb'})
  templates_cookbook('grantoo_kinesis_logstash')
  notifies :restart, "logstash_service[#{name}]"
  action [:create]
end
