FROM node:18-alpine as install

WORKDIR /usr/src/app/
COPY ./package.json /usr/src/app/
RUN npm install

FROM install
WORKDIR /usr/src/app
COPY ./js-test.js /usr/src/app/
ENTRYPOINT [ "node", "js-test.js" ]
