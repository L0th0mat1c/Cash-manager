package controller

import (
	"back/middleware"
	"back/models"
	httpUtils "back/utils/http"
	"errors"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"net/http"
)


// Login godoc
// @Tags auth
// @Accept json
// @Summary Login User, create user token
// @Produce json
// @Param data parameters body models.AuthReq false "Body parameters"
// @Success 201 {object} models.AuthResp
// @Failure 400,403,404 {object} httpUtils.HTTPError
// @Router /auth/login [post]
func login(c *gin.Context) {
	// Bind request body to models.AuthReq struct
	var req models.AuthReq
	if err := c.ShouldBindJSON(&req); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, errors.New("Bad request, body is malformated"))
		return
	}

	// Get first record in DB with match email, or return not found
	var user models.User
	if res := models.DB.First(&user, models.User{Email: req.Email}); res.Error != nil {
		httpUtils.NewError(c, http.StatusForbidden, res.Error)
		return
	}

	// Compare password get in body with the encrypted save in DB
	if err := bcrypt.CompareHashAndPassword([]byte(user.Credentials), []byte(req.Password)); err != nil {
		httpUtils.NewError(c, http.StatusForbidden, errors.New("Password doesn't match"))
		return
	}

	// Generate JWT token for user and save it in DB
	var token models.Token
	if code, err := token.GenerateTokenAndSave(user.Email, user.Username, user.ID); err != nil {
		httpUtils.NewError(c, code, err)
		return
	}

	// Return models.AuthResp struct with code 201
	c.JSON(http.StatusCreated, models.AuthResp{
		AccessToken:  token.AccessToken,
		RefreshToken: token.RefreshToken,
		ExpiresAt:    token.ExpiresAt,
	})
}


// Logout godoc
// @Tags auth
// @Security Bearer
// @Param Authorization header string true "Bearer <access token>"
// @Summary Logout User, revoke user token
// @Produce json
// @Success 202 {object} httpUtils.JsonResponse
// @Failure 400,401,403 {object} httpUtils.HTTPError
// @Router /auth/logout [delete]
func logout(c *gin.Context) {
	// Get Claims from the middleware middleware.JWTHeaderToken
	claims := c.MustGet("Claims").(*models.Claims)

	var tb models.TokenBlackList
	tb.Jti = claims.StandardClaims.Id
	// Save user's token in Black list DB or return httpUtils.HttpError struct
	if err := tb.SaveTokenBlacklist(); err != nil {
		httpUtils.NewError(c, http.StatusInternalServerError, err)
		return
	}

	// Return httpUtils.JsonResponse struct with code 202
	c.JSON(http.StatusAccepted, httpUtils.JsonResponse{
		Code:    202,
		Message: "Token has been revoked",
	})
}

// Register godoc
// @Tags auth
// @Param data parameters body models.RegisterReq false "Body parameters"
// @Summary Register User, create user with body request
// @Accept json
// @Produce json
// @Success 201 {object} httpUtils.JsonResponse
// @Failure 400,403 {object} httpUtils.HTTPError
// @Router /auth/register [post]
func register(c *gin.Context) {
	// Bind request body to models.RegisterReq struct
	var req models.RegisterReq
	if err := c.ShouldBindJSON(&req); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, errors.New("bad request, body is malformated"))
		return
	}

	// Create user if email doesn't already exist
	user, err := models.CreateNewUser(c, req)
	if err != nil {
		return
	}

	// Generate JWT token for user and save it in DB
	var token models.Token
	if code, err := token.GenerateTokenAndSave(user.Email, user.Username, user.ID); err != nil {
		httpUtils.NewError(c, code, err)
		return
	}

	// Return models.AuthResp struct with code 201
	c.JSON(http.StatusCreated, models.AuthResp{
		AccessToken:  token.AccessToken,
		RefreshToken: token.RefreshToken,
		ExpiresAt:    token.ExpiresAt,
	})
}


// Refresh token  godoc
// @Tags auth
// @Param data parameters body models.RefreshTokenReq false "Body parameters"
// @Summary Refresh token
// @Description Take refresh token in body and return new access token
// @Accept json
// @Produce json
// @Success 202 {object} models.RefreshTokenResp
// @Failure 400,401,403 {object} httpUtils.HTTPError
// @Router /auth/refresh [post]
func refreshToken(c *gin.Context) {
	// Bind request body to models.RegisterReq struct
	var req models.RefreshTokenReq
	if err := c.ShouldBindJSON(&req); err != nil {
		httpUtils.NewError(c, http.StatusBadRequest, errors.New("bad request, body is malformated"))
		return
	}


	user, err := models.GetUserFromRefreshToken(req.RefreshToken)
	if err != nil {
		httpUtils.NewError(c, http.StatusUnauthorized, errors.New("invalid refresh token"))
		return
	}

	var token models.Token
	if code, err := token.GenerateTokenAndSave(user.Email, user.Username, user.ID); err != nil {
		httpUtils.NewError(c, code, err)
		return
	}

	// Return models.AuthResp struct with code 202
	c.JSON(http.StatusAccepted, models.RefreshTokenResp{
		AuthResp: models.AuthResp{
			AccessToken:  token.AccessToken,
			RefreshToken: token.RefreshToken,
			ExpiresAt:    token.ExpiresAt,
		},
	})
}

func AddAuthRoutes(rg *gin.RouterGroup) {
	auth := rg.Group("/auth")
	auth.POST("/login", login)
	auth.POST("/register", register)
	auth.POST("/refresh", refreshToken)

	auth.Use(middleware.JWTHeaderToken())
	auth.DELETE("/logout", logout)
}