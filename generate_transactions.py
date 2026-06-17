from kafka import KafkaProducer
import json
import random
from datetime import datetime

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode()
)

for i in range(1000):
    txn = {
        "transaction_id": f"TXN{i}",
        "channel": random.choice(["AEPS", "DMT", "UPI"]),
        "amount": random.randint(100, 100000),
        "sender_id": f"USER{random.randint(1,100)}",
        "beneficiary_id": f"BEN{random.randint(1,100)}",
        "device_id": f"DEV{random.randint(1,20)}",
        "ip_address": f"192.168.1.{random.randint(1,255)}",
        "created_at": datetime.utcnow().isoformat() + "Z"
    }

    producer.send("transactions.raw", txn)

producer.flush()

print("1000 transactions sent")