package main

import (
	"trabalho-sd-api/configs"
	"trabalho-sd-api/registry"
	"trabalho-sd-api/server"
)

func main() {
	r := registry.NewRegistry(configs.ConnectDB())

	server := server.CreateServer(r.NewAppController())

	server.Run()
}
