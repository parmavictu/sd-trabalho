package interactors

import (
	"log"
	"trabalho-sd-api/models"
	"trabalho-sd-api/repositories"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

type userInteractor struct {
	UserRepository repositories.UserRepository
}

type UserInteractor interface {
	GetUserById(userId string) (*models.User, error)
	GetUsers() (*[]models.User, error)
	CreateUser(userRequest models.User) (*models.User, error)
	UpdateUser(user models.User) (*models.User, error)
	DeleteUser(userId string) (*models.User, error)
}

func NewUserInteractor(repository repositories.UserRepository) UserInteractor {
	return &userInteractor{repository}
}

func (us *userInteractor) GetUserById(userId string) (*models.User, error) {
	log.Print("Retrieving User by Id.")
	primitiveUserId, _ := primitive.ObjectIDFromHex(userId)
	return us.UserRepository.GetUserById(primitiveUserId)
}

func (us *userInteractor) GetUsers() (*[]models.User, error) {
	log.Print("Retrieving All Users")
	return us.UserRepository.GetUsers()
}

func (us *userInteractor) CreateUser(userRequest models.User) (*models.User, error) {

	log.Print("Creating new User with ObjectId.")
	newUser := models.User{
		Id:   primitive.NewObjectID(),
		Name: userRequest.Name,
		Age:  userRequest.Age,
	}

	log.Print("Inserting User into DB")
	result, err := us.UserRepository.CreateUser(newUser)
	if err != nil {
		log.Fatal("There was a fatal error inserting user.")
		return nil, err
	}
	log.Print("Searching created User.")
	createdUser, err := us.UserRepository.GetUserById(result.InsertedID.(primitive.ObjectID))

	if err != nil {
		log.Fatal("There was a fatal error finding created user.")
		return nil, err
	}
	return createdUser, err
}

func (us *userInteractor) UpdateUser(user models.User) (*models.User, error) {

	var updatedUser *models.User = nil
	log.Print("Updating User.")
	updateResult, err := us.UserRepository.UpdateUser(user)

	if err != nil {
		log.Fatal("An error ocurred while trying to update user.")
		return nil, err
	}

	if updateResult.MatchedCount == 1 {
		log.Print("User was updated.")

		updatedUser, err = us.UserRepository.GetUserById(user.Id)
		if err != nil {
			log.Fatal("An error ocurred while trying to get updated user.")
			return nil, err
		}
	}

	return updatedUser, err
}

func (us *userInteractor) DeleteUser(userId string) (*models.User, error) {
	primitiveUserId, _ := primitive.ObjectIDFromHex(userId)

	deletedUser, err := us.UserRepository.GetUserById(primitiveUserId)

	if err != nil {
		log.Fatal("An error ocurred while trying to get original user.")
		return nil, err
	}
	log.Print("Deleting User.")
	deleteError := us.UserRepository.DeleteUser(primitiveUserId)

	if deleteError != nil {
		log.Fatal("An error ocurred while trying to delete user.")
		return nil, err
	}
	log.Print("User was deleted.")
	return deletedUser, nil
}
