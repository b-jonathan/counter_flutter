# main.py
from fastapi import FastAPI

from app.routes import counter

app = FastAPI()


@app.get("/health")
def health():
    return {"ok": True}


app.include_router(counter.router)
