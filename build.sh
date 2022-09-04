echo "Deleting IPIVA images..."
docker rmi ipiva-app:latest || true && \
docker rmi ipiva-orbit-db:latest || true && \
docker rmi ipiva-ipfs:latest || true

echo "Building IPIVA Dockerfiles..."
docker build -f ipiva.Dockerfile -t ipiva-app:latest . &&
docker build -f orbitdb.Dockerfile -t ipiva-orbit-db:latest . && \
docker build -f ipfs.Dockerfile -t ipiva-ipfs:latest

echo "Configuring IPIVA IPFS settings..."
docker-compose up -d ipiva-ipfs && \
sleep 3  && \
docker exec ipiva-ipfs sh -c "ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '[\"http://0.0.0.0:5001\", \"http://localhost:3000\", \"http://127.0.0.1:5001\", \"https://webui.ipfs.io\"]'" && \
docker exec ipiva-ipfs sh -c "ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '[\"*\"]'" && \
docker-compose stop ipiva-ipfs && \

echo "Building IPIVA-APP..."
docker compose up -d ipiva-app && \
sleep 3  && \
docker exec ipiva-app bash -c "cd /root/ipiva/ipiva-app && \
                            chmod +x /root/ipiva/ipiva-app/build.sh && \
                            ./build.sh" && \
docker-compose stop ipiva-app  && \
xhost + && \

echo "Starting all IPIVA containers..."
docker-compose up -d --no-recreate
echo "Done! Please execute run.sh under the scripts directory."


