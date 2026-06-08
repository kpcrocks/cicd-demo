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

## Build and run with Docker

```bash
docker build -t cicd-demo .
docker run -p 8080:8080 cicd-demo
```

## Key decisions

- Handlers are extracted as named functions (not inline in main) so they can be unit tested directly
- Uses only Go standard library — no external dependencies
- Tests use `net/http/httptest` to call handlers without starting a real server

## GitHub

- Repo: https://github.com/kpcrocks/cicd-demo
- Branch: main
- Docker image name: cicd-demo

## Current progress

- [x] Step 1: Install Go
- [x] Step 2: Set up project (go.mod)
- [x] Step 3: Write HTTP server (main.go)
- [x] Step 4: Write unit tests (main_test.go)
- [x] Step 5: Write Dockerfile
- [x] Step 6: Test Docker locally
- [x] Step 7: Push to GitHub
- [x] Step 8: Write CI workflow (lint, test, docker build, docker push)
- [x] Step 9: Fix GITHUB_TOKEN permissions for ghcr.io push

## Day 2 complete. Day 3 complete.

## What was completed on Day 3

1. **Composite action** — `.github/actions/setup/action.yml` bundles Go setup into one reusable step. Checkout must stay outside it — the runner needs the repo on disk before it can load a local action.
2. **Release workflow** — `.github/workflows/release.yml` triggers on version tags (`v*`), pushes a versioned Docker image to ghcr.io, and creates a GitHub Release with auto-generated notes.
3. **README** — documents the project, endpoints, how to run locally, and how the pipeline works.

## Interview context

Tommy has applied for and has an upcoming interview for:
**Hardware Infrastructure & CI/CD Engineer at Efficient (San Jose / Pittsburgh / Austin)**

- Efficient builds ultra-low-power processors; their internal test platform is called **ATLAS** (hardware regression testing and performance profiling infrastructure)
- The role combines hardware test infrastructure ownership with CI/CD pipeline ownership across 3 teams
- This cicd-demo project is directly relevant — it demonstrates Go, Docker, GitHub Actions, release workflows, and composite actions

Interview prep answers are saved locally in `interview.txt` (gitignored). All four screening questions are drafted:
1. Tell me about yourself
2. Why this role / why this company
3. Challenging technical problem (USB enumeration story)
4. What are you weakest on in this JD

**First interview is a 30-minute intro/screening call.** Technical rounds follow.

When resuming interview prep: read `interview.txt` first, then help Tommy review and tighten the answers — especially Q1 which may be too long.

## Teaching approach

- Tommy is new to everything — always explain concepts before writing code
- Walk through what you're about to write first, then write it
- After writing, explain line by line if asked
- Keep a keywords.md file in this project — add new terms as they come up
- Update CLAUDE.md progress checklist as steps are completed
