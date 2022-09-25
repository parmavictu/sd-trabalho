## Build
FROM golang:1.18-buster AS build

WORKDIR /app


COPY . ./

RUN go mod download

RUN go build   -o /trabalho-sd-api


EXPOSE 5000

CMD ["/trabalho-sd-api"]