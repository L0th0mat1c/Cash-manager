package controller

//func TestUser200(t *testing.T) {
//	// Make a request to our server with the {base url}/api/auth/login
//	req, err := http.NewRequest("GET", fmt.Sprintf("%s/user/me", ts.URL), nil)
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
//	if resp.StatusCode != 200 {
//		t.Fatalf("Expected status code 200, got %v", resp.StatusCode)
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
//	var user models.User
//	if err = json.NewDecoder(resp.Body).Decode(&user); err != nil {
//		log.Fatal(err)
//	}
//
//	tests.AssertEqual(t, user.Email, "jules.robineau@hotmail.fr")
//	tests.AssertEqual(t, user.Username, "Drijux")
//}