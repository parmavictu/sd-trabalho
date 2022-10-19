FROM node:12

USER root

RUN mkdir app

ADD src/ app/

WORKDIR app/

RUN ls

RUN echo -e "\n\n$(cat config/environment/.env)\n\n" 

EXPOSE ${PORT}

RUN npm install

# not using an execution list here so we get shell variable substitution
CMD /bin/bash -c 'npm run start'