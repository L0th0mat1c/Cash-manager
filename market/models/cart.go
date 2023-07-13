package models

import "gorm.io/gorm"

type CartProduct struct {
	UserId    int64          `gorm:"primaryKey" json:"-"`
	User      *User          `gorm:"foreignKey:UserId" json:"user,omitempty"`
	ProductId int64          `gorm:"primaryKey" json:"-"`
	Product   Product        `gorm:"foreignKey:ProductId" json:"product,omitempty"`
	Quantity  int            `json:"quantity"`
	DeletedAt gorm.DeletedAt `json:"-"`
}

type Cart struct {
	UserId   int64     `json:"user_id"`
	Price    float64   `json:"price,omitempty"`
	Products []Product `json:"products"`
}

// AddProductInCart
func AddProductInCart(userId, productId int64) error {
	var product CartProduct
	DB.Table("carts").FirstOrInit(&product, CartProduct{UserId: userId, ProductId: productId, Quantity: 0})

	product.Quantity += 1
	res := DB.Table("carts").Save(&product)
	return res.Error
}

// DeleteProductInCart
func DeleteProductInCart(userId, productId int64) error {
	var product CartProduct
	res := DB.Table("carts").Where("user_id = ? AND product_id = ?", userId, productId).Take(&product)
	if res.Error != nil {
		return res.Error
	}

	product.Quantity -= 1
	if product.Quantity <= 0 {
		res = DB.Table("carts").Delete(&CartProduct{
			UserId:    userId,
			ProductId: productId,
		})
	} else {
		res = DB.Table("carts").Save(&product)
	}

	return res.Error
}

// GetUserCart
func GetUserCart(userId int64) (Cart, error) {
	var cartProduct []CartProduct
	res := DB.Table("carts").Preload("Product").Where("user_id = ?", userId).Find(&cartProduct)

	var cart Cart
	cart.UserId = userId
	cart.Products = make([]Product, 0)
	for _, elem := range cartProduct {
		cart.UserId = elem.UserId
		elem.Product.Quantity = elem.Quantity
		elem.Product.Total = elem.Product.Price * float64(elem.Quantity)
		cart.Products = append(cart.Products, elem.Product)
		cart.Price += elem.Product.Price
	}

	return cart, res.Error
}
func CalculatePayment(userId int64) (float64, error) {
	var cartProduct []CartProduct
	var price float64

	res := DB.Table("carts").Preload("Product").Where("user_id = ?", userId).Find(&cartProduct)
	if res.Error != nil {
		return 0, res.Error
	}

	for _, product := range cartProduct {
		price += product.Product.Price
	}

	return price, nil
}

// UserEmptyCart
func UserEmptyCart(userId int64) ([]CartProduct, error) {
	var deleted []CartProduct
	res := DB.Table("carts").Where("user_id = ?", userId).Delete(&deleted)
	return deleted, res.Error
}
