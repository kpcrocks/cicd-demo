# cicd-demo

A simple Go HTTP server used as a learning project for CI/CD pipelines with GitHub Actions and Docker.

The app is intentionally minimal — the pipeline is the focus, not the app.

## Endpoints

| Route      | Response                  |
|------------|---------------------------|
| GET /health  | `{"status":"OK"}`       |
| GET /hello   | `Hello World!`          |
| GET /version | `{"version":"1.0.0"}`  |

## Run locally

```bash
go run main.go
```

## Run tests

```bash
go test ./...
```

## Build and run with Docker

```bash
docker build -t cicd-demo .
docker run -p 8080:8080 cicd-demo
```

## Pipeline

### CI — runs on every push and pull request to `main`

| Job | What it does |
|---|---|
| `lint` | Runs `go vet` to catch code issues |
| `test` | Runs the test suite |
| `docker-build` | Builds the Docker image to verify it compiles |
| `docker-push` | Pushes the image to ghcr.io as `:latest` (push to main only) |

`lint` and `test` run in parallel. `docker-build` waits for both to pass. `docker-push` waits for `docker-build`.

### Release — runs when a version tag is pushed

```bash
git tag v1.0.0
git push origin v1.0.0
```

This triggers the release workflow which:
1. Builds and pushes a versioned Docker image to ghcr.io as `:v1.0.0`
2. Creates a GitHub Release with auto-generated release notes

## Docker image

```
ghcr.io/kpcrocks/cicd-demo:latest     # latest push to main
ghcr.io/kpcrocks/cicd-demo:v1.0.0    # specific release
```
