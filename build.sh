docker rmi ipiva-app:latest || true && \
docker rmi ipiva-orbit-db:latest || true && \
docker rmi ipiva-ipfs:latest || true && \
docker build -f ipiva.Dockerfile -t ipiva-app:latest . &&
docker build -f orbitdb.Dockerfile -t ipiva-orbit-db:latest . && \
docker build -f ipfs.Dockerfile -t ipiva-ipfs:latest . && \
docker-compose up -d ipiva-ipfs && \
sleep 5  && \
docker exec ipiva-ipfs sh -c "ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '[\"http://0.0.0.0:5001\", \"http://localhost:3000\", \"http://127.0.0.1:5001\", \"https://webui.ipfs.io\"]'" && \
docker exec ipiva-ipfs sh -c "ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '[\"*\"]'" && \
docker-compose stop ipiva-ipfs && \
docker compose up -d ipiva-app && \
sleep 5  && \
docker exec ipiva-app bash -c "cd /root/ipiva/ipiva-app && \
                            chmod +x /root/ipiva/ipiva-app/build.sh && \
                            ./build.sh" && \
docker-compose stop ipiva-app  && \
xhost + && \
docker-compose up -d --no-recreate


