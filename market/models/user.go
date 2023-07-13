package models

import (
	httpUtils "back/utils/http"
	"errors"
	"fmt"
	"github.com/gin-gonic/gin"
	"golang.org/x/crypto/bcrypt"
	"gorm.io/gorm"
	"log"
	"net/http"
	"strings"
	"time"
)

type UserType string

const (
	ADMIN UserType = "ADMIN"
	USER  UserType = "USER"
)

type User struct {
	ID          uint           `gorm:"primaryKey" json:"id,omitempty" swaggerignore:"true"`
	UserType    UserType       `json:"user_type,omitempty" sql:"user_type" swaggerignore:"true"`
	Email       string         `json:"email"`
	Username    string         `json:"username"`
	Credentials string         `json:"credentials,omitempty" swaggerignore:"true"`
	FirstName   string         `json:"first_name"`
	LastName    string         `json:"last_name"`
	IsVerified  bool           `json:"is_verified"`
	Birthday    *time.Time     `json:"birthday,omitempty"`
	CreatedAt   time.Time      `json:"created_at"`
	UpdatedAt   time.Time      `json:"updated_at"`
	DeletedAt   gorm.DeletedAt `gorm:"index" json:"-" swaggerignore:"true"`
} // @name User

type UpdatedUser struct {
	Email       string     `json:"email"`
	Username    string     `json:"username"`
	Credentials string     `json:"password,omitempty" binding:"required_with=Credentials ConfirmPwd"`
	ConfirmPwd  string     `json:"confirm_password" binding:"required_with=Credentials ConfirmPwd"`
	FirstName   string     `json:"first_name"`
	LastName    string     `json:"last_name"`
	Birthday    *time.Time `json:"birthday"`
} // @name UpdatedUser

func VerifyPassword(hash, confirmPwd string) error {
	return bcrypt.CompareHashAndPassword([]byte(hash), []byte(confirmPwd))
}

func UpdateUser(user *User, update UpdatedUser) {
	if update.Email != "" {
		user.Email = update.Email
	}

	if update.Username != "" {
		user.Username = update.Username
	}

	if update.FirstName != "" {
		user.FirstName = update.FirstName
	}

	if update.LastName != "" {
		user.LastName = update.LastName
	}

	if update.Birthday != nil {
		user.Birthday = update.Birthday
	}

	DB.Save(&user)
}

func GetUserFromToken(tk string) (*User, error) {
	var t Token
	res := DB.Preload("User").Where(Token{AccessToken: tk}).Take(&t)
	if res.Error != nil {
		fmt.Println("Error:", res.Error)
		return nil, res.Error
	}

	return t.User, nil
}

func GetUserFromRefreshToken(refreshToken string) (*User, error) {
	var t Token
	res := DB.Preload("User").Where(Token{RefreshToken: refreshToken}).Take(&t)
	if res.Error != nil {
		fmt.Println("Error:", res.Error)
		return nil, res.Error
	}

	return t.User, nil
}

func CreateNewUser(c *gin.Context, user RegisterReq) (*User, error) {
	encrypted, err := bcrypt.GenerateFromPassword([]byte(user.Password), 16)
	if err != nil {
		httpUtils.NewError(c, http.StatusInternalServerError, err)
		return nil, err
	}

	var save = &User{
		UserType:    USER,
		Email:       user.Email,
		Username:    user.Username,
		Credentials: string(encrypted),
		FirstName:   user.FirstName,
		LastName:    user.LastName,
	}

	res := DB.Create(save)

	if errors.Is(res.Error, gorm.ErrRegistered) {
		if strings.Contains(res.Error.Error(), "email_unique") {
			log.Println("Uninque email")
			httpUtils.NewError(c, http.StatusForbidden, errors.New("email already exists"))
		}
		if strings.Contains(res.Error.Error(), "username_unique") {
			log.Println("Uninque usernmae")
			httpUtils.NewError(c, http.StatusForbidden, errors.New("username already exists"))
		}
		return nil, err
	}

	if res.Error != nil {
		err = errors.New(res.Error.Error())
		httpUtils.NewError(c, http.StatusBadRequest, err)
		return nil, err
	}

	return save, nil
}
