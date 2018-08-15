FROM maven:alpine

RUN apk add --update --no-cache nodejs nodejs-npm && \
 rm -rf /tmp/* && \
 npm -g config set user root && \
 npm install -g npm@latest

EXPOSE 3000
