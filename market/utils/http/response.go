package http

type JsonResponse struct {
	Code    int    `json:"code,omitempty"`
	Message string `json:"message,omitempty"`
} // @name Response
