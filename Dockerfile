FROM crystallang/crystal:0.34.0-alpine-build AS build-env

RUN apk --no-cache add build-base libgit2 git nodejs yarn libgit2-dev

RUN mkdir -p /app
WORKDIR /app

RUN git clone https://github.com/luckyframework/lucky_cli && cd lucky_cli && git checkout v0.21.0 && shards install && crystal build src/lucky.cr -o /bin/lucky && rm -Rf /app/lucky_cli

COPY . /app
RUN shards install

RUN yarn install
RUN yarn prod
RUN lucky build.release


FROM crystallang/crystal:0.34.0-alpine-build

RUN mkdir -p /app
WORKDIR /app

RUN apk --no-cache add libgit2-dev libgit2 git

COPY --from=build-env /app/start_server /app/start_server
COPY --from=build-env /app/public /app/public

ENV PORT 5000
EXPOSE $PORT
CMD /app/start_server
