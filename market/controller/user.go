package controller

import (
	"back/middleware"
	"back/models"
	httpUtils "back/utils/http"
	"fmt"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"net/http"
)

// Me godoc
// @Tags user
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Summary User from token
// @Produce json
// @Success 200 {object} models.User
// @Failure 400,401,404 {object} httpUtils.HTTPError
// @Router /user/me [get]
func me(c *gin.Context) {
	user := c.MustGet("user").(*models.User)

	if user.UserType != models.ADMIN {
		user.Credentials = ""
		user.ID = 0
		user.UserType = ""
	}

	c.JSON(http.StatusOK, user)
}

// Updated godoc
// @Tags user
// @Security Bearer
// @Summary Updated user from token
// @Produce json
// @Accept json
// @Param Authorization header string true "Bearer <access token>"
// @Param data parameters body models.UpdatedUser false "Body parameters"
// @Success 202 {object} httpUtils.JsonResponse
// @Failure 400,401,404 {object} httpUtils.HTTPError
// @Router /user [put]
func updateUser(c *gin.Context) {
	var user = c.MustGet("user").(*models.User)
	var updated models.UpdatedUser
	var err error
	fmt.Println(c.Request.Body)
	if err := c.ShouldBindJSON(&updated); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return
	}

	if updated.ConfirmPwd != "" &&  updated.Credentials != "" {
		if err = models.VerifyPassword(user.Credentials, updated.ConfirmPwd); err != nil {
			httpUtils.NewError(c, http.StatusBadRequest, err)
			return
		}
		var cred []byte
		if cred, err = bcrypt.GenerateFromPassword([]byte(updated.Credentials), 16); err != nil {
			httpUtils.NewError(c, http.StatusInternalServerError, err)
			return
		}
		user.Credentials = string(cred)
	}


	models.UpdateUser(user, updated)
	c.JSON(http.StatusAccepted, httpUtils.JsonResponse{
		Code:    202,
		Message: "user has been updated",
	})
}

func AddUserRoutes(rg *gin.RouterGroup) {
	auth := rg.Group("/user")


	auth.Use(middleware.JWTHeaderToken())
	auth.GET("/me", me)
	auth.PUT("", updateUser)
}