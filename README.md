# Vision and Detection

This is a brief summary (not exhaustive) of the main features from each release

## 1.0.0

1 - Install the prerequisite packages
2 - Install the Object Detection API library
3 - Download the pre-trained model binaries
4 - Choose a model for the web application
5 - Launch the web application

### Execution
    # In two different terminals or machine of course
    
    # Backend service launch
    # List of models : ssd_mobilenet_v1_coco_11_06_2017 ssd_inception_v2_coco_11_06_2017 rfcn_resnet101_coco_11_06_2017 faster_rcnn_resnet101_coco_11_06_2017 faster_rcnn_inception_resnet_v2_atrous_coco_11_06_2017
    ./start_backend.sh MODEL_PRETRAINED
    
    # Backend service launch
    ./start_client.sh HOST_BACKEND PORT_BACKEND
      


    # Note that we can launch the services directly with the two lines
    HOST=$(hostname -I | cut -d ' ' -f1)
    PORT=6666
    python3 -m backend --host ${HOST} --port ${PORT}
    python3 -m client --host ${HOST} --port ${PORT}




### Note and useful links

    La Reconnaissance Faciale sur un Raspberry Pi par alignement 3D du visage 
    ++ git (en python)
    ++ bibliography
    ===> https://medium.com/@appstud/la-reconnaissance-faciale-sur-un-raspberry-pi-par-alignement-3d-du-visage-5be3e66ce752
    
    
    TP : La Reconnaissance Faciale ***(je pense qu'il est lourd)
    ++ git (en python)
    ++ des explication sur le code
    ===> http://penseeartificielle.fr/tp-reconnaissance-faciale/
    
    
    
    
    non organisé
    
    ===> https://djgsi974.wordpress.com/2015/12/06/la-detection-de-visage-avec-opencv-et-le-suivi-des-visages-par-le-robot/
    
    ===> https://www.pyimagesearch.com/2018/09/26/install-opencv-4-on-your-raspberry-pi/
    
    https://www.pyimagesearch.com/opencv-tutorials-resources-guides/
    
    https://www.learnopencv.com/install-opencv-4-on-raspberry-pi/
    
    https://opendomotech.com/videosurveillance-avec-raspberry-pi-et-motion/



### What's next
* Learn how to use AI Platform to train your model to make predictions on your own dataset.
* Learn how to conduct transfer learning using your own dataset with the Object Detection API.
* Try out other Google Cloud features for yourself. Have a look at our tutorials.

