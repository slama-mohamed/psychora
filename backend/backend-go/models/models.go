package models

import "time"

type User struct {
	ID                string    `json:"id" db:"id"`
	Email             string    `json:"email" db:"email"`
	PasswordHash      string    `json:"-" db:"password_hash"`
	FullName          string    `json:"full_name" db:"full_name"`
	Specialty         string    `json:"specialty" db:"specialty"`
	IdCard            string    `json:"idCard" db:"id_card"`
	Hospital          string    `json:"hospital" db:"hospital"`
	Location          string    `json:"location" db:"location"`
	Phone             string    `json:"phone" db:"phone"`
	YearsOfExperience int       `json:"years_of_experience" db:"years_of_experience"`
	CreatedAt         time.Time `json:"created_at" db:"created_at"`
	Bio               string    `json:"bio" db:"bio"`
}

type Conversation struct {
	ID        string    `json:"id" db:"id"`
	UserID    string    `json:"user_id" db:"user_id"`
	PatientID string    `json:"patient_id" db:"patient_id"`
	Title     string    `json:"title" db:"title"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
}

type CreateConversationRequest struct {
	PatientID string `json:"patient_id" binding:"required"`
	Title     string `json:"title"`
}

// Request/Response structs
type SignupRequest struct {
	FullName          string `json:"fullName" binding:"required"`
	Email             string `json:"email" binding:"required,email"`
	Password          string `json:"password" binding:"required,min=6"`
	Role              string `json:"role"`
	Specialty         string `json:"specialty"`
	IdCard            string `json:"idCard"`
	Hospital          string `json:"hospital"`
	Location          string `json:"location"`
	Phone             string `json:"phone"`
	YearsOfExperience int    `json:"yearsOfExperience"`
}

type AuthResponse struct {
	AccessToken string `json:"accessToken"` // must be "accessToken" not "token"
	User        User   `json:"user"`
}

type LoginRequest struct {
	Email    string `json:"email" binding:"required,email"`
	Password string `json:"password" binding:"required"`
}

// Add this to models/models.go

type Patient struct {
	ID            string    `json:"id" db:"id"`
	UserID        string    `json:"user_id" db:"user_id"`
	Name          string    `json:"name" db:"name"`
	Age           int       `json:"age" db:"age"`
	Condition     string    `json:"condition" db:"condition"`
	LastSeen      string    `json:"lastSeen" db:"last_seen"`
	SessionsCount int       `json:"sessionsCount" db:"sessions_count"`
	CreatedAt     time.Time `json:"created_at" db:"created_at"`
}

type CreatePatientRequest struct {
	Name          string `json:"name" binding:"required"`
	Age           int    `json:"age"`
	Condition     string `json:"condition"`
	LastSeen      string `json:"lastSeen"`
	SessionsCount int    `json:"sessionsCount"`
}

type UpdatePatientRequest struct {
	Name          string `json:"name"`
	Age           int    `json:"age"`
	Condition     string `json:"condition"`
	LastSeen      string `json:"lastSeen"`
	SessionsCount int    `json:"sessionsCount"`
}
type MessagePayload struct {
	Role      string `json:"role"`
	Content   string `json:"content"`
	Timestamp string `json:"timestamp"`
}
