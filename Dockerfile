FROM node:8-alpine
# node:8-stretch

WORKDIR /code/pelias

COPY download ./download

RUN echo 'http://dl-cdn.alpinelinux.org/alpine/v3.7/community' >> /etc/apk/repositories \
  && apk add --quiet --no-cache --virtual .gyp python make g++ git \
  && apk add --quiet --no-cache go bash curl \
# RUN wget --quiet https://storage.googleapis.com/golang/go1.9.2.linux-amd64.tar.gz \
#   && tar -xzf go1.9.2.linux-amd64.tar.gz \
#   && mv go /usr/local/go \
#   && rm go1.9.2.linux-amd64.tar.gz \
  && git clone https://github.com/pelias/schema.git \
  && git clone https://github.com/pelias/whosonfirst.git \
  && git clone https://github.com/pelias/openstreetmap.git \
  && git clone https://github.com/pelias/openaddresses.git \
  && git clone https://github.com/pelias/polylines.git \
  && git clone https://github.com/pelias/placeholder.git \
  && (cd ./download && yarn --prod) \
  && (cd ./schema && yarn --prod) \
  && (cd ./whosonfirst && yarn --prod) \
  && (cd ./openstreetmap && yarn --prod) \
  && (cd ./openaddresses && yarn --prod) \
  && (cd ./polylines && yarn --prod) \
  && (cd ./placeholder && yarn --prod) \
  && yarn cache clean \
  # && export GOPATH=$HOME/go \
  # && export PATH=$PATH:/usr/local/go/bin \
  # && export PATH=$PATH:$GOPATH/bin \
  && go get github.com/missinglink/pbf \
  && apk --quiet del .gyp



COPY download.sh build.sh import.sh command.sh ./

ENV PATH $PATH:/root/go/bin
ENV WOF_DIR '/data/whosonfirst/data'
ENV PLACEHOLDER_DATA '/data/placeholder'
ENV PELIAS_CONFIG '/code/pelias.json'

CMD ["bash", "command.sh"]