sudo apt install docker-compose

docker-compose up -d

xhost +

docker run --name ipiva -it --gpus all --net=host --ipc=host -e NVIDIA_DRIVER_CAPABILITIES="compute,video,utility,display" -v /tmp/.X11-unix:/tmp/.X11-unix -e DISPLAY=$DISPLAY -v /home/openzeka/mert/ipiva:/root/ipiva ipiva:v0.1

./deepstream-test5-app -c configs/test5_config_file_src_infer.txt -p 1
/deepstream-test5-app -c configs/test5_dec_infer-resnet_tracker_sgie_tiled_display_int8.txt -p 0


docker run -it -v /home/openzeka/mert/ipiva:/root/ipiva --net=host --ipc=host --name orbitdb6 orbitdb:v0.3
npm link ipfs-http-client orbit-db

docker pull ipfs/kubo

prompt-sync
