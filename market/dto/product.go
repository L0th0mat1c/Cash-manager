package dto

type NewProductRequest struct {
	Name     string  `json:"name"  binding:"required,min=3,max=70"`
	Price    float64 `json:"price" binding:"required,min=0.01"`
	Origin   string  `json:"origin" binding:"required,min=2,max=50"`
	ImageUrl string  `json:"image_url" binding:"required,min=10,max=250"`
}

type UpdateProductRequest struct {
	ID int64 `json:"id" binding:"required,min=1"`
	NewProductRequest
}
