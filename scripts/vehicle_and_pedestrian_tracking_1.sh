#!/bin/bash

# general
DEVICE="AUTO"

# paths
MODELS_PATH="/home/dlstreamer/models"
MODELS_PROC_PATH="/home/dlstreamer/dlstreamer_notebooks/model_proc"

# Models
MODEL_1="person-vehicle-bike-detection-2004"
MODEL_2="person-attributes-recognition-crossroad-0230"
MODEL_3="vehicle-attributes-recognition-barrier-0039"

# Model proc
DETECTION_MODEL_PROC="${MODELS_PROC_PATH}/${MODEL_1}.json"
PERSON_CLASSIFICATION_MODEL_PROC="${MODELS_PROC_PATH}/${MODEL_2}.json"
VEHICLE_CLASSIFICATION_MODEL_PROC="${MODELS_PROC_PATH}/${MODEL_3}.json"

# Model paths
DETECTION_MODEL="${MODELS_PATH}/intel/${MODEL_1}/FP32/${MODEL_1}.xml"
PERSON_CLASSIFICATION_MODEL="${MODELS_PATH}/intel/${MODEL_2}/FP32/${MODEL_2}.xml"
VEHICLE_CLASSIFICATION_MODEL="${MODELS_PATH}/intel/${MODEL_3}/FP32/${MODEL_3}.xml"

# Tracker
TRACKING_TYPE="short-term-imageless" # Object tracking type, valid values: short-term-imageless, zero-term, zero-term-imageless

# Detector
DETECTION_INTERVAL=1

# Classifier
RECLASSIFY_INTERVAL=1 # Reclassify interval (run classification every 10th frame)

# Input
INPUT="https://github.com/intel-iot-devkit/sample-videos/raw/master/person-bicycle-car-detection.mp4"

PIPELINE="gst-launch-1.0 \
  urisourcebin buffer-size=4096 uri=${INPUT} ! decodebin ! queue ! \
  gvadetect model=$DETECTION_MODEL \
            model-proc=$DETECTION_MODEL_PROC \
            inference-interval=${DETECTION_INTERVAL} \
            threshold=0.4 \
            device=${DEVICE} ! \
  queue ! \
  gvaclassify model=$PERSON_CLASSIFICATION_MODEL \
              model-proc=$PERSON_CLASSIFICATION_MODEL_PROC \
              reclassify-interval=${RECLASSIFY_INTERVAL} \
              device=${DEVICE} \
              object-class=person ! \
  queue ! \
  gvaclassify model=$VEHICLE_CLASSIFICATION_MODEL \
              model-proc=$VEHICLE_CLASSIFICATION_MODEL_PROC \
              reclassify-interval=${RECLASSIFY_INTERVAL} \
              device=${DEVICE} \
              object-class=vehicle ! \
  queue ! \
  gvawatermark ! videoconvert ! gvafpscounter ! fakesink sync=true"

echo ${PIPELINE}
eval $PIPELINE
