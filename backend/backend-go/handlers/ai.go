package handlers

import (
	"bytes"
	"encoding/json"
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
)

type aiRequest struct {
	Message   string `json:"message"`
	SessionID string `json:"session_id"`
}

type aiResponse struct {
	Response string `json:"response"`
}

func callPythonAI(message string, sessionID string) (string, error) {
	pythonURL := os.Getenv("PYTHON_API_URL") + "/chat"

	log.Println("🐍 Calling Python at:", pythonURL)

	payload := aiRequest{
		Message:   message,
		SessionID: sessionID,
	}
	body, _ := json.Marshal(payload)

	resp, err := http.Post(pythonURL, "application/json", bytes.NewBuffer(body))
	if err != nil {
		return "", fmt.Errorf("error calling AI service: %w", err)
	}
	defer resp.Body.Close()

	respBody, _ := io.ReadAll(resp.Body)
	log.Println("🐍 Python raw response:", string(respBody)) // ← ADD THIS
	log.Println("🐍 Python status code:", resp.StatusCode)   // ← AND THIS

	var result aiResponse
	if err := json.Unmarshal(respBody, &result); err != nil {
		return "", fmt.Errorf("error parsing AI response: %w", err)
	}

	log.Println("🐍 AI result:", result.Response)
	return result.Response, nil
}
