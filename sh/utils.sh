function StartMinikube() {
    LoggerInfo "Verificando se o minikube está rodando..."

    if [[ $(minikube status | grep -i 'running' | wc -l) == 0 ]]; then
        LoggerInfo "Startando o minikube..."
        minikube start --memory 8192 --cpus 4
        
        LoggerInfo "Ativando ingress..."
        minikube addons enable ingress

        minikube addons enable metrics-server

        LoggerInfo "Ativando metricas..."
        kubectl apply -f kube-state-metrics/
    fi
}

function FormattMessage() {
	local _YELLOW='\033[0;33m'
    local _WHITE='\033[0m'
    local _RED='\033[0;31m'

    for i do
        if [[ -z $_MENSAGEM ]]; then
            local _MENSAGEM=$(echo "$i" | grep '\-\-message=' | awk -F '=' '{print $2}')
        fi
    done

    if [[ -z $_MENSAGEM ]]; then
		return
	fi

    if $(HasFlag --value='err' --upper-flag='E' "$@"); then
	    echo -e "\n$(date "+%F %H:%M:%S"): [${_RED}ERROR${_WHITE}]: $_MENSAGEM"

        if $(HasFlag --value='exit' --upper-flag='E' "$@"); then
            exit 1
        fi
    else
        echo -e "\n$(date "+%F %H:%M:%S"): [${_YELLOW}INFO${_WHITE}]: $_MENSAGEM"
    fi

}

function GetArgument() {
    local _NAME='value'

    for i do
        if [[ ! -z $(echo "$i" | egrep -w "^\-\-name=(.*)$") ]]; then
		    _NAME=$(echo "$i" | awk -F '=' '{print $2}')
	    fi
    done

    for i do
        if [[ ! -z $(echo "$i" | egrep -w "^\-\-$_NAME=(.*)$") ]]; then
		    echo $(echo "$i" | awk -F '=' '{print $2}')
            return
	    fi
    done
}


function HasFlag() {
    local _VALUE=$(GetArgument "$@")
    local _UPPER_FLAG=$(GetArgument --name='upper-flag' "$@")

	local IFS='-'

    if [[ -z $_UPPER_FLAG ]]; then
        read -a _ARGS <<< "$_VALUE"
        
        for A in "${_ARGS[@]}"; do
            _UPPER_FLAG+="$(echo $A | cut -c1-1 | awk '{print toupper($0)}')"
        done
    fi

    for i do
		if [[ ! -z $(echo "$i" | egrep -w "^\-\-$_VALUE$") ]] ||
		   [[ ! -z $(echo "$i" | egrep -w "^\-$_UPPER_FLAG$") ]]; then
			echo true
			return
        fi
    done

	echo false
}

function LoggerInfo() {
	FormattMessage --message="$1"
}

function LoggerError() {
    if $(HasFlag --value='exit' --upper-flag='E' "$@"); then
        local _EXIT='--exit'
    fi
	FormattMessage --message="$1" --err "$@"
}