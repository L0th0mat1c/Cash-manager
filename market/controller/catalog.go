package controller

import (
	"back/dto"
	"back/middleware"
	"back/models"
	httpUtils "back/utils/http"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"net/http"
)

// Catalog List godoc
// @Tags catalog
// @Summary Catalog
// @Description Get the list of product ok the market
// @Produce json
// @Param data query dto.CatalogQuery false "Query parameters"
// @Success 200 {object} dto.Catalog
// @Failure 400 {object} httpUtils.HTTPError
// @Router /catalog [get]
func getCatalog(c *gin.Context) {
	var query dto.CatalogQuery
	if err := c.Bind(&query); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	catalog := models.GetCatalog(query.Page, query.Size)

	c.JSON(http.StatusOK, dto.Catalog{
		Catalog: catalog,
	})
}

// getProduct of the catalog godoc
// @Tags catalog
// @Summary Product in catalog
// @Description Get the product in the catalog by id
// @Produce json
// @Param id path int true "Product ID"
// @Success 200 {object} models.Product
// @Failure 400,404 {object} httpUtils.HTTPError
// @Router /catalog/products/{id} [get]
func getProduct(c *gin.Context) {
	var uriParams dto.Product
	if err := c.ShouldBindUri(&uriParams); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	product, err := models.GetProductById(uriParams.ID)
	if err != nil {
		httpUtils.NewError(c, http.StatusNotFound, errors.New(
			fmt.Sprintf("product with id '%d' doesn't exist", uriParams.ID),
		))
		return
	}

	c.JSON(http.StatusOK, product)
}

// addNewProduct Create product to add to the catalog godoc
// @Tags catalog
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Summary ADMIN Routes Add new product to catalog
// @Description Create new product and add it to the catalog
// @Produce json
// @Accept json
// @Param data parameters body dto.NewProductRequest false "Body parameters"
// @Success 201 {object} models.Product
// @Failure 400 {object} httpUtils.HTTPError
// @Router /catalog/products [post]
func addNewProduct(c *gin.Context) {
	var productRequest dto.NewProductRequest
	if err := c.ShouldBindJSON(&productRequest); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	product, err := models.CreateProduct(&models.Product{
		Name:     productRequest.Name,
		Price:    productRequest.Price,
		Origin:   productRequest.Origin,
		ImageUrl: productRequest.ImageUrl,
	})

	if err != nil {
		httpUtils.NewError(c, http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusCreated, product)
}

// updateProduct Update product to the catalog godoc
// @Tags catalog
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Summary ADMIN Routes Update product to catalog
// @Description Update new product, only admin person can update product in database
// @Produce json
// @Accept json
// @Param data parameters body dto.UpdateProductRequest false "Body parameters"
// @Success 202 {object} models.Product
// @Failure 400,404 {object} httpUtils.HTTPError
// @Router /catalog/products [put]
func updateProduct(c *gin.Context) {
	var updateReq dto.UpdateProductRequest
	if err := c.ShouldBindJSON(&updateReq); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	product := models.Product{
		Name:     updateReq.Name,
		Price:    updateReq.Price,
		Origin:   updateReq.Origin,
		ImageUrl: updateReq.ImageUrl,
	}

	if err := models.UpdateProduct(&product); err != nil {
		httpUtils.NewError(c, http.StatusNotFound, errors.New(
			fmt.Sprintf("product with id '%d' doesn't exist", product.ID)),
		)
		return
	}

	c.JSON(http.StatusAccepted, product)
}

// deleteProduct Delete product to the catalog by product id godoc
// @Tags catalog
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Summary ADMIN Routes Delete product to the catalog
// @Description Delete product by id, only admin can delete product in database
// @Produce json
// @Param id path int true "Product ID"
// @Success 202 {object} httpUtils.JsonResponse
// @Failure 400,404 {object} httpUtils.HTTPError
// @Router /catalog/products/{id} [delete]
func deleteProduct(c *gin.Context) {
	var uriParams dto.Product
	if err := c.ShouldBindUri(&uriParams); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	if err := models.DeleteProductById(uriParams.ID); err != nil {
		httpUtils.NewError(c, http.StatusNotFound, errors.New(
			fmt.Sprintf("product with id '%d' doesn't exist", uriParams.ID)),
		)
		return
	}

	c.JSON(http.StatusAccepted, httpUtils.JsonResponse{
		Code:    202,
		Message: fmt.Sprintf("product with id '%d' has been been deleted", uriParams.ID),
	})
}

func AddCatalogRoutes(rg *gin.RouterGroup) {
	catalog := rg.Group("/catalog")

	catalog.GET("", getCatalog)
	catalog.GET("/products/:id", getProduct)

	catalog.Use(middleware.JWTHeaderToken())
	catalog.Use(middleware.AdminOnly())

	catalog.POST("/products", addNewProduct)
	catalog.PUT("/products", updateProduct)
	catalog.DELETE("/products/:id", deleteProduct)
}
