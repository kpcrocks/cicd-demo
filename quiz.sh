#!/bin/bash

# Flashcard quiz — term shown first, definition revealed on enter
# Run with: bash quiz.sh
# Optional filter by category: bash quiz.sh go | bash quiz.sh docker | bash quiz.sh actions | bash quiz.sh testing | bash quiz.sh cicd

FILTER="${1,,}"

declare -a TERMS
declare -a DEFS
declare -a CATS

add() {
  CATS+=("$1")
  TERMS+=("$2")
  DEFS+=("$3")
}

# Go
add "go" "package" "A folder of Go files that belong together. Every file declares which package it belongs to with 'package <name>' at the top. Packages are how Go organizes and reuses code."
add "go" "module" "A collection of packages with a name and a version. Defined by go.mod. Think of it like a project — it tracks your code and its dependencies."
add "go" "go.mod" "The file that defines your module name and Go version. Similar to package.json in Node or requirements.txt in Python."
add "go" "struct" "A data type you define yourself that groups related fields together. Like a blueprint for an object."
add "go" "struct tag" "The backtick annotation on a struct field (e.g. \`json:\"status\"\`). Tells encoders/decoders how to name the field. Without it, JSON uses the capitalized Go field name."
add "go" "handler" "A function that receives an HTTP request and writes a response. Takes two arguments: a ResponseWriter (to write the response) and a *Request (the incoming request)."
add "go" "binary" "The compiled output of your Go code — a single executable file with no dependencies. Go compiles to a binary, unlike Python or Node which need a runtime installed."
add "go" "standard library" "Packages that ship with Go — no installation needed. Examples: net/http, encoding/json, log."
add "go" "pointer (*)" "A reference to a value in memory rather than a copy of it. *http.Request means a pointer to an http.Request."
add "go" "[]byte" "A slice (list) of bytes. Strings in Go can't be written directly to a network connection — they need to be converted to bytes first."

# Testing
add "testing" "unit test" "A test that checks one small piece of code in isolation — no network, no database, no server. Fast and reliable."
add "testing" "integration test" "A test that checks how multiple pieces work together — e.g. starting a real server and making a real HTTP request. Slower and more fragile than unit tests."
add "testing" "testing.T" "The type passed into every test function. Gives you t.Errorf() to report failures without stopping, or t.Fatalf() to report and stop immediately."
add "testing" "httptest" "A Go standard library package that lets you test HTTP handlers without starting a real server. Provides NewRequest and NewRecorder."
add "testing" "httptest.NewRequest" "Creates a fake incoming HTTP request. Takes a method (GET, POST, etc.), a URL path, and an optional body."
add "testing" "httptest.NewRecorder" "Creates a fake ResponseWriter that records everything the handler writes — status code, headers, body. You inspect it after calling the handler."
add "testing" "Arrange / Act / Assert" "The three steps of a test: set up inputs, call the real code, check the output."

# Docker
add "docker" "Docker image" "A frozen, packaged snapshot of your app and its environment. You build it once and run it anywhere."
add "docker" "container" "A running instance of a Docker image. Like a lightweight virtual machine — isolated from the rest of your system."
add "docker" "Dockerfile" "A recipe for building a Docker image. A list of instructions that Docker executes top to bottom."
add "docker" "multi-stage build" "A Dockerfile technique using multiple FROM stages. Earlier stages compile things; only the final stage ends up in the image. Keeps the final image small."
add "docker" "alpine" "A minimal Linux distribution (~5MB). Popular as a Docker base image because it's tiny and has a small attack surface."
add "docker" "toolchain" "Everything needed to compile code — compiler, standard library, build tools. In Go it's ~600MB but only needed at build time, not runtime."
add "docker" "base image" "The starting point for a Docker stage, specified with FROM. Everything you do in that stage builds on top of it."
add "docker" "docker build" "The command that reads your Dockerfile and builds an image. -t cicd-demo tags (names) the image so you can reference it later."
add "docker" "docker run" "The command that starts a container from an image. -p 8080:8080 maps port 8080 on your laptop to port 8080 inside the container."
add "docker" "Docker Desktop" "The app you install on your laptop to run Docker locally. Gives you the docker command and a UI to manage containers and images."

# CI/CD
add "cicd" "CI (Continuous Integration)" "Automatically running checks (tests, linting, builds) every time code is pushed. Catches bugs before they reach production."
add "cicd" "CD (Continuous Delivery/Deployment)" "Automatically packaging and shipping code after CI passes. Delivers the tested artifact to a registry or server."
add "cicd" "pipeline" "The sequence of automated steps that run on every push — lint, test, build, deploy. Defined in a config file like a GitHub Actions YAML."
add "cicd" "artifact" "The output of a build step passed along the pipeline. In this project, the Docker image is the artifact."
add "cicd" "registry" "A storage warehouse for Docker images. Like GitHub but for images. ghcr.io is GitHub's built-in registry."

# GitHub Actions
add "actions" "workflow" "A .yml file in .github/workflows/ that defines automation. GitHub reads it and runs it when the trigger event happens."
add "actions" "trigger (on:)" "The event that starts a workflow. Common triggers: push (code pushed to a branch) and pull_request (a PR opened or updated)."
add "actions" "job" "A group of steps that runs on one isolated runner. Jobs run in parallel by default unless you declare dependencies with needs."
add "actions" "runner" "A fresh virtual machine GitHub boots for each job. Starts empty every time — no code, no tools. You install what you need in the steps."
add "actions" "step" "A single unit of work inside a job. Either a shell command (run:) or a pre-built Action (uses:)."
add "actions" "Action" "A reusable plugin you pull into a step with uses:. Examples: actions/checkout, actions/setup-go, docker/login-action."
add "actions" "uses" "Runs a pre-built Action in a step. Example: uses: actions/checkout@v4."
add "actions" "run" "Runs a raw shell command on the runner. Example: run: go test ./..."
add "actions" "needs" "Declares a dependency between jobs. A job with needs: [lint, test] won't start until both finish successfully."
add "actions" "if" "A condition that controls whether a job runs at all. Used to skip docker-push on PRs and only run it on pushes to main."
add "actions" "permissions" "Explicitly grants the GITHUB_TOKEN access it needs for a job. Add packages: write to allow pushing Docker images to ghcr.io."
add "actions" "GITHUB_TOKEN" "A temporary token GitHub auto-creates for each workflow run. Has minimal permissions by default (least privilege)."
add "actions" "ghcr.io" "GitHub Container Registry — GitHub's built-in Docker image registry. Images stored as ghcr.io/<owner>/<repo>:tag."
add "actions" "cache key" "A fingerprint used to identify a cache. For Go modules it's based on go.sum — if unchanged, cached modules are reused."
add "actions" "go.sum" "A file Go maintains listing every external dependency and its exact version hash. Used as the cache key fingerprint."
add "actions" "least privilege" "A security principle: give a token only the permissions it actually needs, nothing more."
add "actions" "parallel jobs" "Jobs that run at the same time because they have no needs dependency. Lint and test run in parallel."
add "actions" "PR (pull request)" "A proposal to merge one branch into another. Reviewers comment or request changes. Author pushes more commits to the same branch. Merged when approved."
add "actions" "cache hit / cache miss" "Cache hit: key matched, cached data restored. Cache miss: no match, downloaded fresh. First run is always a miss."

# --- build filtered list ---
FILTERED_TERMS=()
FILTERED_DEFS=()

for i in "${!CATS[@]}"; do
  if [[ -z "$FILTER" || "${CATS[$i]}" == "$FILTER" ]]; then
    FILTERED_TERMS+=("${TERMS[$i]}")
    FILTERED_DEFS+=("${DEFS[$i]}")
  fi
done

TOTAL=${#FILTERED_TERMS[@]}

if [[ $TOTAL -eq 0 ]]; then
  echo "No cards found for category: $FILTER"
  echo "Available: go, testing, docker, cicd, actions"
  exit 1
fi

# --- shuffle ---
shuffle() {
  local arr_terms=("${FILTERED_TERMS[@]}")
  local arr_defs=("${FILTERED_DEFS[@]}")
  for ((i=TOTAL-1; i>0; i--)); do
    j=$((RANDOM % (i+1)))
    tmp_t="${arr_terms[$i]}"; arr_terms[$i]="${arr_terms[$j]}"; arr_terms[$j]="$tmp_t"
    tmp_d="${arr_defs[$i]}"; arr_defs[$i]="${arr_defs[$j]}"; arr_defs[$j]="$tmp_d"
  done
  FILTERED_TERMS=("${arr_terms[@]}")
  FILTERED_DEFS=("${arr_defs[@]}")
}

shuffle

# --- quiz loop ---
clear
CATEGORY_LABEL="${FILTER:-all categories}"
echo "========================================"
echo "  CI/CD Flashcards — $CATEGORY_LABEL"
echo "  $TOTAL cards | press enter to reveal"
echo "  type 's' to skip | 'q' to quit"
echo "========================================"
echo ""

CORRECT=0
SKIPPED=0

for i in "${!FILTERED_TERMS[@]}"; do
  NUM=$((i+1))
  echo "[$NUM/$TOTAL]  ${FILTERED_TERMS[$i]}"
  echo ""
  read -r input

  if [[ "$input" == "q" ]]; then
    echo ""
    echo "Quit early. $CORRECT/$NUM correct so far."
    exit 0
  elif [[ "$input" == "s" ]]; then
    SKIPPED=$((SKIPPED+1))
    echo "  → ${FILTERED_DEFS[$i]}"
    echo "  (skipped)"
  else
    echo "  → ${FILTERED_DEFS[$i]}"
    echo ""
    read -rp "  Did you get it? (y/n): " result
    if [[ "$result" == "y" ]]; then
      CORRECT=$((CORRECT+1))
      echo "  Nice."
    else
      echo "  Review it again later."
    fi
  fi

  echo ""
  echo "----------------------------------------"
  echo ""
done

echo "========================================"
echo "  Done. Score: $CORRECT/$((TOTAL-SKIPPED)) answered"
if [[ $SKIPPED -gt 0 ]]; then
  echo "  Skipped: $SKIPPED"
fi
echo "========================================"
