import os
from urllib.parse import quote_plus
from motor.motor_asyncio import AsyncIOMotorClient
from dotenv import load_dotenv

load_dotenv()
user = quote_plus(os.getenv("MONGO_USER"))
password = quote_plus(os.getenv("MONGO_PASS"))
cluster = os.getenv("MONGO_CLUSTER")
db_name = os.getenv("DB_NAME")

# fmt: off
MONGO_URI = (
    f"mongodb+srv://{user}:{password}@{cluster}/"
    "?retryWrites=true&w=majority"
)
# fmt: on


client = AsyncIOMotorClient(MONGO_URI)
db = client[db_name]
