package utils

import (
	"back/config"
	"bytes"
	"encoding/json"
	"errors"
	"io/ioutil"
	"log"
	"net/http"
)

func GetBankToken() (string, error) {
	const url = "http://138.68.112.53/bank/api/localitys/login"

	values, _ := json.Marshal(map[string]string{"login": config.CONFIG.BANK.Login, "pwd": config.CONFIG.BANK.Password})
	request, err := http.Post(url, "application/json", bytes.NewBuffer(values))
	if err != nil {
		log.Println(err.Error())
		return "", err
	}
	defer request.Body.Close()

	body, _ := ioutil.ReadAll(request.Body)
	if request.StatusCode != 200 {
		err = errors.New(string(body))
		log.Println(err.Error())
		return "", err
	}

	type bankResponse struct{
		Login string `json:"login"`
		Token string `json:"token"`
	}

	resp := bankResponse{}
	err = json.Unmarshal(body, &resp)
	if err != nil {
		log.Println(err.Error())
		return "", err
	}

	return resp.Token, nil
}
