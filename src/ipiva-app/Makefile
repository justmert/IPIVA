CUDA_VER?=
ifeq ($(CUDA_VER),)
  $(error "CUDA_VER is not set")
endif

APP:= ipiva-app

TARGET_DEVICE = $(shell gcc -dumpmachine | cut -f1 -d -)

NVDS_VERSION:=6.1
PROJECT_DIR:=/opt/nvidia/deepstream/deepstream-$(NVDS_VERSION)
PROJECT_SAMPLES:=$(PROJECT_DIR)/sources/apps/sample_apps
PROJECT_COMMON:=$(PROJECT_DIR)/sources/apps/apps-common

LIB_INSTALL_DIR?=$(PROJECT_DIR)/lib/
APP_INSTALL_DIR?=/root/ipiva/bin/

ifeq ($(TARGET_DEVICE),aarch64)
  CFLAGS:= -DPLATFORM_TEGRA
endif

SRCS:= ipiva_app_main.c ipiva_utc.c
SRCS+= $(PROJECT_SAMPLES)/deepstream-app/deepstream_app.c $(PROJECT_SAMPLES)/deepstream-app/deepstream_app_config_parser.c
SRCS+= $(PROJECT_SAMPLES)/deepstream-app/deepstream_app_config_parser_yaml.cpp
SRCS+= $(wildcard $(PROJECT_COMMON)/src/*.c)
SRCS+= $(wildcard $(PROJECT_COMMON)/src/deepstream-yaml/*.cpp)

INCS:= $(wildcard *.h)

PKGS:= gstreamer-1.0 gstreamer-video-1.0 x11 json-glib-1.0

OBJS:= $(SRCS:.c=.o)
OBJS:= $(OBJS:.cpp=.o)

CFLAGS+= -I$(PROJECT_COMMON)/includes \
		 -I$(PROJECT_DIR)/sources/includes \
		 -I$(PROJECT_SAMPLES)/deepstream-app/ -DDS_VERSION_MINOR=0 -DDS_VERSION_MAJOR=5 \
		 -I /usr/local/cuda-$(CUDA_VER)/include

LIBS:= -L/usr/local/cuda-$(CUDA_VER)/lib64/ -lcudart

LIBS+= -L$(LIB_INSTALL_DIR) -lnvdsgst_meta -lnvds_meta -lnvdsgst_helper -lnvdsgst_smartrecord -lnvds_utils -lnvds_msgbroker -lm \
       -lyaml-cpp -lcuda -lgstrtspserver-1.0 -ldl -Wl,-rpath,$(LIB_INSTALL_DIR)

CFLAGS+= $(shell pkg-config --cflags $(PKGS))

LIBS+= $(shell pkg-config --libs $(PKGS))

all: $(APP)

%.o: %.c $(INCS) Makefile
	$(CC) -c -o $@ $(CFLAGS) $<

%.o: %.cpp $(INCS) Makefile
	$(CXX) -c -o $@ $(CFLAGS) $<

$(APP): $(OBJS) Makefile
	$(CXX) -o $(APP) $(OBJS) $(LIBS)

install: $(APP)

clean:

