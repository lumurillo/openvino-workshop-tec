# openvino-workshop-tec
This repo has the OpenVINO and Deep Learning Streamer Workshop materials. In this workshop, you will learn how to leverage the power of Intel's OpenVINO toolkit and Deep Learning Streamer to accelerate and deploy deep learning models for various computer vision tasks.

## Getting started

### Prerequisites
* [Docker](https://docs.docker.com/engine/install/ubuntu/)

### Build the Docker image
```shell
docker compose build dlstreamer
```

### Start the dlstreamer service
```shell
docker compose up dlstreamer
```

The above command will generate a couple of URL that you can use to open the Jupyter web application on your browser.

### Run the Bash scripts
* If the _dlstreamer_ service is up an running, use the following command:
```shell
docker compose exec dlstreamer /bin/bash -c '/home/dlstreamer/dlstreamer_notebooks/scripts/<SCRIPT_FILENAME>'
```

Replace **<SCRIPT_FILENAME>** with the script that you want to run.

* If the _dlstreamer_ service is not running use:
```shell
docker compose run dlstreamer /bin/bash -c '/home/dlstreamer/dlstreamer_notebooks/scripts/<SCRIPT_FILENAME>'
```

## Project structure
This repo has the following directories and files:
* **scripts**: Bash scripts with GStreamer pipelines.
* **model_proc**: JSON file with models pre and post processing specifications.
* **utils**: OpenCV+GStreamer utility functions.
* **opencv_gst_example.ipynb**: Jupyter notebook with DLStreamer examples.
