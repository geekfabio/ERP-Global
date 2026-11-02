package httpserver

import (
 "encoding/json"
 "net/http"
 "net/http/httptest"
 "testing"
)
func TestHealth(t *testing.T){
 for _,path:=range []string{"/health/live","/health/ready"}{
  w:=httptest.NewRecorder()
  Router().ServeHTTP(w,httptest.NewRequest(http.MethodGet,path,nil))
  if w.Code!=http.StatusOK{t.Fatalf("%s: %d",path,w.Code)}
 }
}
func TestNoDatabaseConnected(t *testing.T){
 w:=httptest.NewRecorder()
 Router().ServeHTTP(w,httptest.NewRequest(http.MethodGet,"/health/ready",nil))
 var payload struct{DatabaseConnected bool `json:"databaseConnected"`; Storage string `json:"storage"`}
 if err:=json.Unmarshal(w.Body.Bytes(),&payload);err!=nil{t.Fatal(err)}
 if payload.DatabaseConnected||payload.Storage!="memory"{t.Fatalf("unexpected storage: %+v",payload)}
}
func TestCatalog(t *testing.T){
 w:=httptest.NewRecorder()
 Router().ServeHTTP(w,httptest.NewRequest(http.MethodGet,"/v1/meta/schema",nil))
 if w.Code!=http.StatusOK{t.Fatalf("status: %d",w.Code)}
}
