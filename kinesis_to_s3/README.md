kinesis to s3
=============

Stores kinesis data from Radar Analytics into s3. Used with Amazon Opsworks.

Stack settings
--------------

Make sure your stack has custom JSON {"kinesisToS3Env":"AWS_ACCESS_KEY_ID=xxxx AWS_SECRET_KEY=xxxx"}


File locations
--------------

Application installed to /opt/kinesis_to_s3

- jar file
- properties file
- monit pid

Monit control file saved in /etc/monit/conf.d/kinesis-to-s3.monitrc