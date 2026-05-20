# Yomu Events Contract

RabbitMQ Exchange: `yomu.events` (topic)

## Overview

All inter-service communication happens via async events published to RabbitMQ.
No direct REST/gRPC calls between backend services.

## Message Format

All events follow this envelope:

```json
{
  "eventId": "uuid",
  "eventType": "quiz.completed",
  "timestamp": "2026-05-05T10:00:00Z",
  "payload": { ... }
}
```

## Events

### quiz.completed

**Published by:** yomu-core-api
**Consumer:** yomu-gamification-engine
**Routing Key:** `quiz.completed`

```json
{
  "eventId": "550e8400-e29b-41d4-a716-446655440000",
  "eventType": "quiz.completed",
  "timestamp": "2026-05-05T10:00:00Z",
  "payload": {
    "userId": "uuid",
    "readingId": "uuid",
    "score": 80,
    "accuracy": 0.8,
    "completedAt": "2026-05-05T09:55:00Z"
  }
}
```

### mission.progress

**Published by:** yomu-core-api or yomu-gamification-engine
**Consumer:** yomu-gamification-engine
**Routing Key:** `mission.progress`

```json
{
  "eventId": "550e8400-e29b-41d4-a716-446655440001",
  "eventType": "mission.progress",
  "timestamp": "2026-05-05T10:00:00Z",
  "payload": {
    "userId": "uuid",
    "missionId": "uuid",
    "progress": 1,
    "target": 3
  }
}
```

### achievement.unlocked

**Published by:** yomu-gamification-engine
**Consumer:** yomu-core-api (optional, for notification)
**Routing Key:** `achievement.unlocked`

```json
{
  "eventId": "550e8400-e29b-41d4-a716-446655440002",
  "eventType": "achievement.unlocked",
  "timestamp": "2026-05-05T10:00:00Z",
  "payload": {
    "userId": "uuid",
    "achievementId": "uuid",
    "achievementName": "Pembaca Pemula"
  }
}
```

### season.ended

**Published by:** yomu-core-api (admin triggered)
**Consumer:** yomu-gamification-engine
**Routing Key:** `season.ended`

```json
{
  "eventId": "550e8400-e29b-41d4-a716-446655440003",
  "eventType": "season.ended",
  "timestamp": "2026-05-05T10:00:00Z",
  "payload": {
    "seasonId": "uuid",
    "rankings": [
      { "clanId": "uuid", "clanName": "string", "totalScore": 1500, "newTier": "silver" }
    ]
  }
}
```