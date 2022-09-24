#!/bin/bash
_ROOT_PATH=$(echo $(ls -l /proc/$$/fd | egrep 'start.sh' | grep -Po '(?<=-> ).*(?=/start.sh)' | sed 's/ //g'))

_WHERE_AIM=$(pwd)

cd $_ROOT_PATH

export _UTILS="$_ROOT_PATH/sh/utils.sh"

source $_UTILS

API_IMAGE_PULL_POLICY=$(GetArgument --name='image-pull-policy' "$@")

if [[ ! -z $_ACCEPTED_ARG ]];then
    API_IMAGE_PULL_POLICY=$_ALWAYS
fi

LoggerInfo 'Projeto...'

gateway/deploy.sh "$@"

cd $_ROOT_PATH

backend/deploy.sh "$@"

if $(HasFlag --value='monitoring' --upper-flag='M' "$@") || $(HasFlag --value='all' "$@"); then
    ./monitoring/k8s/deploy.sh
fi

cd $_WHERE_AIM