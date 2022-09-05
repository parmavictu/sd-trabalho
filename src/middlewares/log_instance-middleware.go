package middlewares

import (
	"log"
	"trabalho-sd-api/utils"

	"github.com/gin-gonic/gin"
)

func LogInstance() gin.HandlerFunc {
	return func(context *gin.Context) {
		host := utils.GetHostName()
		ip := utils.GetIpv4(host)
		log.Print("Request with ", "Host: "+host, " Ip: "+ip)
	}
}
