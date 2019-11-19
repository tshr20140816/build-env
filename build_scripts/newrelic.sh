#!/bin/bash

set -x

date

NEWRELIC_VERSION=9.3.0.248

curl -L -o /tmp/newrelic-php5-common_${NEWRELIC_VERSION}_all.deb \
  https://download.newrelic.com/debian/dists/newrelic/non-free/binary-amd64/newrelic-php5-common_${NEWRELIC_VERSION}_all.deb &
curl -L -o /tmp/newrelic-daemon_${NEWRELIC_VERSION}_amd64.deb \
  https://download.newrelic.com/debian/dists/newrelic/non-free/binary-amd64/newrelic-daemon_${NEWRELIC_VERSION}_amd64.deb &
curl -L -o /tmp/newrelic-php5_${NEWRELIC_VERSION}_amd64.deb \
  https://download.newrelic.com/debian/dists/newrelic/non-free/binary-amd64/newrelic-php5_${NEWRELIC_VERSION}_amd64.deb

wait

pushd /tmp

dpkg --help
time dpkg --instdir=/tmp/newrelic --admindir=/tmp/newrelic --root=/tmp/newrelic -i \
  newrelic-php5-common_${NEWRELIC_VERSION}_all.deb \
  newrelic-daemon_${NEWRELIC_VERSION}_amd64.deb \
  newrelic-php5_${NEWRELIC_VERSION}_amd64.deb

mkdir repo
dpkg-deb --help
dpkg-deb -x newrelic-php5-common_${NEWRELIC_VERSION}_all.deb repo
dpkg-deb -x newrelic-daemon_${NEWRELIC_VERSION}_amd64.deb repo
dpkg-deb -x newrelic-php5_${NEWRELIC_VERSION}_amd64.deb repo

ls -lang
ls -lang repo

popd

date
