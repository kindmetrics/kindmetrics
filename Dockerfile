FROM crystallang/crystal:0.34.0-alpine-build AS build-env

RUN apk --no-cache add build-base nodejs yarn

RUN mkdir -p /app
WORKDIR /app

RUN git clone https://github.com/luckyframework/lucky_cli && cd lucky_cli && git checkout v0.21.0 && shards install && crystal build src/lucky.cr -o /bin/lucky && rm -Rf /app/lucky_cli

COPY . /app
RUN shards install

RUN yarn install
RUN yarn prod
RUN lucky build.release
RUN crystal build --release tasks.cr -o start_tasks
RUN crystal build --release ./src/start_worker.cr -o start_worker


FROM crystallang/crystal:0.34.0-alpine-build

RUN mkdir -p /app
WORKDIR /app

COPY --from=build-env /app/start_server /app/start_server
COPY --from=build-env /app/start_tasks /app/start_tasks
COPY --from=build-env /app/start_worker /app/start_worker
COPY --from=build-env /app/public /app/public
COPY --from=build-env /app/cache /app/cache
COPY --from=build-env /app/config/watch.yml /app/config/watch.yml

ENV PORT 5000
EXPOSE $PORT
CMD /app/start_server
