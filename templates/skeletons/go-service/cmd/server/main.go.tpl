package main

import (
    "context"
    "log"
    "net/http"
    "os"
    "os/signal"
    "syscall"
    "time"

    "github.com/gin-gonic/gin"
    "github.com/joho/godotenv"
    "go.mongodb.org/mongo-driver/mongo"
    "go.mongodb.org/mongo-driver/mongo/options"

    "github.com/$${parameters.destination.owner}}/$${parameters.name}/internal/handlers"
)

func main() {
    // Load environment variables
    if err := godotenv.Load(); err != nil {
        log.Println("No .env file found")
    }

    // Connect to MongoDB
    mongoURI := os.Getenv("MONGODB_URI")
    if mongoURI == "" {
        mongoURI = "mongodb://localhost:27017/$${parameters.name}"
    }

    client, err := mongo.Connect(context.TODO(), options.Client().ApplyURI(mongoURI))
    if err != nil {
        log.Fatal("Failed to connect to MongoDB:", err)
    }
    defer client.Disconnect(context.TODO())

    // Test the connection
    if err = client.Ping(context.TODO(), nil); err != nil {
        log.Fatal("Failed to ping MongoDB:", err)
    }
    log.Println("Connected to MongoDB successfully")

    // Initialize Gin router
    r := gin.Default()

    // Initialize handlers with database
    h := handlers.NewHandler(client.Database("$${parameters.name}"))

    // Routes
    api := r.Group("/api/v1")
    {
        api.GET("/health", h.HealthCheck)
        api.GET("/trips", h.GetTrips)
        api.POST("/trips", h.CreateTrip)
        api.GET("/trips/:id", h.GetTrip)
        api.PUT("/trips/:id", h.UpdateTrip)
        api.DELETE("/trips/:id", h.DeleteTrip)
    }

    // Server setup
    port := os.Getenv("PORT")
    if port == "" {
        port = "8080"
    }

    srv := &http.Server{
        Addr:    ":" + port,
        Handler: r,
    }

    // Start server
    go func() {
        log.Printf("Server starting on port %s", port)
        if err := srv.ListenAndServe(); err != nil && err != http.ErrServerClosed {
            log.Fatalf("Failed to start server: %v", err)
        }
    }()

    // Wait for interrupt signal to gracefully shutdown the server
    quit := make(chan os.Signal, 1)
    signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
    <-quit
    log.Println("Shutting down server...")

    // The context is used to inform the server it has 5 seconds to finish
    ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
    defer cancel()
    if err := srv.Shutdown(ctx); err != nil {
        log.Fatal("Server forced to shutdown:", err)
    }

    log.Println("Server exited")
}