package controller

import (
	"back/dto"
	"back/middleware"
	"back/models"
	"back/utils"
	httpUtils "back/utils/http"
	"bytes"
	"encoding/json"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"io/ioutil"
	"log"
	"net/http"
)

// getUserCart get the cart of product of user godoc
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Tags cart
// @Summary Product in the cart
// @Description Get the product's cart for a user
// @Produce json
// @Success 200 {object} models.Cart
// @Failure 401,403 {object} httpUtils.HTTPError
// @Router /cart [get]
func getUserCart(c *gin.Context) {
	var user = c.MustGet("user").(*models.User)

	cart, err := models.GetUserCart(int64(user.ID))
	if err != nil {
		httpUtils.NewError(c, http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusOK, cart)
}

// addProductToCart Add product in cart of the user godoc
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Tags cart
// @Summary Add product in the cart
// @Description Add the product in the cart of user
// @Param data parameters body dto.CartRequest false "Body parameters"
// @Produce json
// @Success 201 {object} httpUtils.JsonResponse
// @Failure 400 {object} httpUtils.HTTPError
// @Router /cart [post]
func addProductToCart(c *gin.Context) {
	var user = c.MustGet("user").(*models.User)
	var addProductReq dto.CartRequest

	if err := c.ShouldBindJSON(&addProductReq); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	if err := models.AddProductInCart(int64(user.ID), addProductReq.ProductId); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	c.JSON(http.StatusCreated, httpUtils.JsonResponse{
		Code: 201,
		Message: fmt.Sprintf(
			"product with id '%d' has been saved in cart of user with id '%d'", addProductReq.ProductId, user.ID,
		),
	})
}

// deleteProductToCart Delete product in cart of the user godoc
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Tags cart
// @Summary Delete product in the cart
// @Description Delete the product by id in the cart of user
// @Param product_id path int true "Product ID"
// @Produce json
// @Success 202 {object} httpUtils.JsonResponse
// @Failure 400 {object} httpUtils.HTTPError
// @Router /cart/products/{product_id} [delete]
func deleteProductToCart(c *gin.Context) {
	var user = c.MustGet("user").(*models.User)
	var addProductReq dto.CartRequest

	if err := c.ShouldBindUri(&addProductReq); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	if err := models.DeleteProductInCart(int64(user.ID), addProductReq.ProductId); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	c.JSON(http.StatusAccepted, httpUtils.JsonResponse{
		Code: 202,
		Message: fmt.Sprintf(
			"product with id '%d' has been deleted in cart of user with id '%d'",
			addProductReq.ProductId,
			user.ID,
		),
	})
}

// paymentCart Request to pay user cart godoc
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Tags cart
// @Summary Request for payment
// @Description Request for payment to the bank of the cart
// @Produce json
// @Param data parameters body dto.PaymentRequest false "Body parameters"
// @Success 202 {object} httpUtils.JsonResponse
// @Failure 400,401,406 {object} httpUtils.HTTPError
// @Router /cart/payment [post]
func paymentCart(c *gin.Context) {
	var user = c.MustGet("user").(*models.User)
	const url = "http://138.68.112.53/bank/api/bankaccount/pay"

	var body dto.PaymentRequest
	if err := c.BindJSON(&body); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	price, err := models.CalculatePayment(int64(user.ID))
	if err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	if price == 0 {
		httpUtils.NewError(c, http.StatusBadRequest, errors.New("empty cart, impossible to make payment"))
		return
	}

	token, err := utils.GetBankToken()
	if err != nil {
		httpUtils.NewError(c, http.StatusInternalServerError, errors.New("impossible to communicate with bank server"))
		return
	}

	values, _ := json.Marshal(map[string]interface{}{"cardId": body.CardUid, "price": price})
	request, err := http.NewRequest(http.MethodPost, url, bytes.NewBuffer(values))
	if err != nil {
		httpUtils.NewError(c, http.StatusInternalServerError, err)
		return
	}

	client := http.Client{}
	request.Header.Add("Authorization", token)
	request.Header.Add("Content-Type", "application/json")
	resp, err := client.Do(request)
	if resp.StatusCode != 200 && resp.StatusCode != 201 {
		all, _ := ioutil.ReadAll(resp.Body)
		log.Println(string(all))
		httpUtils.NewError(c, http.StatusNotAcceptable, errors.New("payment was not accepted"))
		return
	}

	if _, err := models.UserEmptyCart(int64(user.ID)); err != nil {
		log.Println()
		httpUtils.NewError(c, http.StatusInternalServerError, err)
		return
	}

	c.JSON(http.StatusAccepted, httpUtils.JsonResponse{
		Code:    202,
		Message: "payment was accepted",
	})
}

func AddCartRoutes(rg *gin.RouterGroup) {
	cart := rg.Group("/cart")

	cart.Use(middleware.JWTHeaderToken())
	cart.GET("", getUserCart)
	cart.POST("", addProductToCart)
	cart.POST("/payment", paymentCart)
	cart.DELETE("/products/:product_id", deleteProductToCart)
}
