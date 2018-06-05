#!/bin/sh

supervisord -c /etc/supervisor/supervisord.conf
export DISPLAY=:0

while [ `ss -ant | grep ":22 " | wc -l` -lt 1 ]; do
	sleep 1
done

password=`date | md5sum | head -c 32`

expect -c "
spawn passwd user
expect Enter\ ;  send $password; send \r
expect Retype\ ; send $password; send \r;
expect eof exit 0
" >/dev/null 2>&1

echo user : $password
