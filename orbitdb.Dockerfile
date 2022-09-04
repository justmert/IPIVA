FROM node:16.17

WORKDIR /root/ipiva

RUN npm install -g orbit-db ipfs-http-client

COPY listener.js /root/ipiva/listener.js
COPY get.js /root/ipiva/get.js
COPY package.json /root/ipiva/package.json

RUN cd /root/ipiva && \
    npm install && \
    npm link orbit-db ipfs-http-client

CMD ["sh"]