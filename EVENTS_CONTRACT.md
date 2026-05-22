# Yomu Events Contract

RabbitMQ Exchange: `yomu.events` (topic, durable)

## Overview

All inter-service communication happens via async events published to RabbitMQ.
No direct REST/gRPC calls between backend services.

## Message Format

All events follow this envelope:

```json
{
  "eventId": "uuid",
  "eventType": "quiz.completed",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": { ... }
}
```

Rules:
- `eventId` is globally unique
- `eventType` is stable and documented
- `eventVersion` starts at `1`
- `occurredAt` is when the domain fact occurred, not when it was consumed
- `producer` identifies the owning service
- Consumers must ignore duplicate `eventId` values
- Consumers must reject unknown required fields by dead-lettering or logging and nacking without requeue

## Events From Core

### user.created

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-api
**Routing Key:** `user.created`

```json
{
  "eventId": "uuid",
  "eventType": "user.created",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": {
    "userId": "uuid",
    "username": "student_demo",
    "displayName": "Student Demo",
    "role": "student"
  }
}
```

### user.updated

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-api
**Routing Key:** `user.updated`

```json
{
  "eventId": "uuid",
  "eventType": "user.updated",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": {
    "userId": "uuid",
    "username": "student_demo",
    "displayName": "Student Demo",
    "role": "student"
  }
}
```

### user.deleted

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-api
**Routing Key:** `user.deleted`

```json
{
  "eventId": "uuid",
  "eventType": "user.deleted",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": {
    "userId": "uuid"
  }
}
```

### reading.created

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-api
**Routing Key:** `reading.created`

```json
{
  "eventId": "uuid",
  "eventType": "reading.created",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": {
    "readingId": "uuid",
    "title": "Reading Title",
    "categoryName": "Category"
  }
}
```

### reading.updated

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-api
**Routing Key:** `reading.updated`

```json
{
  "eventId": "uuid",
  "eventType": "reading.updated",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": {
    "readingId": "uuid",
    "title": "Reading Title",
    "categoryName": "Category"
  }
}
```

### reading.deleted

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-api
**Routing Key:** `reading.deleted`

```json
{
  "eventId": "uuid",
  "eventType": "reading.deleted",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": {
    "readingId": "uuid"
  }
}
```

### quiz.completed

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-api
**Routing Key:** `quiz.completed`

```json
{
  "eventId": "uuid",
  "eventType": "quiz.completed",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": {
    "userId": "uuid",
    "readingId": "uuid",
    "score": 80,
    "accuracy": 0.8,
    "completedAt": "2026-05-22T05:00:00Z"
  }
}
```

### reading.completed

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-api
**Routing Key:** `reading.completed`

```json
{
  "eventId": "uuid",
  "eventType": "reading.completed",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-core-api",
  "payload": {
    "userId": "uuid",
    "readingId": "uuid",
    "completedAt": "2026-05-22T05:00:00Z"
  }
}
```

## Events From Gamification

### mission.completed

**Published by:** yomu-gamification-api
**Routing Key:** `mission.completed`

```json
{
  "eventId": "uuid",
  "eventType": "mission.completed",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-gamification-api",
  "payload": {
    "userId": "uuid",
    "missionId": "uuid",
    "xpReward": 10
  }
}
```

### achievement.unlocked

**Published by:** yomu-gamification-api
**Routing Key:** `achievement.unlocked`

```json
{
  "eventId": "uuid",
  "eventType": "achievement.unlocked",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-gamification-api",
  "payload": {
    "userId": "uuid",
    "achievementId": "uuid",
    "achievementName": "Pembaca Pemula"
  }
}
```

### season.ended

**Published by:** yomu-gamification-api (when admin ends a season)
**Routing Key:** `season.ended`

```json
{
  "eventId": "uuid",
  "eventType": "season.ended",
  "eventVersion": 1,
  "occurredAt": "2026-05-22T05:00:00Z",
  "producer": "yomu-gamification-api",
  "payload": {
    "seasonId": "uuid",
    "rankings": [
      { "clanId": "uuid", "clanName": "string", "totalScore": 1500, "newTier": "silver" }
    ]
  }
}
```

## RabbitMQ Topology

- Exchange: `yomu.events` (topic, durable)
- Service-specific queues:
  - `yomu.gamification.events` (for gamification API)
- Routing keys match event types (e.g., `user.created`, `quiz.completed`)

## Consumer Behavior

- Insert `eventId` into `processed_events` before or inside the same transaction as side effects
- If insert conflicts, ack the event and do nothing
- If processing fails because of transient database errors, nack with requeue
- If payload is invalid, nack without requeue and log enough context to debug
- Consumers must be idempotent by `eventId`

## Ownership Rules

- `yomu-core-api` must not have entities, repositories, SQL, or JDBC queries for `gamification.*`
- `yomu-gamification-api` must not query `auth.*` or `quiz.*`
- No database foreign keys may reference tables owned by another service
- Cross-service references use opaque IDs (user_id, reading_id, clan_id)
- A service may maintain local projections of another service's data only through events
- Backend services do not call each other through REST, gRPC, Feign, WebClient, RestTemplate, or direct HTTP clients