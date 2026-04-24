# Build stage
FROM registry.access.redhat.com/ubi9/go-toolset:latest@sha256:75ecb48dfaec6655bd589091902e3b9328c300befba34cb06fc5e7323099e17d AS builder

ENV GOTOOLCHAIN=auto

# Copy go mod files
COPY go.mod go.mod

# Download dependencies
RUN go mod download

# Copy source code
COPY main.go main.go

# Build the application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -a -o go-simple-server .

# Runtime stage
FROM quay.io/redhat-user-workloads/qwan-tenant/ubi@sha256:2617a48f1f4776ae3ba2e03efe7d64868163578547eeee0296892fa89d980132

WORKDIR /

# Copy the binary from builder
COPY --from=builder /opt/app-root/src/go-simple-server .

# Expose port
EXPOSE 8080

# Run the application
CMD ["./go-simple-server"]
