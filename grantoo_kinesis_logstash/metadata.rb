name             'grantoo_kinesis_logstash'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures grantoo_kinesis_logstash'
long_description 'Installs/Configures grantoo_kinesis_logstash'
version          '0.1.0'


%w(java curl ark).each do |dep|
  depends dep
end
