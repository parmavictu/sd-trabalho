FROM node:12

RUN ls

RUN echo "\n\n\
#### ENVIRONMENT\n\
ENV=${ENV}\n\
DEBUG=${DEBUG}\n\
PORT=${PORT}\n\
NODE_ENV=${NODE_ENV}\n\
SRC_PATH=${SRC_PATH}\n\
TOKEN_AUTH=${TOKEN_AUTH}\n\n"

USER root

RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN mkdir app

ADD src/ app/

WORKDIR app/

RUN ls

RUN cat package.json | grep start

EXPOSE ${PORT}

RUN npm install

CMD /bin/bash -c 'npm run start'