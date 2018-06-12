FROM node as builder
ADD . /work

RUN cd /work && \
    npm i && \
    npm run build

FROM node
RUN npm i -g serve
COPY --from=builder  /work/build /work/build
WORKDIR /work
CMD ["serve", "-s", "build", "-l", "3000"]
