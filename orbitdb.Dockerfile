FROM node:16.17

WORKDIR /root/ipiva

RUN npm install -g orbit-db ipfs-http-client

COPY brokers/listener.js /root/ipiva/listener.js
COPY brokers/get.js /root/ipiva/get.js
COPY brokers/package.json /root/ipiva/package.json

RUN cd /root/ipiva && \
    npm install && \
    npm link orbit-db ipfs-http-client

CMD ["sh"]