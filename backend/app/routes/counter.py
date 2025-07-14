from fastapi import APIRouter, HTTPException
from app.models import CounterIn, CounterOut
from app.database import db
from bson import ObjectId

router = APIRouter()


@router.get("/counters", response_model=list[CounterOut])
async def get_counters():
    counters = await db.counters.find().to_list(100)
    return [
        CounterOut(id=str(c["_id"]), name=c["name"], count=c["count"]) for c in counters
    ]


@router.get("/counters/{counter_id}", response_model=CounterOut)
async def get_counter(counter_id: str):
    counter = await db.counters.find_one({"_id": ObjectId(counter_id)})
    if counter is None:
        raise HTTPException(status_code=404, detail="Counter not found")
    return CounterOut(
        id=str(counter["_id"]), name=counter["name"], count=counter["count"]
    )


@router.post("/counters", response_model=CounterOut)
async def create_counter(counter: CounterIn):
    doc = counter.model_dump()
    doc["_id"] = ObjectId()
    await db.counters.insert_one(doc)
    return CounterOut(id=str(doc["_id"]), **counter.model_dump())


@router.put("/counters/{counter_id}", response_model=dict)
async def update_counter(counter_id: str, counter: CounterIn):
    result = await db.counters.update_one(
        {"_id": ObjectId(counter_id)}, {"$set": counter.model_dump()}
    )
    if result.modified_count == 0:
        raise HTTPException(status_code=404, detail="Counter not found")
    return {"message": "Counter updated"}


@router.delete("/counters/{counter_id}", response_model=dict)
async def delete_counter(counter_id: str):
    result = await db.counters.delete_one({"_id": ObjectId(counter_id)})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Counter not found")
    return {"message": "Counter deleted"}
