#!/bin/bash
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'jmeter.sh' | grep -Po '(?<=-> ).*(?=/jmeter.sh)' | sed 's/ //g'))

_WHERE_AIM=$(pwd)

cd $_ROOT_PATH

rm jmeter.log >> /dev/null

jmeter -n -t teste.jmx &

while [[ ! -f jmeter.log ]]; do
    echo -ne "Iniciando... \033[0K\r"
done

tail -f -n 50 jmeter.log

cd $_WHERE_AIM
