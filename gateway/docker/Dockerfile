FROM node:12

ARG NODE_ENV
ARG DEBUG
ARG PORT
ARG TOKEN_AUTH
ARG COMMAND

ENV NODE_ENV=${NODE_ENV}
ENV DEBUG=${DEBUG}
ENV PORT=${PORT}
ENV TOKEN_AUTH=${TOKEN_AUTH}

RUN echo "\n\n\
#### ENVIRONMENT\n\
ENV=${ENV}\n\
DEBUG=${DEBUG}\n\
PORT=${PORT}\n\
COMMAND=${COMMAND}\n\
NODE_ENV=${NODE_ENV}\n\
TOKEN_AUTH=${TOKEN_AUTH}\n\n"

USER root

RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN mkdir app

ADD src/ app/

WORKDIR app/

RUN echo ${COMMAND} > script.sh

RUN ls

RUN cat script.sh

RUN cat package.json | grep start

RUN chmod 744 script.sh

EXPOSE ${PORT}

RUN npm install

# not using an execution list here so we get shell variable substitution
CMD /bin/bash -c 'npm run start'