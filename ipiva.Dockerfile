FROM nvcr.io/nvidia/deepstream:6.1-samples


ENV CUDA_VER=11.1 \
    CUDA_HOME=/usr/local/cuda-${CUDA_VER} \
    BASE_LIB_DIR="/usr/lib/x86_64-linux-gnu/" \
    GST_LIBS="-lgstreamer-1.0 -lgobject-2.0 -lglib-2.0" \
    GST_CFLAGS="-pthread -I/usr/include/gstreamer-1.0 -I/usr/include/glib-2.0 -I/usr/lib/x86_64-linux-gnu/glib-2.0/include" \
    TRT_LIB_PATH="/usr/lib/x86_64-linux-gnu" \
    TRT_INC_PATH="/usr/include/x86_64-linux-gnu" \
    NVIDIA_DRIVER_CAPABILITIES="compute,video,utility,display" \
    PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION='cpp' \
    CUDA_HOME=/usr/local/cuda-${CUDA_VER}/ \
    CUDA_TOOLKIT_ROOT_DIR=${CUDA_HOME} \
    LD_LIBRARY_PATH=${CUDA_HOME}/extras/CUPTI/lib64:$LD_LIBRARY_PATH \
    LIBRARY_PATH=${CUDA_HOME}/lib64:$LIBRARY_PATH \
    LD_LIBRARY_PATH=${CUDA_HOME}/lib64:$LD_LIBRARY_PATH \
    CFLAGS="-I$CUDA_HOME/include $CFLAGS"

WORKDIR /root/ipiva

RUN update-alternatives --install $BASE_LIB_DIR/gstreamer-1.0/deepstream deepstream-plugins /opt/nvidia/deepstream/deepstream-6.1/lib/gst-plugins 61 && \
    update-alternatives --install $BASE_LIB_DIR/libv4l/plugins/libcuvidv4l2_plugin.so deepstream-v4l2plugin /opt/nvidia/deepstream/deepstream-6.1/lib/libv4l/plugins/libcuvidv4l2_plugin.so 61 && \
    update-alternatives --install /usr/bin/deepstream-asr-app deepstream-asr-app /opt/nvidia/deepstream/deepstream-6.1/bin/deepstream-asr-app 61 && \
    update-alternatives --install /usr/bin/deepstream-asr-tts-app deepstream-asr-tts-app /opt/nvidia/deepstream/deepstream-6.1/bin/deepstream-asr-tts-app 61 && \
    update-alternatives --install /usr/bin/deepstream-avsync-app deepstream-avsync-app /opt/nvidia/deepstream/deepstream-6.1/bin/deepstream-avsync-app 61 && \
    update-alternatives --install $BASE_LIB_DIR/libv4l2.so.0.0.99999 deepstream-v4l2library /opt/nvidia/deepstream/deepstream-6.1/lib/libnvv4l2.so 61 && \
    update-alternatives --install $BASE_LIB_DIR/libv4lconvert.so.0.0.99999 deepstream-v4lconvert /opt/nvidia/deepstream/deepstream-6.1/lib/libnvv4lconvert.so 61 && \
    ldconfig && \
    rm -rf /home/*/.cache/gstreamer-1.0/ && \
    rm -rf /root/.cache/gstreamer-1.0/

RUN apt-get update && \
    apt-get install -y \
    vim \
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
