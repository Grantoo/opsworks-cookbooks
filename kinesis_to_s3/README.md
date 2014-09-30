kinesis to s3
=============

Stores kinesis data from Radar Analytics into s3. Used with Amazon Opsworks.

Stack settings
--------------

Make sure your stack has custom JSON {"awsAccessKeyId": "xxxxx", "awsSecretKey": "xxxxx"}


File locations
--------------

Application installed to /opt/kinesis_to_s3

- jar file
- properties file

Monit control file saved in /etc/monit/conf.d/kinesis-to-s3.monitrc
Init script saved in /etc/init.d/kinesis-to-s3
Pid file saved in /var/run/kinesis-to-s3.pid