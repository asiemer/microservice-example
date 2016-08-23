FROM node:4.3.2

RUN npm install --global npm@3.7.5

ENV HOME=/home/app

COPY package.json $HOME/weather/

WORKDIR $HOME/weather
RUN npm install

COPY . $HOME/weather

CMD ["node", "index.js"]