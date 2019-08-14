FROM node:10.16-buster as builder

COPY matrix-dimension/ /home/node/matrix-dimension

RUN chown -R node:node /home/node/matrix-dimension

USER node

RUN cd /home/node/matrix-dimension && \
    npm install -D wd rimraf webpack webpack-command sqlite3 && \
    NODE_ENV=production npm run-script build:web && npm run-script build:app 


FROM node:10.16-buster-slim as app

ENV NODE_ENV=production

USER node

COPY --from=builder /home/node/matrix-dimension /opt/matrix-dimension

VOLUME ["/var/lib/matrix-dimension"]

EXPOSE 8184

WORKDIR /opt/matrix-dimension

CMD ["node","/opt/matrix-dimension/build/app/index.js"]
