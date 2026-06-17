# Sentinel Kafka Lab

A hands-on Kafka learning repository built around the Sentinel v4 fraud detection architecture.

This repository demonstrates an event-driven transaction processing pipeline using Apache Kafka, Python producers/consumers, Docker, PostgreSQL, Redis, and Kafbat UI.

---

## Architecture

Current implementation follows the Stage 0 Walking Skeleton architecture:

```text
Producer
   ↓
transactions.raw
   ↓
Validation Consumer
   ↓
transactions.validated
   ↓
Decision Stub
   ↓
fraud.decisions
   ↓
PostgreSQL
```

The purpose of Stage 0 is to verify that transactions can successfully flow through the system before implementing fraud detection logic.

---

## Components

### API Gateway

* Accepts transaction requests
* Publishes transactions to Kafka
* Topic: `transactions.raw`

### Validation Consumer

* Consumes from `transactions.raw`
* Validates transaction schema
* Publishes valid transactions to `transactions.validated`

### Decision Stub

* Consumes from `transactions.validated`
* Currently returns `ALLOW` for every transaction
* Publishes results to `fraud.decisions`
* Persists decisions to PostgreSQL

### Kafka

Used as the event streaming backbone.

Topics:

* `transactions.raw`
* `transactions.validated`
* `fraud.decisions`

### PostgreSQL

Stores:

* Transactions
* Fraud Decisions

### Redis

Available for future stages.

### Kafbat UI

Kafka monitoring dashboard used to:

* Inspect topics
* View messages
* Monitor consumers
* Track consumer lag

---

## Technology Stack

* Python
* Apache Kafka
* kafka-python
* FastAPI
* PostgreSQL
* Redis
* Docker
* Docker Compose
* Kafbat UI

---

## Running the System

Start all services:

```bash
docker compose up -d --build
```

Check running containers:

```bash
docker ps
```

Open Kafka UI:

```text
http://localhost:8090
```

Open API Documentation:

```text
http://localhost:8000/docs
```

---

## Producing Transactions

### Using Swagger

Navigate to:

```text
http://localhost:8000/docs
```

Use:

```text
POST /transactions
```

### Using Python Producer

Example:

```python
from kafka import KafkaProducer
import json

producer = KafkaProducer(
    bootstrap_servers="localhost:9092",
    value_serializer=lambda v: json.dumps(v).encode()
)

producer.send(
    "transactions.raw",
    {
        "transaction_id": "TXN001",
        "amount": 5000
    }
)

producer.flush()
```

---

## Verifying the Pipeline

Check Kafka topics in Kafbat:

```text
transactions.raw
transactions.validated
fraud.decisions
```

Expected flow:

```text
Producer
   ↓
transactions.raw
   ↓
validation-consumer
   ↓
transactions.validated
   ↓
decision-stub
   ↓
fraud.decisions
```

---

## Future Roadmap

Planned Sentinel v4 modules:

* Watchlist Engine
* Block Manager
* Rule Engine
* Window Engine
* Behavioral Profiler
* Network Graph
* LLM Risk Assessment Gate
* Decision Engine
* Fraud Alerting
* Monitoring & Observability

---

## Learning Objectives

This repository was created to understand:

* Kafka Producers
* Kafka Consumers
* Kafka Topics
* Partitions
* Consumer Groups
* Event-Driven Architecture
* Microservice Communication
* Fraud Detection System Design

---

## Author

Muhammed Nihal

NIT Calicut - Electronics and Communication Engineering
