#!/bin/sh

cd `dirname $0`

docker build ./ -t tkmnet/rrs-runenv:latest
