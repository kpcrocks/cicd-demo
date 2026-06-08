# Keywords

A running glossary of terms encountered during this project.

---

## Go

**package**
A folder of Go files that belong together. Every file declares which package it belongs to with `package <name>` at the top. Packages are how Go organizes and reuses code.

**module**
A collection of packages with a name and a version. Defined by `go.mod`. Think of it like a project — it tracks your code and its dependencies.

**go.mod**
The file that defines your module name and Go version. Similar to `package.json` in Node or `requirements.txt` in Python.

**struct**
A data type you define yourself that groups related fields together. Like a blueprint for an object. Example: `HealthResponse` has one field — `Status`.

**struct tag**
The backtick annotation on a struct field (e.g. `` `json:"status"` ``). Tells encoders/decoders how to name the field. Without it, JSON would use the capitalized Go field name.

**handler**
A function that receives an HTTP request and writes a response. In Go, every handler takes two arguments: a `ResponseWriter` (to write the response) and a `*Request` (the incoming request).

**binary**
The compiled output of your Go code — a single executable file with no dependencies. You run it directly. Go compiles to a binary, unlike Python or Node which need a runtime installed.

**standard library**
Packages that ship with Go — no installation needed. Examples used in this project: `net/http`, `encoding/json`, `log`.

**pointer (`*`)**
A reference to a value in memory rather than a copy of it. `*http.Request` means "a pointer to an http.Request." Used when you want a function to work with the original value, not a copy.

**`[]byte`**
A slice (list) of bytes. Strings in Go can't be written directly to a network connection — they need to be converted to bytes first. `[]byte("Hello")` does that conversion.

---

## Testing

**unit test**
A test that checks one small piece of code in isolation — no network, no database, no server. Fast and reliable. Your `main_test.go` contains unit tests.

**integration test**
A test that checks how multiple pieces work together — e.g. starting a real server and making a real HTTP request. Slower and more fragile than unit tests.

**`testing.T`**
The type passed into every test function. Gives you methods like `t.Errorf()` to report failures without stopping the test, or `t.Fatalf()` to report and stop immediately.

**`httptest`**
A Go standard library package (`net/http/httptest`) that lets you test HTTP handlers without starting a real server. Provides `NewRequest` and `NewRecorder`.

**`httptest.NewRequest`**
Creates a fake incoming HTTP request. Takes a method (`GET`, `POST`, etc.), a URL path, and an optional body.

**`httptest.NewRecorder`**
Creates a fake `ResponseWriter` that records everything the handler writes — status code, headers, body. You inspect it after calling the handler.

**Arrange / Act / Assert**
The three steps of a test: set up inputs, call the real code, check the output.

---

## Docker

**Docker image**
A frozen, packaged snapshot of your app and its environment. You build it once and run it anywhere. Ships as a single artifact.

**container**
A running instance of a Docker image. Like a lightweight virtual machine — isolated from the rest of your system.

**Dockerfile**
A recipe for building a Docker image. A list of instructions that Docker executes top to bottom.

**multi-stage build**
A Dockerfile technique that uses multiple `FROM` stages. Earlier stages can compile or build things; only the final stage ends up in the image. Used to keep the final image small.

**alpine**
A minimal Linux distribution (~5MB). Popular as a base image in Docker because it's tiny and has a small attack surface compared to full distros like Ubuntu.

**toolchain**
Everything needed to compile code — compiler, standard library, build tools. In Go, the toolchain is large (~600MB) but only needed at build time, not runtime.

**base image**
The starting point for a Docker stage, specified with `FROM`. Everything you do in that stage builds on top of it.

---

## CI/CD

**CI (Continuous Integration)**
Automatically running checks (tests, linting, builds) every time code is pushed. Catches bugs before they reach production.

**CD (Continuous Delivery/Deployment)**
Automatically packaging and shipping code after CI passes. Delivers the tested artifact to a registry or server.

**pipeline**
The sequence of automated steps that run on every push — lint, test, build, deploy. Defined in a config file (e.g. GitHub Actions YAML).

**GitHub Actions**
GitHub's built-in CI/CD tool. You define workflows in `.github/workflows/`. Triggered by events like pushing code or opening a pull request.

**artifact**
The output of a build step that gets passed along the pipeline. In this project, the Docker image is the artifact.

**registry**
A storage warehouse for Docker images. Like GitHub but for images. GitHub Container Registry (ghcr.io) is where your pipeline will push images to in a later step.

**`docker build`**
The command that reads your Dockerfile and builds an image from it. `-t cicd-demo` tags (names) the image so you can reference it later.

**`docker run`**
The command that starts a container from an image. `-p 8080:8080` maps port 8080 on your laptop to port 8080 inside the container.

**Docker Desktop**
The app you install on your laptop to run Docker locally. Gives you the `docker` command and a UI to manage containers and images.

---

## GitHub Actions

**workflow**
A `.yml` file in `.github/workflows/` that defines automation. GitHub reads it and runs it when the trigger event happens.

**trigger (`on:`)**
The event that starts a workflow. Common triggers: `push` (code pushed to a branch) and `pull_request` (a PR opened or updated).

**job**
A group of steps that runs on one isolated runner. Jobs run in parallel by default unless you declare dependencies with `needs`.

**runner**
A fresh virtual machine GitHub boots for each job. Starts empty every time — no code, no tools — you install what you need in the steps. Uses `ubuntu-latest` for Linux.

**step**
A single unit of work inside a job. Either a shell command (`run:`) or a pre-built Action (`uses:`).

**Action**
A reusable plugin you pull into a step with `uses:`. Examples: `actions/checkout` (clones your repo), `actions/setup-go` (installs Go), `docker/login-action` (logs into a registry).

**`uses`**
Runs a pre-built Action in a step. Example: `uses: actions/checkout@v4`.

**`run`**
Runs a raw shell command on the runner. Example: `run: go test ./...`.

**`needs`**
Declares a dependency between jobs. A job with `needs: [lint, test]` won't start until both lint and test finish successfully.

**`if`**
A condition that controls whether a job runs at all. Example: `if: github.event_name == 'push' && github.ref == 'refs/heads/main'` skips the job on PRs.

**`permissions`**
Explicitly grants the `GITHUB_TOKEN` access it needs for a job. By default the token has minimal permissions — you add `packages: write` to allow pushing Docker images.

**`GITHUB_TOKEN`**
A temporary token GitHub auto-creates for each workflow run. Has limited permissions by default (least privilege). Used to authenticate with GitHub services like ghcr.io.

**ghcr.io (GitHub Container Registry)**
GitHub's built-in Docker image registry. Images pushed here are stored under `ghcr.io/<owner>/<repo>:tag`. Access control follows your repo's visibility settings.

**cache key**
A fingerprint used to identify a cache. For Go modules, the cache key is based on `go.sum` — if the file hasn't changed, the cached modules are reused instead of re-downloaded.

**`go.sum`**
A file Go maintains that lists every external dependency and its exact version hash. Used as the cache key fingerprint. Only exists if your project has external dependencies.

**least privilege**
A security principle: give a token or process only the permissions it actually needs, nothing more. GitHub Actions follows this — `GITHUB_TOKEN` starts minimal and you opt in to more.

**parallel jobs**
Jobs that run at the same time because they have no `needs` dependency between them. Lint and test run in parallel — each gets its own runner and they race independently.

**PR (pull request)**
A proposal to merge one branch into another. Opens a GitHub page showing the diff. Reviewers leave comments or request changes. The author pushes more commits to the same branch to address feedback. Merged when approved.

**cache hit / cache miss**
A cache hit means the key matched and the cached data was restored. A cache miss means no match was found and everything was downloaded fresh. The first run is always a miss; subsequent runs are hits if nothing changed.

---

## Git

**git tag**
A human-readable label attached to a specific commit. Unlike a branch, a tag doesn't move — it permanently marks that point in history. Used to name releases (e.g. `v1.0.0`).

**semantic versioning (semver)**
A versioning convention: `major.minor.patch`. Patch = bug fix, minor = new feature (backwards compatible), major = breaking change. Example: `v1.2.3`.

**`git tag v1.0.0`**
Creates a tag locally on your current commit. Does not push it to GitHub — that requires a separate command.

**`git push origin v1.0.0`**
Pushes just the tag to GitHub. Completely separate from pushing commits. This is what triggers the release workflow.

---

## GitHub Actions (continued)

**composite action**
A reusable bundle of steps stored in `.github/actions/<name>/action.yml`. Jobs reference it with `uses: ./.github/actions/<name>`. Eliminates copy-paste duplication across jobs.

**`using: composite`**
The declaration inside an `action.yml` that marks it as a composite action (as opposed to a Docker or JavaScript action).

**`github.ref_name`**
A built-in GitHub Actions variable that contains the name of the branch or tag that triggered the workflow. When triggered by a tag push, it equals the tag name (e.g. `v1.0.0`).

**`contents: write`**
A permission that allows a workflow to create GitHub Releases, write to the repo, etc. Must be explicitly granted — GitHub tokens start with minimal permissions.

**GitHub Release**
A page on GitHub under the "Releases" tab tied to a specific tag. Shows the version, release notes, and any attached assets. Created automatically by the release workflow using `softprops/action-gh-release`.

**`generate_release_notes: true`**
A setting on the `softprops/action-gh-release` action that automatically pulls commit messages since the last tag and uses them as the release notes. No manual writing needed.
