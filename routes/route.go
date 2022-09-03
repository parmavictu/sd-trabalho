package routes

import (
	"trabalho-sd-api/controllers"

	"github.com/gin-gonic/gin"
)

func ConfigRoutes(router *gin.Engine) *gin.Engine {

	requestCheck := router.Group("requestcheck")
	{
		requestCheck.GET("/:requestId", controllers.CheckRequest)
	}

	return router
}
