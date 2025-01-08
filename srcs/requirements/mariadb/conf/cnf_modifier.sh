#!/bin/bash

rm -f /etc/my.cnf
mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql --rpm
cat << EOF >> /etc/mysql/my.cnf
[mysqld]
port                    = 3306
user                    = mysql
pid-file                = /run/mysqld/mysqld.pid
socket                  = /run/mysqld/mysqld.sock
basedir                 = /usr
datadir                 = /var/lib/mysql
tmpdir                  = /tmp
lc-messages-dir         = /usr/share/mysql
bind-address            = 0.0.0.0
log_error      = /var/lib/mysql/error.log
EOF
