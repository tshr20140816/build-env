#!/bin/bash

set -x

hostname -i
echo ${PORT}
whoami

/usr/sbin/sshd -V

ssh-keygen -t rsa -N '' -f etc/ssh_host_rsa_key

/usr/sbin/sshd -p 60022 -f etc/sshd_config &

sleep 10 && timeout -sKILL 10 ss -ant &

vendor/bin/heroku-php-apache2 -C apache.conf www
