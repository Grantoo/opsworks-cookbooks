name             'grantoo_kinesis_logstash'
maintainer       'engineers@grantoo.org'
maintainer_email 'engineers@grantoo.org'
license          'All rights reserved'
description      'Installs/Configures grantoo_kinesis_logstash'
long_description 'Installs/Configures grantoo_kinesis_logstash'
version          '0.1.0'


%w(java curl ark).each do |dep|
  depends dep
end
