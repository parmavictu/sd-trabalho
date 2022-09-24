
function SetTamplate() {
	local _TAMPLATE="$1"

	if [[ -z $_TAMPLATE ]]; then
		return
	fi

	local _TMP_FILE="$(uuidgen)-temp-file.txt"
	
	source "${_TAMPLATE}" &> $_TMP_FILE

	cat $_TMP_FILE | grep -v '<TAMPLATE>'

	rm $_TMP_FILE
}	

function StartMinikube() {
    LoggerInfo "Verificando se minikube está rodando..."

    if [[ ! $(minikube status | grep -i 'running' | wc -l) == 3 ]]; then
        LoggerInfo "Startando o minikube..."
        minikube start --insecure-registry "$(hostname -I | awk '{print $1}')/24"
        DSTR=$(date -u)
        minikube ssh 'sudo date --set="$DSTR"'
    fi
}

function Create() {
    envsubst < $1 | kubectl create -f -
}

function Apply() {
    envsubst < $1 | kubectl apply -f -
}

function Delete() {
    envsubst < $1 | kubectl delete -f -
}

function FormattMessage() {
	local _YELLOW='\033[0;33m'
    local _WHITE='\033[0m'
    local _RED='\033[0;31m'

    for i do
        local _MENSAGEM=$(echo $i | grep '\-\-message=' | awk -F '=' '{print $2}')
    done

    if [[ -z $_MENSAGEM ]]; then
		return
	fi

    if [[ ! -z $(echo $i | grep '\-\-err') ]]; then
	    echo -e "\n$(date "+%F %H:%M:%S"): [${_RED}ERROR${_WHITE}] ${PWD}: $_MENSAGEM"
        exit 1
    else
	    echo -e "\n$(date "+%F %H:%M:%S"): [${_YELLOW}INFO${_WHITE}] ${PWD}: $_MENSAGEM"
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
	FormattMessage --message="$1" --err
}