#!/bin/sh

supervisord -c /etc/supervisor/supervisord.conf
export DISPLAY=:0

while [ `ss -ant | grep ":22 " | wc -l` -lt 1 ]; do
	sleep 1
done

cd /root
./rrsenv/script/rrscluster setup >/dev/null 2>&1
./rrsenv/script/rrscluster check

./rrsenv/script/rrscluster run -m test -a sample -l /log
