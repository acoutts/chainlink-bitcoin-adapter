FROM golang:1.12-alpine as builder

ENV GO111MODULE=on

RUN apk add --no-cache make curl git gcc musl-dev linux-headers ca-certificates

WORKDIR /go/src/github.com/acoutts/chainlink-bitcoin-adapter
ADD . .
RUN make build
RUN make install
# COPY ./chainlink-bitcoin-adapter /usr/local/bin/

EXPOSE 8080
ENTRYPOINT ["chainlink-bitcoin-adapter"]
