package handlers

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
)

// GET /api/psy/conversations/:patientId
func (h *Handler) LoadConversation(c *gin.Context) {
	userID := c.GetString("userID")
	patientID := c.Param("patientId")

	rows, err := h.DB.Query(`
        SELECT role, content, timestamp
        FROM messages
        WHERE patient_id = $1 AND user_id = $2
        ORDER BY created_at ASC`,
		patientID, userID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error fetching messages"})
		return
	}
	defer rows.Close()

	messages := []map[string]interface{}{}
	for rows.Next() {
		var role, content, timestamp string
		if err := rows.Scan(&role, &content, &timestamp); err != nil {
			continue
		}
		messages = append(messages, map[string]interface{}{
			"role":      role,
			"content":   content,
			"timestamp": timestamp,
		})
	}

	c.JSON(http.StatusOK, messages)
}

// POST /api/psy/conversations
// POST /api/psy/conversations/message  ← append a single message
func (h *Handler) SaveConversation(c *gin.Context) {
	userID := c.GetString("userID")

	var req struct {
		PatientID string                   `json:"patientId" binding:"required"`
		Messages  []map[string]interface{} `json:"messages" binding:"required"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	// Delete existing messages first
	_, err := h.DB.Exec(`
        DELETE FROM messages WHERE patient_id = $1 AND user_id = $2`,
		req.PatientID, userID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error clearing old messages"})
		return
	}

	// Re-insert the full history
	for _, msg := range req.Messages {
		role, _ := msg["role"].(string)
		content, _ := msg["content"].(string)
		timestamp, _ := msg["timestamp"].(string)

		_, err := h.DB.Exec(`
            INSERT INTO messages (id, patient_id, user_id, role, content, timestamp, created_at)
            VALUES ($1, $2, $3, $4, $5, $6, NOW())`,
			uuid.New().String(), req.PatientID, userID, role, content, timestamp,
		)
		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{"message": "Error saving messages"})
			return
		}
	}

	c.JSON(http.StatusOK, gin.H{"message": "Conversation saved"})
}

// DELETE /api/psy/conversations/:patientId
func (h *Handler) ClearConversation(c *gin.Context) {
	userID := c.GetString("userID")
	patientID := c.Param("patientId")

	_, err := h.DB.Exec(`
        DELETE FROM messages WHERE patient_id = $1 AND user_id = $2`,
		patientID, userID,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error clearing conversation"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"message": "Conversation cleared"})
}

// POST /api/psy/conversations/message
func (h *Handler) SendMessage(c *gin.Context) {
	userID := c.GetString("userID")

	var req struct {
		PatientID string                   `json:"patientId" binding:"required"`
		Message   string                   `json:"message" binding:"required"`
		History   []map[string]interface{} `json:"history"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"message": err.Error()})
		return
	}

	// Save user message to DB
	_, err := h.DB.Exec(`
        INSERT INTO messages (id, patient_id, user_id, role, content, timestamp, created_at)
        VALUES ($1, $2, $3, 'user', $4, NOW()::text, NOW())`,
		uuid.New().String(), req.PatientID, userID, req.Message,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error saving user message"})
		return
	}

	// Call Python AI
	aiReply, err := callPythonAI(req.Message, req.PatientID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "AI service error: " + err.Error()})
		return
	}

	// Save AI response to DB
	_, err = h.DB.Exec(`
        INSERT INTO messages (id, patient_id, user_id, role, content, timestamp, created_at)
        VALUES ($1, $2, $3, 'assistant', $4, NOW()::text, NOW())`,
		uuid.New().String(), req.PatientID, userID, aiReply,
	)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"message": "Error saving AI response"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"response": aiReply,
	})
}
