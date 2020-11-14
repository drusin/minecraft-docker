#!/bin/sh

if ! netstat -tn | grep 25565 | grep ESTABLISHED ; then killall -STOP java ; fi