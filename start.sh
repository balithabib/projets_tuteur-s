#!/usr/bin/env bash
# Automation script features

# Root user
sudo -i
apt-get update

# Installer la bibliothèque de l'API Object Detection

### 1 - Installez les packages prérequis.
function installation_of_prerequisites() {
    apt install -y git python3
    # protobuf-compiler python-pil python-lxml python-pip python-dev
    # pip install
    # pip install Flask==0.12.2 WTForms==2.1 Flask_WTF==0.14.2 Werkzeug==0.12.2
    # pip install --upgrade https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-1.1.0-cp27-none-linux_x86_64.whl
}

### 2 - Installez la bibliothèque de l'API Object Detection.
function installation_of_detection_api() {
    cd /opt
    git clone https://github.com/tensorflow/models
    cd models/research
    # protoc object_detection/protos/*.proto --python_out=.
}

### 3 - Téléchargez les binaires de modèles pré-entraînés en exécutant les commandes suivantes.
function download_the_binaries_of_pre-trained_models() {
    MODELS=(ssd_mobilenet_v1_coco_11_06_2017, ssd_inception_v2_coco_11_06_2017, rfcn_resnet101_coco_11_06_2017, faster_rcnn_resnet101_coco_11_06_2017, faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017)
    mkdir -p /opt/graph_def
    cd /tmp
    for model in ${MODELS}
    do \
      curl -OL http://download.tensorflow.org/models/object_detection/$model.tar.gz
      tar -xzf $model.tar.gz $model/frozen_inference_graph.pb
      cp -a $model /opt/graph_def/
    done
    #rm -rf /tmp/*.tar.gz
}

### 4 - Choisissez un modèle pour l'application Web à utiliser. Par exemple, pour sélectionner faster_rcnn_resnet101_coco_11_06_2017, saisissez la commande suivante :
function choose_a_model() {
    MODEL_NAME=$1
    echo "The chosen model is ${MODEL_NAME}"
    ln -sf /opt/graph_def/$MODEL_NAME/frozen_inference_graph.pb /opt/graph_def/frozen_inference_graph.pb
}

# Installer et lancer l'application Web
function install_backend() {
    cd /opt
    git clone https://github.com/balithabib/projets_tuteurs.git
    pip3 install -r requirements.txt
}

# start ...
echo "Start ..."
installation_of_prerequisites
installation_of_detection_api
download_the_binaries_of_pre-trained_models
choose_a_model "faster_rcnn_resnet101_coco_11_06_2017"
install_backend
echo "End ..."
# Tester l'application Web

# Étapes suivantes
#* Apprenez à utiliser AI Platform pour entraîner votre modèle à réaliser des prédictions sur votre propre ensemble de données.
#* Apprenez à effectuer un apprentissage par transfert en utilisant votre propre ensemble de données avec l'API Object Detection.