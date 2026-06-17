package main

import (
	"encoding/json"
	"log/slog"
	"net/http"
	"os"
	"sync/atomic"
)

// request counters — incremented atomically so concurrent requests don't race
var (
	healthCount  atomic.Int64
	helloCount   atomic.Int64
	versionCount atomic.Int64
)

type HealthResponse struct {
	Status string `json:"status"`
}

type VersionResponse struct {
	Version string `json:"version"`
}

type MetricsResponse struct {
	Health  int64 `json:"health"`
	Hello   int64 `json:"hello"`
	Version int64 `json:"version"`
}

func healthHandler(w http.ResponseWriter, r *http.Request) {
	healthCount.Add(1)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(HealthResponse{Status: "OK"})
}

func helloHandler(w http.ResponseWriter, r *http.Request) {
	helloCount.Add(1)
	w.Header().Set("Content-Type", "text/plain")
	w.Write([]byte("Hello World!"))
}

func versionHandler(w http.ResponseWriter, r *http.Request) {
	versionCount.Add(1)
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(VersionResponse{Version: "1.0.0"})
}

func metricsHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(MetricsResponse{
		Health:  healthCount.Load(),
		Hello:   helloCount.Load(),
		Version: versionCount.Load(),
	})
}

// logRequest wraps a handler: logs the incoming request, then calls the real handler.
// This is the middleware pattern — one wrapper, applied to every route.
func logRequest(logger *slog.Logger, h http.HandlerFunc) http.HandlerFunc {
	return func(w http.ResponseWriter, r *http.Request) {
		logger.Info("request", "method", r.Method, "path", r.URL.Path)
		h(w, r)
	}
}

func main() {
	logger := slog.New(slog.NewJSONHandler(os.Stdout, nil))

	http.HandleFunc("/health", logRequest(logger, healthHandler))
	http.HandleFunc("/hello", logRequest(logger, helloHandler))
	http.HandleFunc("/version", logRequest(logger, versionHandler))
	http.HandleFunc("/metrics", logRequest(logger, metricsHandler))

	logger.Info("server starting", "addr", ":8080")
	if err := http.ListenAndServe(":8080", nil); err != nil {
		logger.Error("server failed", "err", err)
	}
}
