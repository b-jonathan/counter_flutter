# main.py
from fastapi import FastAPI

from app.routes import counter

app = FastAPI()

app.include_router(counter.router)
