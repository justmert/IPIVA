FROM ipfs/kubo:latest

CMD ["daemon", "--migrate=true", "--enable-pubsub-experiment", "--enable-namesys-pubsub"]
