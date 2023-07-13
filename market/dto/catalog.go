package dto

import "back/models"

type CatalogQuery struct {
	// Page is the number of the page of the catalog
	Page uint `form:"page" default:"1"`
	// Size is the number of product in catalog
	Size uint `form:"size" default:"10"`
}

type Catalog struct {
	Catalog []models.Product `json:"catalog"`
}

type Product struct {
	// ID is the id of the product of the catalog
	ID int `uri:"id" minimum:"1"`
}