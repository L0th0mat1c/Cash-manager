package main

import (
	"back/controller"
	"back/docs"
	"log"
	"os"
)

// @title Market API
// @version 1.0
// @description This is an API server for FrontMarket.
// @termsOfService http://swagger.io/terms/

// @contact.name API Support BeYours
// @contact.url http://www.swagger.io/support
// @contact.email admin.admin@epitech.fr

// @license.name Apache 2.0
// @license.url http://www.apache.org/licenses/LICENSE-2.0.html

// @host localhost
// @BasePath /market/api
// @Schemes http
// @query.collection.format multi

// @securityDefinitions.apikey Bearer
// @in header
// @name Authorization
func main() {

	// programmatically set swagger info
	docs.SwaggerInfo.Title = "Market API"
	docs.SwaggerInfo.Description = "This is an API server."
	docs.SwaggerInfo.Version = "1.0"
	docs.SwaggerInfo.Host = "localhost"
	if os.Getenv("APP_ENV") == "prod" {
		docs.SwaggerInfo.Host = "138.68.112.53"
	}
	docs.SwaggerInfo.BasePath = "/market/api"
	docs.SwaggerInfo.Schemes = []string{"http"}

	log.Fatal(controller.SetupServer().Run())
}
