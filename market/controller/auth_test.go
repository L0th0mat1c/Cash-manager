package controller

import (
	"bytes"
	"encoding/json"
	"fmt"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

var ts *httptest.Server

func TestMain(m *testing.M) {
	// The setupServer method, that we previously refactored
	// is injected into a test server
	ts = httptest.NewServer(SetupServer())
	// Shut down the server and block until all requests have gone through
	code := m.Run()
	ts.Close()

	os.Exit(code)
}

var tk = ""

func TestLogin400(t *testing.T) {
	// Make a request to our server with the {base url}/api/auth/login
	resp, err := http.Post(fmt.Sprintf("%s/auth/login", ts.URL), "text/plain", nil)

	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if resp.StatusCode != 400 {
		t.Fatalf("Expected status code 400, got %v", resp.StatusCode)
	}

	val, ok := resp.Header["Content-Type"]

	// Assert that the "content-type" header is actually set
	if !ok {
		t.Fatalf("Expected Content-Type header to be set")
	}

	// Assert that it was set as expected
	if val[0] != "application/json; charset=utf-8" {
		t.Fatalf("Expected \"application/json; charset=utf-8\", got %s", val[0])
	}
}

func TestLogin403(t *testing.T) {
	values := map[string]string{"email": "jules.robineau@hotmail.fr", "password": "thisATest"}
	jsonData, err := json.Marshal(values)

	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}
	// Make a request to our server with the {base url}/api/auth/login
	resp, err := http.Post(fmt.Sprintf("%s/auth/login", ts.URL), "application/json", bytes.NewBuffer(jsonData))

	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if resp.StatusCode != 403 {
		t.Fatalf("Expected status code 403, got %v", resp.StatusCode)
	}

	val, ok := resp.Header["Content-Type"]

	// Assert that the "content-type" header is actually set
	if !ok {
		t.Fatalf("Expected Content-Type header to be set")
	}

	// Assert that it was set as expected
	if val[0] != "application/json; charset=utf-8" {
		t.Fatalf("Expected \"application/json; charset=utf-8\", got %s", val[0])
	}
}

//func TestLogin201(t *testing.T)  {
//	values := map[string]string{"email": "jules.robineau@hotmail.fr", "password": "SuperPassword"}
//	jsonData, err := json.Marshal(values)
//
//	if err != nil {
//		log.Fatal(err)
//	}
//	// Make a request to our server with the {base url}/api/auth/login
//	resp, err := http.Post(fmt.Sprintf("%s/auth/login", ts.URL), "application/json", bytes.NewBuffer(jsonData))
//
//	if err != nil {
//		t.Fatalf("Expected no error, got %v", err)
//	}
//
//	if resp.StatusCode != 201 {
//		t.Fatalf("Expected status code 201, got %v", resp.StatusCode)
//	}
//
//	val, ok := resp.Header["Content-Type"]
//
//	// Assert that the "content-type" header is actually set
//	if !ok {
//		t.Fatalf("Expected Content-Type header to be set")
//	}
//
//	// Assert that it was set as expected
//	if val[0] != "application/json; charset=utf-8" {
//		t.Fatalf("Expected \"application/json; charset=utf-8\", got %s", val[0])
//	}
//
//	var authResp models.AuthResp
//	err = json.NewDecoder(resp.Body).Decode(&authResp)
//	if err != nil {
//		log.Fatal(err)
//	}
//
//	tk = authResp.AccessToken
//}

func TestLogout400(t *testing.T) {
	// Make a request to our server with the {base url}/api/auth/login
	req, err := http.NewRequest("DELETE", fmt.Sprintf("%s/auth/logout", ts.URL), nil)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}
	req.Header.Add("Authorization", "Bearer hello")

	client := &http.Client{}
	resp, err := client.Do(req)
	if err != nil {
		t.Fatalf("Expected no error, got %v", err)
	}

	if resp.StatusCode != 400 {
		t.Fatalf("Expected status code 404, got %v", resp.StatusCode)
	}

	val, ok := resp.Header["Content-Type"]

	// Assert that the "content-type" header is actually set
	if !ok {
		t.Fatalf("Expected Content-Type header to be set")
	}

	// Assert that it was set as expected
	if val[0] != "application/json; charset=utf-8" {
		t.Fatalf("Expected \"application/json; charset=utf-8\", got %s", val[0])
	}
}

//func TestLogout202(t *testing.T) {
//	// Make a request to our server with the {base url}/api/auth/login
//	req, err := http.NewRequest("DELETE", fmt.Sprintf("%s/auth/logout", ts.URL), nil)
//	if err != nil {
//		t.Fatalf("Expected no error, got %v", err)
//	}
//	req.Header.Add("Authorization", "Bearer " + tk)
//
//	client := &http.Client{}
//	resp, err := client.Do(req)
//	if err != nil {
//		t.Fatalf("Expected no error, got %v", err)
//	}
//
//	if resp.StatusCode != 202 {
//		t.Fatalf("Expected status code 202, got %v", resp.StatusCode)
//	}
//
//	val, ok := resp.Header["Content-Type"]
//
//	// Assert that the "content-type" header is actually set
//	if !ok {
//		t.Fatalf("Expected Content-Type header to be set")
//	}
//
//	// Assert that it was set as expected
//	if val[0] != "application/json; charset=utf-8" {
//		t.Fatalf("Expected \"application/json; charset=utf-8\", got %s", val[0])
//	}
//	values := map[string]string{"email": "jules.robineau@hotmail.fr", "password": "SuperPassword"}
//	jsonData, err := json.Marshal(values)
//
//	if err != nil {
//		log.Fatal(err)
//	}
//
//	// Make a request to our server with the {base url}/api/auth/login
//	resp, err = http.Post(fmt.Sprintf("%s/auth/login", ts.URL), "application/json", bytes.NewBuffer(jsonData))
//
//	if err != nil {
//		t.Fatalf("Expected no error, got %v", err)
//	}
//
//	values = map[string]string{"email": "jules.robineau@hotmail.fr", "password": "SuperPassword"}
//	jsonData, err = json.Marshal(values)
//
//	if err != nil {
//		log.Fatal(err)
//	}
//
//	// Make a request to our server with the {base url}/api/auth/login
//	resp, err = http.Post(fmt.Sprintf("%s/auth/login", ts.URL), "application/json", bytes.NewBuffer(jsonData))
//	if err != nil {
//		log.Fatal(err)
//	}
//
//	var authResp models.AuthResp
//	err = json.NewDecoder(resp.Body).Decode(&authResp)
//	if err != nil {
//		log.Fatal(err)
//	}
//
//	tk = authResp.AccessToken
//}
