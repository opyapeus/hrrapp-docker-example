FROM ubuntu:18.04 as build

RUN apt-get update && apt-get install -y \
    libpq-dev \
    curl

# REVIEW: fetch direct from github source
RUN curl -sSL https://raw.githubusercontent.com/commercialhaskell/stack/v2.1.3/etc/scripts/get-stack.sh | sh

WORKDIR /tmp/backend

COPY ./backend/stack.yaml stack.yaml
COPY ./backend/package.yaml package.yaml
COPY ./backend/src src
COPY ./backend/app app

ARG DB_HOST
ARG POSTGRES_USER
ARG POSTGRES_DB
ARG POSTGRES_PASSWORD

RUN stack setup
RUN stack build --only-dependencies
RUN stack build
RUN stack install --local-bin-path /sbin

# NOTE: https://www.fpcomplete.com/blog/2017/12/building-haskell-apps-with-docker
FROM ubuntu:18.04

RUN apt-get update && apt-get install -y \
    libpq-dev

COPY --from=build /sbin/backend-exe /sbin/backend-exe

CMD /sbin/backend-exe
