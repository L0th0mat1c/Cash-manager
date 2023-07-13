package models

import (
	"time"
)

type AuthReq struct {
	// User's email
	Email string `json:"email" binding:"required"`
	// User's password
	Password string `json:"password" binding:"required"`
} // @name AuthRequest

type AuthResp struct {
	// Used in token-based authentication to allow an application to access an API
	AccessToken string `json:"access_token"`
	// Used to acquire new access tokens
	RefreshToken string     `json:"refresh_token"`
	// Used to define when the token will be expired
	ExpiresAt    time.Time `json:"expires_at"`
} // @name AuthResponse

type RegisterReq struct {
	AuthReq
	// User's username
	Username string `json:"username" binding:"required"`
	// User's firstname
	FirstName string `json:"first_name" binding:"required"`
	// User's lastname
	LastName string `json:"last_name" binding:"required"`
} // @name Register


type RefreshTokenReq struct {
	// Generated during login or register request
	RefreshToken string `json:"refresh_token"`
} // @name Refresh Token Request

type RefreshTokenResp struct {
	AuthResp
} // @name Refresh Token Response
