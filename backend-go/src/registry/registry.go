package registry

import (
	"trabalho-sd-api/controllers"

	"go.mongodb.org/mongo-driver/mongo"
)

type registry struct {
	db *mongo.Client
}

type Registry interface {
	NewAppController() controllers.AppController
}

func NewRegistry(db *mongo.Client) Registry {
	return &registry{db}
}

func (r *registry) NewAppController() controllers.AppController {
	return r.NewUserController()
}
