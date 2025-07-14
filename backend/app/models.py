# app/models.py
from pydantic import BaseModel


class CounterIn(BaseModel):
    name: str
    count: int = 0


class CounterOut(CounterIn):
    id: str
