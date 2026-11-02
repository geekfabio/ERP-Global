package httpserver

import (
 "context"
 "errors"
 "net/http"
 "net/http/httptest"
 "testing"
)

type fakeDB struct{ err error }
func (f fakeDB) Ping(context.Context) error { return f.err }

func TestLiveness(t *testing.T) {
 w := httptest.NewRecorder()
 Router(fakeDB{}).ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/health/live", nil))
 if w.Code != http.StatusOK { t.Fatalf("status = %d", w.Code) }
}
func TestReadiness(t *testing.T) {
 for _, tc := range []struct{name string; err error; want int}{
  {"ready",nil,http.StatusOK},
  {"unavailable",errors.New("database down"),http.StatusServiceUnavailable},
 } {
  t.Run(tc.name,func(t *testing.T){
   w := httptest.NewRecorder()
   Router(fakeDB{tc.err}).ServeHTTP(w, httptest.NewRequest(http.MethodGet, "/health/ready", nil))
   if w.Code != tc.want { t.Fatalf("status = %d, want %d",w.Code,tc.want) }
  })
 }
}
