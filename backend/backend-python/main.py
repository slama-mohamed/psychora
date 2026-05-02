"""
PsychoLLM Backend FastAPI — URL dynamique
==========================================
Lance avec: py -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload
"""

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import Optional
import httpx
import uuid
from datetime import datetime

# ─────────────────────────────────────────────
# URL Kaggle — modifiable sans redémarrer
# ─────────────────────────────────────────────
kaggle_config = {
    "url": "https://diffident-ezra-unhaltering.ngrok-free.dev"
}

app = FastAPI(title="PsychoLLM API")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# ─────────────────────────────────────────────
# Modèles
# ─────────────────────────────────────────────
class ChatRequest(BaseModel):
    message: str
    session_id: Optional[str] = None

class ChatResponse(BaseModel):
    response: str
    session_id: str
    turn: int
    timestamp: str

class UpdateUrlRequest(BaseModel):
    url: str

# ─────────────────────────────────────────────
# Routes
# ─────────────────────────────────────────────

@app.get("/")
def root():
    return {"message": "PsychoLLM API", "status": "running"}


@app.get("/health")
async def health():
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            r = await client.get(f"{kaggle_config['url']}/health")
            kaggle = r.json()
    except Exception as e:
        kaggle = {"status": "unreachable", "error": str(e)}

    return {
        "fastapi": "ok",
        "kaggle_model": kaggle,
        "kaggle_url": kaggle_config["url"]
    }


@app.post("/update-url")
def update_kaggle_url(req: UpdateUrlRequest):
    """
    Met à jour l'URL ngrok sans redémarrer le serveur.
    Appelé automatiquement depuis Kaggle à chaque relance.
    """
    old_url = kaggle_config["url"]
    kaggle_config["url"] = req.url.rstrip("/")
    print(f"✅ URL mise à jour: {old_url} → {kaggle_config['url']}")
    return {
        "status": "updated",
        "old_url": old_url,
        "new_url": kaggle_config["url"]
    }


@app.post("/chat", response_model=ChatResponse)
async def chat(req: ChatRequest):
    if not req.message.strip():
        raise HTTPException(status_code=400, detail="Message vide")

    session_id = req.session_id or str(uuid.uuid4())

    try:
        async with httpx.AsyncClient(timeout=120.0) as client:
            r = await client.post(
                f"{kaggle_config['url']}/chat",
                json={"message": req.message, "session_id": session_id}
            )

        if r.status_code != 200:
            raise HTTPException(status_code=502, detail=r.text)

        data = r.json()
        return ChatResponse(
            response=data["response"],
            session_id=data["session_id"],
            turn=data.get("turn", 1),
            timestamp=datetime.utcnow().isoformat()
        )

    except httpx.TimeoutException:
        raise HTTPException(status_code=504, detail="Modèle trop lent, réessaie.")
    except httpx.ConnectError:
        raise HTTPException(status_code=503, detail="Kaggle inaccessible.")


@app.delete("/session/{session_id}")
async def reset_session(session_id: str):
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            await client.delete(f"{kaggle_config['url']}/session/{session_id}")
    except Exception:
        pass
    return {"status": "reset", "session_id": session_id}


@app.get("/session/{session_id}")
async def get_session(session_id: str):
    try:
        async with httpx.AsyncClient(timeout=10.0) as client:
            r = await client.get(f"{kaggle_config['url']}/session/{session_id}")
            return r.json()
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
