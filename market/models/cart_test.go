package models

import (
	"testing"
)


func TestMain(m *testing.M) {
	// The setupServer method, that we previously refactored
	// is injected into a test server
	// Shut down the server and block until all requests have gone through
	InitDB()
}

func TestProductInCart(t *testing.T) {
	var cart []CartProduct
	DB.Table("carts").Where("user_id = ?", 1).Find(&cart)

	if len(cart) != 0 {
		t.Fatal("impossible that the cart got some article")
	}

	userCart, err := GetUserCart(1)
	if err != nil {
		t.Fatal(err.Error())
	}

	if len(userCart.Products) != 0 {
		t.Fatal("impossible that the cart got some article")
	}
}

func TestAddProductInCart(t *testing.T) {
	userCart, err := GetUserCart(1)
	if err != nil {
		t.Fatal(err.Error())
	}
	qty := len(userCart.Products)

	if err := AddProductInCart(1, 1); err != nil {
		t.Fatal(err.Error())
	}

	userCart, err = GetUserCart(1)
	if err != nil {
		t.Fatal(err.Error())
	}

	if len(userCart.Products) == (qty + 1) {
		t.Fatal("the cart is normally one item larger")
	}
}

func TestDeleteProductInCart(t *testing.T) {
	userCart, err := GetUserCart(1)
	if err != nil {
		t.Fatal(err.Error())
	}
	qty := len(userCart.Products)

	if qty == 0 {
		if err := AddProductInCart(1, 1); err != nil {
			t.Fatal(err.Error())
		}
		qty += 1
	}

	if err := DeleteProductInCart(1, 1); err != nil {
		t.Fatal(err.Error())
	}

	userCart, err = GetUserCart(1)
	if err != nil {
		t.Fatal(err.Error())
	}

	if len(userCart.Products) != (qty - 1) {
		t.Fatal("the cart is normally one item lighter")
	}
}


