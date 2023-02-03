FROM golang:alpine as build

WORKDIR /usr/src/app/
COPY ./go-test.go ./go.mod ./go.sum /usr/src/app/
RUN go build

FROM build
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/go-test /usr/src/app/go-test
ENTRYPOINT [ "/usr/src/app/go-test" ]
