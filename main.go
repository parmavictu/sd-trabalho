package main

import "trabalho-sd-api/server"

func main() {
	server := server.CreateServer()

	server.Run()
}
