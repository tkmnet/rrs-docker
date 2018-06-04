#!/bin/sh

supervisord -c /etc/supervisor/supervisord.conf
export DISPLAY=:100
bash
