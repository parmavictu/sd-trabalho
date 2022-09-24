function StartMinikube() {
    LoggerInfo "Verificando se o minikube está rodando..."

    if [[ ! $(minikube status | grep -i 'running' | wc -l) == 3 ]]; then
        LoggerInfo "Startando o minikube..."
        minikube start
        
        LoggerInfo "Ativando ingress..."
        minikube addons enable ingress

        DSTR=$(date -u)
        minikube ssh 'sudo date --set="$DSTR"'
    fi
}

function Create() {

    if [[ -z $(ls $1 | grep 'deployment.yaml') ]]; then
        return
    fi

    if [[ -f $1 ]]; then
        local _DEPLOYMENT=$(cat $1 | grep -A2 Deployment | grep name | awk '{print $2}')
    else
        local _DEPLOYMENT=$(cat $1/deployment.yaml | grep -A2 Deployment | grep name | awk '{print $2}')
    fi

    local _TMP_FILE=$(RandomFile)

    kubectl get deploy &> $_TMP_FILE

    if [[ $(cat $_TMP_FILE | grep $_DEPLOYMENT | wc -l) == 0 ]]; then
        kubectl create -f $1
    else
        LoggerError 'Já existem um deploy.'
        echo
        cat $_TMP_FILE
    fi

    rm $_TMP_FILE
}

function Apply() {
    if [[ -z $(ls $1 | grep 'deployment.yaml') ]]; then
        return
    fi

    if [[ $(kubectl get deploy | grep 'trabalho-sd' | wc -l) -gt 0 ]]; then
        kubectl apply -f $1
    fi
}

function Delete() {
    if [[ -z $(ls $1 | grep 'deployment.yaml') ]]; then
        return
    fi

    if [[ $(kubectl get deploy | grep 'trabalho-sd' | wc -l) -gt 0 ]]; then
        kubectl delete -f $1
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

function RandomFile() {
	local _UUID=$(uuidgen | sed 's/-//g')

	local _FILE="/tmp/${_UUID}-temp-file.txt"

    touch $_FILE

	echo "$_FILE"
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