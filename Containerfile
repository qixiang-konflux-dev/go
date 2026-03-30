# Build stage
FROM registry.access.redhat.com/ubi9/go-toolset:latest@sha256:7b1828de52c3bac600a71b81996bf748776a456181a45e2b329b39702cf6486f AS builder

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
FROM quay.io/redhat-user-workloads/qwan-tenant/ubi@sha256:b170c6f0987dfe1c3dad18bc696afdcf6fa3eb7c65a5a48357ee541496251036

WORKDIR /

# Copy the binary from builder
COPY --from=builder /opt/app-root/src/go-simple-server .

# Expose port
EXPOSE 8080

# Run the application
CMD ["./go-simple-server"]
