package registry

import (
	"trabalho-sd-api/configs"
	"trabalho-sd-api/controllers"
	"trabalho-sd-api/interactors"
	"trabalho-sd-api/repositories"

	"github.com/go-playground/validator"
)

func (r *registry) NewUserController() controllers.UserController {
	return controllers.NewUserController(r.NewUserInteractor(), validator.New())
}

func (r *registry) NewUserInteractor() interactors.UserInteractor {
	return interactors.NewUserInteractor(r.NewUserRepository())
}

func (r *registry) NewUserRepository() repositories.UserRepository {
	return repositories.NewUserRepository(configs.GetCollection(r.db, "TrabalhoSDDataBase"))
}
