package repositories

import (
	"time"
	"trabalho-sd-api/models"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
	"go.mongodb.org/mongo-driver/mongo"
	"golang.org/x/net/context"
)

type userRepository struct {
	collection *mongo.Collection
}

type UserRepository interface {
	GetUserById(primitiveUserId primitive.ObjectID) (*models.User, error)
	GetUsers() (*[]models.User, error)
	CreateUser(newUser models.User) (*mongo.InsertOneResult, error)
	UpdateUser(user models.User) (*mongo.UpdateResult, error)
	DeleteUser(primitiveUserId primitive.ObjectID) error
}

func NewUserRepository(collection *mongo.Collection) UserRepository {
	return &userRepository{collection}
}

func (ur *userRepository) GetUserById(primitiveUserId primitive.ObjectID) (*models.User, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var user models.User
	err := ur.collection.FindOne(ctx, bson.M{"_id": primitiveUserId}).Decode(&user)

	if err != nil {
		return nil, err
	}

	return &user, nil
}

func (ur *userRepository) GetUsers() (*[]models.User, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)
	defer cancel()

	var users []models.User
	results, err := ur.collection.Find(ctx, bson.M{})

	defer results.Close(ctx)

	for results.Next(ctx) {
		var user models.User
		if err = results.Decode(&user); err != nil {
			return nil, err
		}

		users = append(users, user)
	}

	if err != nil {
		return nil, err
	}

	return &users, nil
}

func (ur *userRepository) CreateUser(newUser models.User) (*mongo.InsertOneResult, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)

	defer cancel()

	result, err := ur.collection.InsertOne(ctx, newUser)

	if err != nil {
		return nil, err
	}
	return result, err
}

func (ur *userRepository) UpdateUser(user models.User) (*mongo.UpdateResult, error) {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)

	defer cancel()

	update := bson.M{"name": user.Name, "age": user.Age}

	result, err := ur.collection.UpdateOne(ctx, bson.M{"_id": user.Id}, bson.M{"$set": update})

	if err != nil {
		return nil, err
	}

	return result, nil
}

func (ur *userRepository) DeleteUser(primitiveUserId primitive.ObjectID) error {
	ctx, cancel := context.WithTimeout(context.Background(), 10*time.Second)

	defer cancel()

	_, err := ur.collection.DeleteOne(ctx, bson.M{"_id": primitiveUserId})

	if err != nil {
		return err
	}

	return nil
}
