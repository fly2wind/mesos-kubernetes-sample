#!/usr/bin/env bash
check_key='monitoring/healthcheck'

curl -s -L http://localhost:2379/v2/keys/${check_key} -XPUT -d value="1"
curl -s -L http://localhost:2379/v2/keys/${check_key} | grep -w 'value.:.1'

if [ $? != 0 ]; then
    exit 2
fi

exit 0