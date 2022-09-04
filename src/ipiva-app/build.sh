#! /bin/bash

make && \
make install && \
rm ipiva_app_main.o || true && \
rm ipiva_utc.o || true
mkdir bin && \
mv ipiva-app bin/