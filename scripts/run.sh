docker exec -d ipiva-app bash -c "/root/ipiva/ipiva-app/bin/ipiva-app -c /root/ipiva/configs/config_file_src_infer.yml"  && \
docker exec ipiva-orbit-db sh -c "node /root/ipiva/listener.js"
