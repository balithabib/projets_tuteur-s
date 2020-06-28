#!/usr/bin/env bash
# Automation script features

# Installer la bibliothèque de l'API Object Detection

### 1 - Installez les packages prérequis.
function installation_of_prerequisites() {
    apt install -y git python3 protobuf-compiler python-pil python-lxml python-pip python-dev
    pip3 install -r requirements.txt
}

### 2 - Installez la bibliothèque de l'API Object Detection.
function installation_of_detection_api() {
    cd /opt
    git clone https://github.com/tensorflow/models
    cd models/research
    protoc object_detection/protos/*.proto --python_out=.
}

### 3 - Téléchargez les binaires de modèles pré-entraînés en exécutant les commandes suivantes.
function download_the_binaries_of_pre-trained_models() {
    mkdir -p /opt/graph_def && cd /opt/graph_def
    for model in ${MODELS}
    do
      curl -OL http://download.tensorflow.org/models/object_detection/$model.tar.gz
      tar -xzf $model.tar.gz $model/frozen_inference_graph.pb
    done
    rm -rf /opt/graph_def/*.tar.gz
}

### 4 - Choisissez un modèle pour l'application Web à utiliser. Par exemple, pour sélectionner faster_rcnn_resnet101_coco_11_06_2017, saisissez la commande suivante :
function choose_a_model() {
    MODEL_NAME=$1
    echo "The chosen model is ${MODEL_NAME}"
    ln -sf /opt/graph_def/$MODEL_NAME/frozen_inference_graph.pb /opt/graph_def/frozen_inference_graph.pb
}

function print(){
	echo -e $BACKGROUND_COLOR $1 $NO_COLOR
}

# Installer et lancer l'application Web

	BACKGROUND_COLOR="\033[31;42m"
	NO_COLOR="\033[0m"
MODELS="ssd_mobilenet_v1_coco_11_06_2017 ssd_inception_v2_coco_11_06_2017 rfcn_resnet101_coco_11_06_2017 faster_rcnn_resnet101_coco_11_06_2017 faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017"
HOST=$(hostname -I)

# start ...
print "Start ..."

print "Mise à jour des depots"
apt-get update

print "1 - Installez les packages prérequis"
installation_of_prerequisites

print "2 - Installez la bibliothèque de l'API Object Detection"
installation_of_detection_api

print "3 - Téléchargez les binaires de modèles pré-entraînés"
download_the_binaries_of_pre-trained_models

print "4 - Choisissez un modèle pour l'application Web à utiliser"
choose_a_model "faster_rcnn_resnet101_coco_11_06_2017"

# revenir vers le dossier du projet cd XXX
print "Tester l'application Web"
python3 -m backend HOST

# Étapes suivantes
#* Apprenez à utiliser AI Platform pour entraîner votre modèle à réaliser des prédictions sur votre propre ensemble de données.
#* Apprenez à effectuer un apprentissage par transfert en utilisant votre propre ensemble de données avec l'API Object Detection.
