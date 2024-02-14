#!/bin/bash
siege -c 10 -r 100 172.44.0.2 > /dev/null
