### PostgresSQL

## Install

https://www.linuxcapable.com/how-to-install-postgresql-14-on-fedora-36-linux/
`systemctl status postgresql-14`

## Configure

A user called postgres was created at during the install:  
`sudo -i -u postgres` then psql to enter the command line utility or  
`sudo -u postgres psql`

## Login to database

`psql -d mydb -U myuser`

## PSQL

Import database `\i /home/user/database.sql`
