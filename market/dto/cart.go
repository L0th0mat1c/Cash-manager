package dto


type CartRequest struct {
	// ProductId Product id
	ProductId int64 `json:"product_id" uri:"product_id" binding:"required,min=1"`
}

type PaymentRequest struct {
	CardUid	string `json:"card_uid" binding:"required,min=1"`
}
