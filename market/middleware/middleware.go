package middleware

import (
	"back/models"
	httpUtils "back/utils/http"
	"errors"
	"github.com/dgrijalva/jwt-go"
	"github.com/gin-gonic/gin"
	"net/http"
	"strings"
)

type authHeader struct {
	IDToken string `header:"Authorization" binding:"required"`
}

func JWTHeaderToken() gin.HandlerFunc {
	return func(c *gin.Context) {
		var h authHeader
		if err := c.ShouldBindHeader(&h); err != nil {
			httpUtils.NewError(c, http.StatusForbidden, errors.New("JWT token required"))
			c.Abort()
			return
		}

		token := strings.Split(h.IDToken, "Bearer ")[1]
		claims := &models.Claims{}
		tkn, err := jwt.ParseWithClaims(token, claims, func(token *jwt.Token) (interface{}, error) {
			return models.JwtKey, nil
		})

		if err != nil {
			if err == jwt.ErrSignatureInvalid {
				httpUtils.NewError(c, http.StatusUnauthorized, err)
				c.Abort()
				return
			}
			httpUtils.NewError(c, http.StatusBadRequest, err)
			c.Abort()
			return
		}

		if !tkn.Valid {
			httpUtils.NewError(c, http.StatusUnauthorized, err)
			c.Abort()
			return
		}

		var tb models.TokenBlackList
		if res := models.DB.Table("token_blacklist").First(&tb, claims.StandardClaims.Id); res.RowsAffected == 1 {
			httpUtils.NewError(c, http.StatusUnauthorized, errors.New("token not valid"))
			c.Abort()
			return
		}

		user, err := models.GetUserFromToken(token)
		if err != nil {
			httpUtils.NewError(c, http.StatusBadRequest, err)
			c.Abort()
			return
		}

		c.Set("Claims", claims)
		c.Set("user", user)
		c.Next()
	}
}

func AdminOnly() gin.HandlerFunc {
	return func(c *gin.Context) {
		var user = c.MustGet("user").(*models.User)
		if user.UserType != models.ADMIN {
			httpUtils.NewError(c, http.StatusForbidden, errors.New("user not authorized"))
			return
		}

		c.Next()
	}
}
