package main

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
)

func TestHealthHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	w := httptest.NewRecorder()

	healthHandler(w, req)

	res := w.Result()
	if res.StatusCode != http.StatusOK {
		t.Errorf("expected status 200, got %d", res.StatusCode)
	}

	var body HealthResponse
	json.NewDecoder(res.Body).Decode(&body)
	if body.Status != "OK" {
		t.Errorf("expected status OK, got %q", body.Status)
	}
}

func TestHelloHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/hello", nil)
	w := httptest.NewRecorder()

	helloHandler(w, req)

	res := w.Result()
	if res.StatusCode != http.StatusOK {
		t.Errorf("expected status 200, got %d", res.StatusCode)
	}
}

func TestVersionHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/version", nil)
	w := httptest.NewRecorder()

	versionHandler(w, req)

	res := w.Result()
	if res.StatusCode != http.StatusOK {
		t.Errorf("expected status 200, got %d", res.StatusCode)
	}

	var body VersionResponse
	json.NewDecoder(res.Body).Decode(&body)
	if body.Version != "1.0.0" {
		t.Errorf("expected version 1.0.0, got %q", body.Version)
	}
}

func TestMetricsHandler(t *testing.T) {
	req := httptest.NewRequest(http.MethodGet, "/metrics", nil)
	w := httptest.NewRecorder()

	metricsHandler(w, req)

	res := w.Result()
	if res.StatusCode != http.StatusOK {
		t.Errorf("expected status 200, got %d", res.StatusCode)
	}

	var body MetricsResponse
	if err := json.NewDecoder(res.Body).Decode(&body); err != nil {
		t.Fatalf("failed to decode metrics response: %v", err)
	}
}

// TestAllEndpointsParallel is the goroutine+channel pattern from Day 2:
// launch one goroutine per endpoint, each sends its result back on a shared
// channel, the test collects all results and checks them.
func TestAllEndpointsParallel(t *testing.T) {
	type result struct {
		path   string
		status int
	}

	endpoints := []struct {
		path    string
		handler http.HandlerFunc
	}{
		{"/health", healthHandler},
		{"/hello", helloHandler},
		{"/version", versionHandler},
		{"/metrics", metricsHandler},
	}

	ch := make(chan result, len(endpoints))

	for _, e := range endpoints {
		e := e // capture loop variable before the goroutine runs
		go func() {
			req := httptest.NewRequest(http.MethodGet, e.path, nil)
			w := httptest.NewRecorder()
			e.handler(w, req)
			ch <- result{path: e.path, status: w.Result().StatusCode}
		}()
	}

	for range endpoints {
		r := <-ch
		if r.status != http.StatusOK {
			t.Errorf("%s: expected 200, got %d", r.path, r.status)
		}
	}
}
