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
    ./start_backend.sh HOST_BACKEND MODEL_PRETRAINED
    
    # Client service launch
    ./start_client.sh HOST_BACKEND
      


    # Note that we can launch the services directly with the two lines
    HOST=$(hostname -I | cut -d ' ' -f1)
    PORT=6666
    python3 -m backend --host ${HOST} --port ${PORT}
    python3 -m client --host ${HOST} --port ${PORT}

### What's next
* Learn how to use AI Platform to train your model to make predictions on your own dataset.
* Learn how to conduct transfer learning using your own dataset with the Object Detection API.
* Try out other Google Cloud features for yourself. Have a look at our tutorials.

