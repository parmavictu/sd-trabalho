package middlewares

import (
	"net/http"
	"trabalho-sd-api/configs"

	"github.com/gin-gonic/gin"
)

func ValidateApiGatewayheader() gin.HandlerFunc {
	return func(context *gin.Context) {
		token := context.Request.Header.Get("x-auth-token")
		if token != configs.EnvApiGatewayToken() {
			context.JSON(http.StatusUnauthorized, "Requisition was not authorized.")
			context.Abort()
		}
	}
}
