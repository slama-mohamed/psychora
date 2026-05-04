package handlers

import (
	"database/sql"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"golang.org/x/crypto/bcrypt"

	"backend/middleware"
	"backend/models"
)

type Handler struct {
	DB *sql.DB
}

func NewHandler(db *sql.DB) *Handler {
	return &Handler{DB: db}
}

func (h *Handler) Signup(c *gin.Context) {
	var req models.SignupRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	var exists bool
	err := h.DB.QueryRow("SELECT EXISTS(SELECT 1 FROM users WHERE email=$1)", req.Email).Scan(&exists)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Database error"})
		return
	}
	if exists {
		c.JSON(http.StatusConflict, gin.H{"message": "Email already registered"})
		return
	}

	hash, err := bcrypt.GenerateFromPassword([]byte(req.Password), bcrypt.DefaultCost)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error processing password"})
		return
	}

	isStudent := req.IsStudentAccount()

	id := uuid.New().String()
	_, err = h.DB.Exec(`
		INSERT INTO users (id, email, password_hash, full_name, specialty, id_card, hospital, location, phone, years_of_experience, is_student)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)`,
		id, req.Email, string(hash), req.FullName,
		req.Specialty, req.IdCard, req.Hospital,
		req.Location, req.Phone, req.YearsOfExperience, isStudent,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error creating account"})
		return
	}

	role := "doctor"
	if isStudent {
		role = "student"
	}

	c.JSON(http.StatusCreated, gin.H{
		"message": "Account created successfully",
		"role":    role,
	})
}

func (h *Handler) Login(c *gin.Context) {
	var req models.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	var user models.User
	err := h.DB.QueryRow(`
		SELECT id, email, password_hash, full_name, is_student FROM users WHERE email=$1`, req.Email).
		Scan(&user.ID, &user.Email, &user.PasswordHash, &user.FullName, &user.IsStudent)
	if err == sql.ErrNoRows {
		c.JSON(http.StatusUnauthorized, gin.H{"message": "Email or password is incorrect"})
		return
	}
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Database error"})
		return
	}

	if err := bcrypt.CompareHashAndPassword([]byte(user.PasswordHash), []byte(req.Password)); err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"message": "Email or password is incorrect"})
		return
	}

	token, err := middleware.GenerateJWT(user.ID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error generating token"})
		return
	}

	role := "doctor"
	if user.IsStudent {
		role = "student"
	}

	c.JSON(http.StatusOK, gin.H{
		"accessToken": token,
		"role":        role,
		"user": gin.H{
			"id":         user.ID,
			"email":      user.Email,
			"fullName":   user.FullName,
			"is_student": user.IsStudent,
		},
	})
}

func (h *Handler) GetCurrentUser(c *gin.Context) {
	userID := c.GetString("userID")

	var user models.User
	err := h.DB.QueryRow(`
        SELECT id, email, full_name, specialty, hospital, location, phone, years_of_experience, bio, is_student, created_at
        FROM users WHERE id = $1`, userID).
		Scan(&user.ID, &user.Email, &user.FullName, &user.Specialty,
			&user.Hospital, &user.Location, &user.Phone, &user.YearsOfExperience,
			&user.Bio, &user.IsStudent, &user.CreatedAt)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error fetching user"})
		return
	}

	if user.IsStudent {
		c.JSON(http.StatusOK, gin.H{
			"id":         user.ID,
			"email":      user.Email,
			"fullName":   user.FullName,
			"location":   user.Location,
			"phone":      user.Phone,
			"bio":        user.Bio,
			"role":       "student",
			"is_student": true,
			"created_at": user.CreatedAt,
		})
		return
	}

	rows, err := h.DB.Query(`
        SELECT id, name, age, condition, last_seen, sessions_count
        FROM patients WHERE user_id = $1
        ORDER BY created_at DESC`, userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error fetching patients"})
		return
	}
	defer rows.Close()

	patients := []models.Patient{}
	for rows.Next() {
		var p models.Patient
		if err := rows.Scan(&p.ID, &p.Name, &p.Age, &p.Condition, &p.LastSeen, &p.SessionsCount); err != nil {
			continue
		}
		patients = append(patients, p)
	}

	c.JSON(http.StatusOK, gin.H{
		"id":                  user.ID,
		"email":               user.Email,
		"fullName":            user.FullName,
		"specialty":           user.Specialty,
		"hospital":            user.Hospital,
		"location":            user.Location,
		"phone":               user.Phone,
		"years_of_experience": user.YearsOfExperience,
		"bio":                 user.Bio,
		"role":                "doctor",
		"is_student":          false,
		"created_at":          user.CreatedAt,
		"patients":            patients,
		"patients_count":      len(patients),
	})
}

func (h *Handler) UpdateCurrentUser(c *gin.Context) {
	userID := c.GetString("userID")

	var req struct {
		FullName          string `json:"fullName"`
		Email             string `json:"email"`
		Phone             string `json:"phone"`
		Location          string `json:"location"`
		Specialty         string `json:"specialty"`
		Hospital          string `json:"hospital"`
		YearsOfExperience int    `json:"yearsOfExperience"`
		Bio               string `json:"bio"`
	}

	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	var user models.User
	err := h.DB.QueryRow(`
        UPDATE users SET
            full_name = COALESCE(NULLIF($1, ''), full_name),
            email = COALESCE(NULLIF($2, ''), email),
            phone = COALESCE(NULLIF($3, ''), phone),
            location = COALESCE(NULLIF($4, ''), location),
            specialty = COALESCE(NULLIF($5, ''), specialty),
            hospital = COALESCE(NULLIF($6, ''), hospital),
            years_of_experience = CASE WHEN $7 = 0 THEN years_of_experience ELSE $7 END,
            bio = COALESCE(NULLIF($8, ''), bio)
        WHERE id = $9
        RETURNING id, email, full_name, specialty, hospital, location, phone, years_of_experience, bio, is_student, created_at`,
		req.FullName, req.Email, req.Phone, req.Location,
		req.Specialty, req.Hospital, req.YearsOfExperience, req.Bio, userID,
	).Scan(&user.ID, &user.Email, &user.FullName, &user.Specialty,
		&user.Hospital, &user.Location, &user.Phone, &user.YearsOfExperience,
		&user.Bio, &user.IsStudent, &user.CreatedAt)

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error updating profile"})
		return
	}

	c.JSON(http.StatusOK, user)
}

func (h *Handler) Logout(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{"message": "Logged out successfully"})
}