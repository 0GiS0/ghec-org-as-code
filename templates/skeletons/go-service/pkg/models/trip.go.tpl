package models

import (
    "time"
    "go.mongodb.org/mongo-driver/bson/primitive"
)

type Trip struct {
    ID          primitive.ObjectID `json:"id" bson:"_id,omitempty"`
    Name        string             `json:"name" bson:"name" binding:"required"`
    Description string             `json:"description" bson:"description"`
    Location    string             `json:"location" bson:"location" binding:"required"`
    Price       float64            `json:"price" bson:"price" binding:"required,gt=0"`
    Duration    int                `json:"duration" bson:"duration" binding:"required,gt=0"` // in hours
    MaxGuests   int                `json:"max_guests" bson:"max_guests" binding:"required,gt=0"`
    Available   bool               `json:"available" bson:"available"`
    Tags        []string           `json:"tags" bson:"tags"`
    CreatedAt   time.Time          `json:"created_at" bson:"created_at"`
    UpdatedAt   time.Time          `json:"updated_at" bson:"updated_at"`
}