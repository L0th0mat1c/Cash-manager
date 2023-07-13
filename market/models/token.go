package models

import (
	"github.com/dgrijalva/jwt-go"
	"net/http"
	"strconv"
	"time"
)

type Token struct {
	ID           uint      `gorm:"primaryKey" json:"id"`
	UserId       uint      `json:"user_id"`
	User         *User     `gorm:"foreignKey:UserId" json:"user,omitempty"`
	AccessToken  string    `json:"access_token"`
	RefreshToken string    `json:"refresh_token"`
	ExpiresAt    time.Time `json:"expires_at"`
	CreatedAt    time.Time `json:"created_at"`
	UpdatedAt    time.Time `json:"updated_at"`
}

type TokenBlackList struct {
	Jti       string    `gorm:"primaryKey" json:"jti"`
	CreatedAt time.Time `json:"created_at"`
}

var JwtKey = []byte("SUPER_SECRET_JWT")

type Claims struct {
	Email    string `json:"email"`
	Username string `json:"username"`
	jwt.StandardClaims
}

func (t *Token) GenerateTokenAndSave(email, userName string, id uint) (int, error) {
	t.UpdatedAt = time.Now().UTC()
	t.ExpiresAt = t.UpdatedAt.Add(30 * (24 * time.Hour)).UTC()

	var err error
	claims := Claims{
		Email:    email,
		Username: userName,
		StandardClaims: jwt.StandardClaims{
			Id: strconv.Itoa(time.Now().UTC().Nanosecond()),
		},
	}

	refresh := jwt.NewWithClaims(jwt.SigningMethodHS512, claims)
	t.RefreshToken, err = refresh.SignedString(JwtKey)
	if err != nil {
		return http.StatusInternalServerError, err
	}

	claims.ExpiresAt = t.ExpiresAt.Unix()
	access := jwt.NewWithClaims(jwt.SigningMethodHS512, claims)
	t.AccessToken, err = access.SignedString(JwtKey)
	if err != nil {
		return http.StatusInternalServerError, err
	}

	if res := DB.Table("tokens").Where("user_id = ?", id).Updates(t); res.RowsAffected == 0 {
		t.CreatedAt = t.UpdatedAt
		t.UserId = id
		res = DB.Create(t)
	}

	return 201, nil
}

func (tb *TokenBlackList) SaveTokenBlacklist() error {
	return DB.Table("token_blacklist").Create(tb).Error
}
