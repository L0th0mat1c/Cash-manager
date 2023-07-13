package config

import (
	"fmt"
	"github.com/joho/godotenv"
	"github.com/kelseyhightower/envconfig"
	"log"
	"os"
)

type Config struct {
	Env       string `envconfig:"APP_ENV" required:"true"`
	JwtSecret []byte `envconfig:"JWT_SECRET" required:"true"`
	Server    struct {
		Port string `envconfig:"PORT" required:"true"`
		Host string `envconfig:"HOST" default:"127.0.0.1"`
	}
	DB struct {
		Port     string `envconfig:"DB_PORT" required:"true"`
		Host     string `envconfig:"DB_HOST" required:"true"`
		User     string `envconfig:"DB_USER" required:"true"`
		DbName   string `envconfig:"DB_DB"  required:"true"`
		Password string `envconfig:"DB_PWD" required:"true"`
	}
	BANK struct {
		Login    string `envconfig:"BANK_LOGIN"`
		Password string `envconfig:"BANK_PWD"`
	}
}

var CONFIG Config

func init() {
	if len(os.Getenv("PORT")) == 0 {
		env := os.Getenv("APP_ENV")
		err := godotenv.Load(env + ".env")
		if err != nil {
			log.Fatal("Error loading .env file, file doesn't exist")
		}
	}

	err := envconfig.Process("", &CONFIG)
	if err != nil {
		log.Fatal(err.Error())
	}

	if CONFIG.Env == "dev" {
		fmt.Printf(`
	####################################################################################################################
	#                                                                                                                  #
	#           You are in developer mode ! In production, you will never see this banner !                            #
	#                                   FontMarket development                                                         #
	#                                                                                                                  #
	####################################################################################################################
		` + "\n")
	}
}
