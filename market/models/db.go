package models

import (
	"back/config"
	"fmt"
	"gorm.io/driver/postgres"
	"gorm.io/driver/sqlite"
	"gorm.io/gorm"
	"gorm.io/gorm/logger"
	"log"
	"os"
	"time"
)

var DB *gorm.DB

func InitDB() {
	newLogger := logger.New(
		log.New(os.Stdout, "\r\n", log.LstdFlags), // io writer
		logger.Config{
			SlowThreshold:             time.Second,   // Slow SQL threshold
			LogLevel:                  logger.Silent, // Log level
			IgnoreRecordNotFoundError: true,          // Ignore ErrRecordNotFound error for logger
			Colorful:                  false,         // Disable color
		},
	)

	var err error
	if os.Getenv("APP_ENV") != "test" {
		dsn := fmt.Sprintf("host=%s user=%s password=%s dbname=%s port=%s sslmode=disable TimeZone=Europe/Paris",
			config.CONFIG.DB.Host,
			config.CONFIG.DB.User,
			config.CONFIG.DB.Password,
			config.CONFIG.DB.DbName,
			config.CONFIG.DB.Port,
		)
		DB, err = gorm.Open(postgres.Open(dsn), &gorm.Config{
			Logger: newLogger,
		})

	} else {
		DB, err = gorm.Open(sqlite.Open("../test.db"), &gorm.Config{})
		if err != nil {
			panic("failed to connect database. " + err.Error())
		}
		_ = DB.AutoMigrate(Token{}, TokenBlackList{}, User{}, Product{}, CartProduct{})
	}

	if err != nil {
		panic("failed to connect database. " + err.Error())
	}
}
