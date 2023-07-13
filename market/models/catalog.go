package models

import (
	"time"
)

type Product struct {
	ID        int64     `json:"id"`
	Name      string    `json:"name"`
	Price     float64   `json:"price"`
	Quantity  int       `json:"quantity" gorm:"-"`
	Origin    string    `json:"origin"`
	ImageUrl  string    `json:"image_url"`
	Total     float64   `json:"total" gorm:"-"`
	CreatedAt time.Time `json:"created_at"`
	UpdatedAt time.Time `json:"updated_at"`
}

func GetCatalog(page, pageSize uint) []Product {
	if page == 0 {
		page = 1
	}

	switch {
	case pageSize > 100:
		pageSize = 100
	case pageSize <= 0:
		pageSize = 10
	}

	offset := (page - 1) * pageSize
	var catalog []Product
	DB.Table("products").Offset(int(offset)).Limit(int(pageSize)).Find(&catalog)
	return catalog
}

func GetProductById(productId int) (Product, error) {
	var product Product
	res := DB.First(&product, productId)

	return product, res.Error
}

func UpdateProduct(update *Product) error {
	res := DB.Save(update)

	return res.Error
}

func CreateProduct(new *Product) (*Product, error) {
	res := DB.Create(new)

	return new, res.Error
}

func DeleteProductById(productId int) error {
	res := DB.Delete(&Product{}, productId)

	return res.Error
}
