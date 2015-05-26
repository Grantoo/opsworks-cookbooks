Fuel MongoDB Copy
=================

Sets up an instance and mounts the latest production MongoDB on it.

Usage
-----

1. Launch an instance in opsworks application Mongodb Copy. This will create volumes from backup snapshots. It is a good idea to launch an instance with big enough memory for the database size. You must launch this instance in us-east-1b as the script creates volumes there.
1. SSH into server
1. Stop mongo db server `sudo service mongod stop`
1. Modify /etc/mongod.conf (e.g. `sudo vi /etc/mongod.conf`)
  1. Add a line `directoryperdb = true`
  1. Modify the line dbpath=xxxxx to point to the database you would like to point to. The following shows examples but you will need to modify `N` to be the right folder name.
    1. `dbpath=/mnt/mongodb/default/data/s-ds051207-aN` for default database
    1. `dbpath=/mnt/mongodb/users_db_session/data/s-ds057781-aN` for users database
1. Start mongo db server with new configuration `sudo service mongod start`
1. You can now use the database by connecting to it with `mongo`
1. When you are done with the server, shutdown and delete the instance. Go into EC2 volumes and locate the volumes created and delete them.

Caveats
-------

you may have to re-run the setup script in opsworks to get it to install the first time.
also the drives may not mount during the chef script, but can be mounted after... so you may want to run this script manually after 'successful' setup

```
mkdir -p /mnt/mongodb/default
mount /dev/xvdm /mnt/mongodb/default/

mkdir -p /mnt/mongodb/users_db_session
mount /dev/xvdn /mnt/mongodb/users_db_session/

chown --recursive mongodb:mongodb /mnt/mongodb/
```

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
