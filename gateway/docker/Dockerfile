FROM node:12

USER root

RUN apt-get update && \
    apt-get install -yq tzdata && \
    ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

RUN mkdir app

ADD src/ app/

WORKDIR app/

RUN ls

RUN echo -e "\n\n$(cat config/environment/.env)\n\n" 

EXPOSE ${PORT}

RUN npm install

# not using an execution list here so we get shell variable substitution
CMD /bin/bash -c 'npm run start'