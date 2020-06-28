#!/usr/bin/env bash
# Automation script

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
}

function print(){
	echo -e ${BACKGROUND_COLOR} $1 ${NO_COLOR}
}



BACKGROUND_COLOR="\033[31;42m"
NO_COLOR="\033[0m"
MODELS="ssd_mobilenet_v1_coco_11_06_2017 ssd_inception_v2_coco_11_06_2017 rfcn_resnet101_coco_11_06_2017 faster_rcnn_resnet101_coco_11_06_2017 faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017"
MODEL=$1

if [ -z ${MODEL} ]; then
  echo "No argument supplied"
  echo "Usage: first argument must be the pre-trained model name"
  echo "choose one in : ${MODELS}"
  exit 1
fi

PATH_BASE=$(pwd)

print "Start ..."

print "1 - Install the prerequisite packages"
installation_of_prerequisites

print "2 - Install the Object Detection API library"
installation_of_detection_api

print "3 - Download the pre-trained model binaries"
download_the_binaries_of_pre-trained_models

print "4 - Choose a model for the web application"
choose_a_model ${MODEL}

HOST=$(hostname -I | cut -d ' ' -f1)
print "Launch the web application ${HOST}"
cd ${PATH_BASE}
python3 -m backend --host ${HOST} --port "6666"