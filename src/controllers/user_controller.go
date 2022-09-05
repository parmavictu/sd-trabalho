package controllers

import (
	"net/http"
	"trabalho-sd-api/interactors"
	"trabalho-sd-api/models"

	"github.com/gin-gonic/gin"
	"github.com/go-playground/validator"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

type userController struct {
	userInteractor interactors.UserInteractor
	validator      *validator.Validate
}

type UserController interface {
	CreateUser(context *gin.Context)
	GetUsers(context *gin.Context)
	GetUserById(context *gin.Context)
	DeleteUser(context *gin.Context)
	UpdateUser(context *gin.Context)
}

func NewUserController(interactor interactors.UserInteractor, validator *validator.Validate) UserController {
	return &userController{interactor, validator}
}

func (uc *userController) CreateUser(context *gin.Context) {
	var userRequest models.User

	if err := context.Bind(&userRequest); err != nil {
		context.JSON(http.StatusBadRequest, err)
	}

	if validationErr := uc.validator.Struct(&userRequest); validationErr != nil {
		context.JSON(http.StatusBadRequest, validationErr)
	}

	createdUser, err := uc.userInteractor.CreateUser(userRequest)

	if err != nil {
		context.JSON(http.StatusInternalServerError, err)
	}

	context.JSON(http.StatusCreated, createdUser)

}

func (uc *userController) GetUsers(context *gin.Context) {
	users, err := uc.userInteractor.GetUsers()

	if err != nil {
		context.JSON(http.StatusInternalServerError, err)
	}
	context.JSON(http.StatusOK, users)
}

func (uc *userController) GetUserById(context *gin.Context) {
	userId := context.Param("userId")

	if userId == "" {
		context.JSON(http.StatusBadRequest, "ID is missing.")
	}

	user, err := uc.userInteractor.GetUserById(userId)

	if err != nil {
		context.JSON(http.StatusInternalServerError, err)
	}

	context.JSON(http.StatusOK, user)
}

func (uc *userController) UpdateUser(context *gin.Context) {
	userId := context.Param("userId")

	if userId == "" {
		context.JSON(http.StatusBadRequest, "ID is missing.")
	}

	var userRequest models.User

	if err := context.Bind(&userRequest); err != nil {
		context.JSON(http.StatusBadRequest, err)
	}

	if validationErr := uc.validator.Struct(&userRequest); validationErr != nil {
		context.JSON(http.StatusBadRequest, validationErr)
	}

	primitiveUserId, _ := primitive.ObjectIDFromHex(userId)

	userRequest.Id = primitiveUserId

	updatedUser, err := uc.userInteractor.UpdateUser(userRequest)

	if err != nil {
		context.JSON(http.StatusInternalServerError, err)
	}

	context.JSON(http.StatusOK, updatedUser)
}

func (uc *userController) DeleteUser(context *gin.Context) {
	userId := context.Param("userId")

	if userId == "" {
		context.JSON(http.StatusBadRequest, "ID is missing.")
	}
	deletedUser, err := uc.userInteractor.DeleteUser(userId)

	if err != nil {
		context.JSON(http.StatusInternalServerError, err)
	}
	context.JSON(http.StatusOK, deletedUser)
}
