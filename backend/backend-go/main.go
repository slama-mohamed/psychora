package main

import (
	"database/sql"
	"log"
	"os"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	_ "github.com/lib/pq"

	"backend/handlers"
	"backend/middleware"
)

func main() {
	// Load .env
	if err := godotenv.Load(); err != nil {
		log.Fatal("Error loading .env file")
	}

	// Connect to Supabase
	db, err := sql.Open("postgres", os.Getenv("DATABASE_URL"))
	if err != nil {
		log.Fatal("Error connecting to database:", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatal("Cannot reach database:", err)
	}
	log.Println("✅ Connected to database")

	// Setup handlers
	h := handlers.NewHandler(db)

	// Setup router
	r := gin.Default()

	// CORS — needed for Flutter
	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Authorization, Content-Type")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	// Public routes
	api := r.Group("/api/psy")
	{
		api.POST("/signup", h.Signup)
		api.POST("/login", h.Login)
	}

	// Protected routes
	protected := r.Group("/api/psy")
	protected.Use(middleware.AuthMiddleware())
	{
		// Auth & User
		protected.GET("/users/me", h.GetCurrentUser)
		protected.PUT("/users/me", h.UpdateCurrentUser)
		protected.POST("/logout", h.Logout)
		// Patients
		protected.GET("/patients", h.GetPatients)
		protected.POST("/patients", h.CreatePatient)
		protected.GET("/patients/:id", h.GetPatient)
		protected.PUT("/patients/:id", h.UpdatePatient)
		protected.DELETE("/patients/:id", h.DeletePatient)

		// Notes — MUST be before /patients/:id routes to avoid conflict
		//protected.GET("/patient-notes", h.GetAllPatientNotes)
		protected.GET("/patients/notes", h.GetAllPatientNotes)
		protected.GET("/patients/notes/:patientId", h.GetPatientNotes)
		protected.PUT("/patients/notes/:patientId", h.SavePatientNote)
		protected.PUT("/patients/:id/notes", h.SavePatientNote)
		protected.POST("/patients/notes", h.SavePatientNote)
		protected.DELETE("/patients/notes/:patientId", h.DeletePatientNote)

		// Conversations
		protected.POST("/conversations/message", h.SendMessage) // ← FIRST
		protected.GET("/conversations/:patientId", h.LoadConversation)
		protected.POST("/conversations", h.SaveConversation)
		protected.DELETE("/conversations/:patientId", h.ClearConversation)
	}

	port := os.Getenv("PORT")
	log.Println("🚀 Server running on port", port)
	r.Run(":" + port)
}
