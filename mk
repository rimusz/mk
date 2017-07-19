#!/bin/bash
#
# Simple wrapper for minikube cli

run() {
    if [[ -z "${1// }" ]]
    then
       echo "Usage: mk minikube_command|create|create-xhyve|start|mount|k8s|set-k8s|docker|dash|toolbox|get|get-xhyve|upgrade-xhyve"
    else
       minikube $@
    fi
}

create() {
  minikube start \
    --v=4 \
    --disk-size=50g \
    --vm-driver=xhyve \
    --network-plugin=cni \
    --container-runtime=docker
  minikube addons enable heapster
  minikube addons enable ingress
  minikube addons enable registry
  helm init
}

create-vbox() {
  minikube start \
    --v=4 \
    --disk-size=50g \
    --network-plugin=cni \
    --container-runtime=docker
  minikube addons enable heapster
  minikube addons enable ingress
  minikube addons enable registry 
  helm init
}

start() {
  minikube start --v=4
}

mount() {
  minikube mount ${HOME}
}

k8s() {
    minikube get-k8s-versions
}

set-k8s() {
    minikube config set kubernetes-version $2
}

docker() {
    eval $(minikube docker-env)
    /bin/bash
}

dash() {
    minikube dashboard
}

toolbox() {
    minikube ssh toolbox
}

get() {
  echo " "
  echo "Checking for latest minikube version..."
  cd ~/tmp
  LATEST_MINIKUBE=$(curl -s https://api.github.com/repos/kubernetes/minikube/releases/latest | grep "tag_name" | awk '{print $2}' | sed -e 's/"\(.*\)"./\1/')

  echo "Downloading latest minikube ${LATEST_MINIKUBE}"
  curl -Lo minikube https://storage.googleapis.com/minikube/releases/${LATEST_MINIKUBE}/minikube-darwin-amd64
  chmod +x minikube
  mv minikube ~/bin/
  echo " "
  echo "Installed latest ${LATEST_MINIKUBE} of minikube to '~/bin' ..."
}

get-xhyve() {
    brew install docker-machine-driver-xhyve
    sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
}

upgrade-xhyve() {
    brew upgrade docker-machine-driver-xhyve
    sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
}

case "$1" in
        create)
                create
                ;;
        create-xhyve)
                create-xhyve
                ;;
        start)
                start
                ;;
        mount)
                mount
                ;;
        k8s)
                k8s
                ;;
        set-k8s)
                set-k8s $@
                ;;
        docker)
                docker
                ;;
        dash)
                dash
                ;;
        toolbox)
                toolbox
                ;;
        get)
                get
                ;;
        get-xhyve)
                get-xhyve
                ;;
	upgrade-xhyve)
		upgrade-xhyve
		;;
        $@)
                run $@
                ;;

esac
