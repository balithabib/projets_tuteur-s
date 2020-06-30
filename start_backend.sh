#!/usr/bin/env bash
# Automation script

MODELS="ssd_mobilenet_v1_coco_11_06_2017 ssd_inception_v2_coco_11_06_2017 rfcn_resnet101_coco_11_06_2017 faster_rcnn_resnet101_coco_11_06_2017 faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017"
ACTION=$1
MODEL=$2
PATH_BASE=$(pwd)

function installation_of_prerequisites() {
    apt update
    apt install -y git python3 protobuf-compiler python-pil python-lxml
    pip3 install -r requirements.txt
}

function installation_of_detection_api() {
    cd /opt
    git clone https://github.com/tensorflow/models
    cd models/research
    protoc object_detection/protos/*.proto --python_out=.
}

function download_the_binaries_of_pre-trained_models() {
    mkdir -p /opt/graph_def && cd /opt/graph_def
    for model in ${MODELS}
    do
      curl -OL http://download.tensorflow.org/models/object_detection/${model}.tar.gz
      tar -xzf ${model}.tar.gz ${model}/frozen_inference_graph.pb
    done
    rm -rf /opt/graph_def/*.tar.gz
}

function choose_a_model() {
    MODEL_NAME=$1
    echo "The chosen model is ${MODEL_NAME}"
    ln -sf /opt/graph_def/${MODEL_NAME}/frozen_inference_graph.pb /opt/graph_def/frozen_inference_graph.pb
    chmod 777 /opt/graph_def/frozen_inference_graph.pb
}

function print(){
	echo -e "\e[32m$1\033[0m"
}

function action_script() {
	action=$1
	case ${action} in
	    "install_pre")
            print "1 - Install the prerequisite packages"
            installation_of_prerequisites
        ;;
        "install_api")
            print "2 - Install the Object Detection API library"
            installation_of_detection_api
        ;;
        "download_model")
            print "3 - Download the pre-trained model binaries"
            download_the_binaries_of_pre-trained_models
        ;;
        "choose_model")
            print "4 - Choose a model for the web application"
            choose_a_model ${MODEL}
        ;;
        "start")
            HOST=$(hostname -I | cut -d ' ' -f1)
            print "Launch the web application ${HOST}"
            cd ${PATH_BASE}
            python3 -m backend --host ${HOST} --port "6666"
        ;;
        *)
            usage_action
        ;;
    esac
}

function usage_action() {
  echo "./start_backend.sh <ACTION> <MODEL>"
  echo "Action : <start> or {install_pre, install_api, download_model, choose_model, start, all}"
  exit 1
}

function usage_model() {
    if [ -z ${MODEL} ]; then
      echo "./start_backend.sh <ACTION> <MODEL>"
      echo "No argument supplied"
      echo "Usage: first argument must be the pre-trained model name"
      echo "choose one in : ${MODELS}"
      exit 1
    fi
}


print "START ..."

usage_model

case ${ACTION} in
	"all")
        for action in  install_pre install_api download_model choose_model start; do
			action_script ${action}
		done
		;;
	*)
	action_script "$ACTION"
	;;
esac

print "FINISHED!"
exit 0