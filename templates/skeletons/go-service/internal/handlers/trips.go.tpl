package handlers

import (
    "context"
    "net/http"
    "time"

    "github.com/gin-gonic/gin"
    "go.mongodb.org/mongo-driver/bson"
    "go.mongodb.org/mongo-driver/bson/primitive"
    "go.mongodb.org/mongo-driver/mongo"

    "github.com/$${parameters.destination.owner}}/$${parameters.name}/pkg/models"
)

type Handler struct {
    db *mongo.Database
}

func NewHandler(db *mongo.Database) *Handler {
    return &Handler{db: db}
}

func (h *Handler) HealthCheck(c *gin.Context) {
    c.JSON(http.StatusOK, gin.H{
        "status":    "healthy",
        "timestamp": time.Now().Format(time.RFC3339),
        "service":   "$${parameters.name}",
    })
}

func (h *Handler) GetTrips(c *gin.Context) {
    collection := h.db.Collection("trips")
    cursor, err := collection.Find(context.TODO(), bson.M{})
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }
    defer cursor.Close(context.TODO())

    var trips []models.Trip
    if err = cursor.All(context.TODO(), &trips); err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, trips)
}

func (h *Handler) CreateTrip(c *gin.Context) {
    var trip models.Trip
    if err := c.ShouldBindJSON(&trip); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    trip.ID = primitive.NewObjectID()
    trip.CreatedAt = time.Now()
    trip.UpdatedAt = time.Now()

    collection := h.db.Collection("trips")
    result, err := collection.InsertOne(context.TODO(), trip)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    trip.ID = result.InsertedID.(primitive.ObjectID)
    c.JSON(http.StatusCreated, trip)
}

func (h *Handler) GetTrip(c *gin.Context) {
    id := c.Param("id")
    objectID, err := primitive.ObjectIDFromHex(id)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
        return
    }

    collection := h.db.Collection("trips")
    var trip models.Trip
    err = collection.FindOne(context.TODO(), bson.M{"_id": objectID}).Decode(&trip)
    if err != nil {
        if err == mongo.ErrNoDocuments {
            c.JSON(http.StatusNotFound, gin.H{"error": "Trip not found"})
            return
        }
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    c.JSON(http.StatusOK, trip)
}

func (h *Handler) UpdateTrip(c *gin.Context) {
    id := c.Param("id")
    objectID, err := primitive.ObjectIDFromHex(id)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
        return
    }

    var trip models.Trip
    if err := c.ShouldBindJSON(&trip); err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
        return
    }

    trip.UpdatedAt = time.Now()
    update := bson.M{"$set": trip}

    collection := h.db.Collection("trips")
    result, err := collection.UpdateOne(context.TODO(), bson.M{"_id": objectID}, update)
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    if result.MatchedCount == 0 {
        c.JSON(http.StatusNotFound, gin.H{"error": "Trip not found"})
        return
    }

    trip.ID = objectID
    c.JSON(http.StatusOK, trip)
}

func (h *Handler) DeleteTrip(c *gin.Context) {
    id := c.Param("id")
    objectID, err := primitive.ObjectIDFromHex(id)
    if err != nil {
        c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid trip ID"})
        return
    }

    collection := h.db.Collection("trips")
    result, err := collection.DeleteOne(context.TODO(), bson.M{"_id": objectID})
    if err != nil {
        c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
        return
    }

    if result.DeletedCount == 0 {
        c.JSON(http.StatusNotFound, gin.H{"error": "Trip not found"})
        return
    }

    c.JSON(http.StatusOK, gin.H{"message": "Trip deleted successfully"})
}