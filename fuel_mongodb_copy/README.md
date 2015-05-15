Fuel MongoDB Copy
=================

Sets up an instance and mounts the latest production MongoDB on it.

Stack configuration
-------------------

Make sure you configure the stack with custom JSON

    {
      "awsAccessKeyId": "xxxxxxxxxxx",
      "awsSecretKey": "xxxxxxxxxxx"
    }

High level workflow
-------------------

1. create a new ec2 instance
1. install mongodb 2.6.6 on it (our setup version)
1. create a volume from the snapshop
1. attach the volume to instance
1. mount instance to /mnt/mongodb/default folder
1. chown recursively the whole thing
1. modify mongod.conf
1. dbpath = /mnt/mongodb/default/data/s-ds0124345-aN
1. directoryperdb=true (seems from the folder structure dbs are in their sub directories)