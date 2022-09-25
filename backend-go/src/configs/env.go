package configs

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

func EnvMongoURI() string {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading env file.")
	}

	return os.Getenv("MONGOURI")
}

func EnvApiGatewayToken() string {
	err := godotenv.Load()
	if err != nil {
		log.Fatal("Error loading env file.")
	}

	return os.Getenv("API_GATEWAY_TOKEN")
}
