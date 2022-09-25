package server

import (
	"log"
	"trabalho-sd-api/controllers"
	"trabalho-sd-api/routes"

	"github.com/gin-gonic/gin"
)

type Server struct {
	port          string
	server        *gin.Engine
	appController controllers.AppController
}

func CreateServer(appController controllers.AppController) Server {
	return Server{
		port:          "5000",
		server:        gin.Default(),
		appController: appController,
	}
}

func (s *Server) Run() {
	router := routes.ConfigRoutes(s.server, s.appController)
	log.Print("Server is running at port: ", s.port)
	log.Fatal(router.Run(":" + s.port))
}
