ARG OS_VER="devel"
FROM intel/dlstreamer:${OS_VER}

USER root

# Install system dependencies
RUN apt-get update; \
    apt-get install -y git \
        libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev

# Clone OpenVINO notebooks
RUN git clone -b main --depth 1 https://github.com/openvinotoolkit/openvino_notebooks.git

# Uninstall the current OpenCV module
RUN pip3 uninstall -y opencv-python

# Build OpenCV 4.7.0
RUN git clone https://github.com/opencv/opencv.git && \
    cd opencv && git checkout 4.7.0 && \
    mkdir build && cd build && \
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
    -D WITH_GSTREAMER=ON \
    -D BUILD_opencv_python3=yes \
	-D PYTHON_EXECUTABLE=$(which python3) .. && \
    make -j$(nproc) && \
    make install

USER dlstreamer

# Install additional python dependencies
RUN pip3 install jupyterlab \ 
    ipywidgets \
    ipywebrtc \
    pillow \
    matplotlib

# Download required models from the OpenVINO model zoo
RUN mkdir models && cd models && \
    omz_downloader --name human-pose-estimation-0001 --precisions FP32 && \
    omz_downloader --name person-vehicle-bike-detection-2004 --precisions FP32 && \
    omz_downloader --name person-attributes-recognition-crossroad-0230 --precisions FP32 && \
    omz_downloader --name vehicle-attributes-recognition-barrier-0039 --precisions FP32 && \
    omz_downloader --name face-detection-adas-0001 --precisions FP32 && \
    omz_downloader --name age-gender-recognition-retail-0013 --precisions FP32 && \
    omz_downloader --name emotions-recognition-retail-0003 --precisions FP32 && \
    omz_downloader --name landmarks-regression-retail-0009 --precisions FP32
