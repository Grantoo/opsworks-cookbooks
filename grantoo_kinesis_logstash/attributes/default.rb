# The following attributes are required:
#
# * ['kinesis_logstash']['input']['aws_credentials'] = [ 'my-key', 'my-secret' ]
# * ['kinesis_logstash']['input']['bucket'] = 'my-bucket'

default['kinesis_logstash']['input']['region_endpoint'] = "us-east-1"
default['kinesis_logstash']['input']['sincedb_path'] = "last-s3-file"

default['kinesis_logstash']['output']['host'] = "localhost"
default['kinesis_logstash']['output']['port'] = "9200"
default['kinesis_logstash']['output']['user'] = ""
default['kinesis_logstash']['output']['password'] = ""

