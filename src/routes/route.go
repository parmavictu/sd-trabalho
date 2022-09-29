package routes

import (
	"net/http"
	"trabalho-sd-api/controllers"
	"trabalho-sd-api/middlewares"

	"github.com/gin-gonic/gin"
)

func ConfigRoutes(router *gin.Engine, appController controllers.AppController) *gin.Engine {
	router.GET("/health", func(c *gin.Context) {
		c.String(http.StatusOK, "running")
	})
	router.Use(middlewares.LogInstance())
	router.Use(middlewares.ValidateApiGatewayheader())

	main := router.Group("api/v1")
	{
		user := main.Group("user")
		{
			//GET
			user.GET("/", appController.GetUsers)
			user.GET("/:userId", appController.GetUserById)

			//POST
			user.POST("/", appController.CreateUser)

			//DELETE
			user.DELETE("/:userId", appController.DeleteUser)

			//UPDATE
			user.PUT("/:userId", appController.UpdateUser)
		}
	}

	return router
}
