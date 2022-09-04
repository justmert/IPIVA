FROM nvcr.io/nvidia/deepstream:6.1-samples

ARG CUDA_VER=11.1
ARG CUDA_HOME=/usr/local/cuda-$CUDA_VER
ARG BASE_LIB_DIR="/usr/lib/x86_64-linux-gnu/"
ENV DEBIAN_FRONTEND = noninteractive

ENV CUDA_VER=$CUDA_VER \
    CUDA_HOME=$CUDA_HOME \
    BASE_LIB_DIR="/usr/lib/x86_64-linux-gnu/" \
    GST_LIBS="-lgstreamer-1.0 -lgobject-2.0 -lglib-2.0" \
    GST_CFLAGS="-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include" \
    TRT_LIB_PATH="/usr/lib/x86_64-linux-gnu" \
    TRT_INC_PATH="/usr/include/x86_64-linux-gnu" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility,display" \
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION='cpp' \
    CUDA_TOOLKIT_ROOT_DIR=$CUDA_HOME \
    LIBRARY_PATH=$CUDA_HOME/lib64:$LIBRARY_PATH \
    LD_LIBRARY_PATH=$CUDA_HOME/lib64:/extras/CUPTI/lib64:$LD_LIBRARY_PATH \
    CFLAGS="-I$CUDA_HOME/include $CFLAGS"

WORKDIR /root/ipiva

RUN apt-get update && \
    apt-get install -y \
    libgstreamer-plugins-base1.0-dev \ 
    libgstreamer1.0-dev \ 
    libgstrtspserver-1.0-dev \
    libx11-dev \ 
    libjson-glib-dev \
    libyaml-cpp-dev \
    libglib2.0 \
    libglib2.0-dev \
    libjansson4 \
    libjansson-dev \
    libssl-dev

RUN cd /opt/nvidia/deepstream/deepstream && \
    git clone https://github.com/edenhill/librdkafka.git && \
    cd librdkafka && \
    git reset --hard 063a9ae7a65cebdf1cc128da9815c05f91a2a996 && \
    ./configure --enable-ssl && \
    make && \
    make install && \
    cp /usr/local/lib/librdkafka* /opt/nvidia/deepstream/deepstream/lib/ && \
    ldconfig

COPY src/ipiva-app /root/ipiva/ipiva-app
COPY configs /root/ipiva/configs

RUN update-alternatives --install /usr/lib/x86_64-linux-gnu/gstreamer-1.0/deepstream deepstream-plugins /opt/nvidia/deepstream/deepstream-6.1/lib/gst-plugins 61 && \
    update-alternatives --install /usr/lib/x86_64-linux-gnu/libv4l/plugins/libcuvidv4l2_plugin.so deepstream-v4l2plugin /opt/nvidia/deepstream/deepstream-6.1/lib/libv4l/plugins/libcuvidv4l2_plugin.so 61 && \
    update-alternatives --install /usr/lib/x86_64-linux-gnu/libv4l2.so.0.0.99999 deepstream-v4l2library /opt/nvidia/deepstream/deepstream-6.1/lib/libnvv4l2.so 61 && \
    update-alternatives --install /usr/lib/x86_64-linux-gnu/libv4lconvert.so.0.0.99999 deepstream-v4lconvert /opt/nvidia/deepstream/deepstream-6.1/lib/libnvv4lconvert.so 61 && \
    ldconfig && \
    rm -rf /home/*/.cache/gstreamer-1.0/ && \
    rm -rf /root/.cache/gstreamer-1.0/
    