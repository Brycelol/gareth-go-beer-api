FROM golang:1.23 AS build
WORKDIR /go/src
COPY go ./go
COPY main.go .
COPY go.mod .

ENV CGO_ENABLED=0
RUN go get -d -v ./...

RUN go build -a -installsuffix cgo -o swagger .

FROM scratch AS runtime
COPY --from=build /go/src/swagger ./
EXPOSE 8080/tcp
ENTRYPOINT ["./swagger"]
