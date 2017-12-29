FROM node
RUN npm i -g serve
ADD build /work/build
WORKDIR /work
CMD ["serve", "-s", "build", "-p", "80"]
