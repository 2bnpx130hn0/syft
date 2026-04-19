# Makefile for syft - Fork of anchore/syft

BINARY := syft
GO := go
GOFLAGS ?= -trimpath
LDFLAGS := -ldflags "-s -w"
BUILD_DIR := ./dist
MAIN_PACKAGE := ./cmd/syft

# Version info
VERSION ?= $(shell git describe --tags --always --dirty 2>/dev/null || echo "dev")
GIT_COMMIT ?= $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BUILD_DATE ?= $(shell date -u +"%Y-%m-%dT%H:%M:%SZ")

LD_VERSION_FLAGS := -ldflags "-s -w \
	-X github.com/anchore/syft/internal/version.version=$(VERSION) \
	-X github.com/anchore/syft/internal/version.gitCommit=$(GIT_COMMIT) \
	-X github.com/anchore/syft/internal/version.buildDate=$(BUILD_DATE)"

.DEFAULT_GOAL := build

.PHONY: all
all: clean build

## build: compile the binary
.PHONY: build
build:
	$(GO) build $(GOFLAGS) $(LD_VERSION_FLAGS) -o $(BUILD_DIR)/$(BINARY) $(MAIN_PACKAGE)

## run: run the binary
.PHONY: run
run:
	$(GO) run $(MAIN_PACKAGE)

## test: run all unit tests
.PHONY: test
test:
	$(GO) test ./... -v -race -timeout 300s

## test-unit: run unit tests only
.PHONY: test-unit
test-unit:
	$(GO) test ./... -short -race -timeout 120s

## test-integration: run integration tests
.PHONY: test-integration
test-integration:
	$(GO) test ./... -run Integration -race -timeout 300s

## lint: run golangci-lint
.PHONY: lint
lint:
	golangci-lint run ./...

## lint-fix: run golangci-lint with auto-fix
.PHONY: lint-fix
lint-fix:
	golangci-lint run --fix ./...

## format: format go source files
.PHONY: format
format:
	gofmt -s -w .
	goimports -w .

## tidy: tidy go modules
.PHONY: tidy
tidy:
	$(GO) mod tidy

## clean: remove build artifacts
.PHONY: clean
clean:
	rm -rf $(BUILD_DIR)

## snapshot: create a snapshot release with goreleaser
.PHONY: snapshot
snapshot:
	goreleaser release --snapshot --clean --skip-publish

## release: create a release with goreleaser
.PHONY: release
release:
	goreleaser release --clean

## tools: install required tools via binny
.PHONY: tools
tools:
	binny install

## help: display this help message
.PHONY: help
help:
	@echo "Usage: make [target]"
	@echo ""
	@sed -n 's/^##//p' $(MAKEFILE_LIST) | column -t -s ':' | sed -e 's/^/ /'
