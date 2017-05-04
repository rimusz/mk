#!/bin/bash
#
# Simple wrapper for minikube cli

run() {
    if [[ -z "${1// }" ]]
    then
       echo "Usage: mk minikube_command|create|start|mount|k8s|docker|dash|toolbox|get|xhyve"
    else
       minikube $@
    fi
}

create() {
  minikube start \
    --v=4 \
    --disk-size=40g \
    --vm-driver=xhyve 
#    --network-plugin=cni \
#    --container-runtime=docker
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

xhyve() {
    brew install docker-machine-driver-xhyve
    sudo chown root:wheel $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
    sudo chmod u+s $(brew --prefix)/opt/docker-machine-driver-xhyve/bin/docker-machine-driver-xhyve
}

case "$1" in
        create)
                create
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
        xhyve)
                xhyve
                ;;
        $@)
                run $@
                ;;

esac
