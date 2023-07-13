package controller

import (
	"back/config"
	"back/models"
	"fmt"
	"github.com/gin-contrib/cors"
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"
)

func SetupServer() *gin.Engine {
	if config.CONFIG.Env == "prod" {
		gin.SetMode(gin.ReleaseMode)
		fmt.Printf("Listening and serving HTTP on %s:%s\n", config.CONFIG.Server.Host, config.CONFIG.Server.Port)
	}

	models.InitDB()

	r := gin.New()
	r.Use(cors.New(cors.Config{AllowAllOrigins: true}))
	r.Use(gin.Logger())
	r.Use(gin.Recovery())

	v1 := r.Group("")
	AddAuthRoutes(v1)
	AddUserRoutes(v1)
	AddCatalogRoutes(v1)
	AddCartRoutes(v1)
	AddRouteDocument(v1)

	// use ginSwagger middleware to serve the API docs
	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))

	return r
}
