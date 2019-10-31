#!/bin/bash

set -x

/usr/sbin/sshd -V

ssh-keygen -t rsa -N '' -f etc/ssh_host_rsa_key

/usr/sbin/sshd -f etc/sshd_config &

timeout -sKILL 10 ss -t

vendor/bin/heroku-php-apache2 -C apache.conf www
