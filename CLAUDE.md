# cicd-demo

A learning project to understand CI/CD pipelines using a simple Go HTTP server.
The app is intentionally simple — the pipeline is the focus, not the app.

## About the user

- Tommy is new to Go, Docker, and CI/CD — explain concepts from scratch
- Prefers to walk through code and keywords before writing anything
- Learns by understanding the "why" behind each decision, not just the "what"
- Ask before writing code — walk through it first, then write

## Project Goal

Build a Go HTTP server and progressively add CI/CD infrastructure around it:
1. Go app + Dockerfile
2. CI pipeline (lint, build, test on every PR)
3. Docker build & push to GitHub Container Registry
4. Release workflow (tag → versioned release)
5. Reusable workflow / composite action

## Module

```
github.com/kpcrocks/cicd-demo
```

## Endpoints

| Route      | Response                        |
|------------|---------------------------------|
| GET /health  | `{"status":"OK"}`             |
| GET /hello   | `Hello World!` (plain text)   |
| GET /version | `{"version":"1.0.0"}`         |

## Run the server

```bash
go run main.go
```

## Run tests

```bash
go test ./...
```

## Key decisions

- Handlers are extracted as named functions (not inline in main) so they can be unit tested directly
- Uses only Go standard library — no external dependencies
- Tests use `net/http/httptest` to call handlers without starting a real server

## Current progress

- [x] Step 1: Install Go
- [x] Step 2: Set up project (go.mod)
- [x] Step 3: Write HTTP server (main.go)
- [x] Step 4: Write unit tests (main_test.go)
- [x] Step 5: Write Dockerfile
- [x] Step 6: Test Docker locally
- [ ] Step 7: Push to GitHub
