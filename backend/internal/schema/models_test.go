package schema

import (
 "encoding/json"
 "strings"
 "testing"
)
func TestNoAdministrativeSubdivision(t *testing.T){
 for _,name:=range Catalog(){if strings.Contains(strings.ToLower(name),"campus"){t.Fatal("forbidden domain concept",name)}}
}
func TestInstitutionScopeSerializes(t *testing.T){
 b,err:=json.Marshal(Student{Record:Record{ID:"01TEST",InstitutionID:"01ORG"},FullName:"Aluno"})
 if err!=nil{t.Fatal(err)}
 if !strings.Contains(string(b),"\"institutionId\":\"01ORG\""){t.Fatalf("missing institution scope: %s",b)}
}
func TestCurrencyMinorUnits(t *testing.T){
 p:=Payment{AmountMinor:12345,Currency:"AOA"}
 b,err:=json.Marshal(p)
 if err!=nil{t.Fatal(err)}
 if !strings.Contains(string(b),"\"amountMinor\":12345"){t.Fatal(string(b))}
}
