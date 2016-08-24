FROM node:4.3.2

RUN npm install --global npm@3.7.5

ENV HOME=/home/app

COPY ./app/package.json $HOME/

WORKDIR $HOME
RUN npm install

COPY ./app $HOME

EXPOSE 8080

CMD ["node", "./bin/www"]