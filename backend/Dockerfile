FROM golang:1.24-alpine AS builder
WORKDIR /src
COPY go.mod go.sum* ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -trimpath -o /out/erp-global-api ./cmd/api

FROM alpine:3.22
RUN addgroup -S app && adduser -S -G app app
COPY --from=builder /out/erp-global-api /usr/local/bin/erp-global-api
USER app
EXPOSE 8080
ENTRYPOINT ["/usr/local/bin/erp-global-api"]
