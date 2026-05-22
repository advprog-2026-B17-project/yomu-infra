# Yomu Infrastructure

Local development bootstrap and schema documentation for Yomu microservices application.

## Purpose

This repository serves two purposes:

1. **Local Development** - Docker Compose for running RabbitMQ locally
2. **Schema Documentation & Migration Scripts** - SQL files for database schema setup

## Production Infrastructure

Production uses managed services (NOT in this repo):

| Service | Provider |
|---------|----------|
| PostgreSQL | Railway PostgreSQL |
| RabbitMQ | CloudAMQP |
| Frontend | Vercel |
| Backend API | Railway (yomu-core-api) |
| Gamification API | Railway (yomu-gamification-api) |

## Local Development

### Start RabbitMQ locally

```bash
cd yomu-infra
docker-compose up -d
```

RabbitMQ will be available at:
- AMQP: `amqp://guest:guest@localhost:5672`
- Management UI: `http://localhost:15672` (guest/guest)

## Schema Initialization

### For Local Development (using Docker PostgreSQL)

```bash
# Create containers with PostgreSQL
docker-compose up -d postgres rabbitmq

# Connect to PostgreSQL and run schemas
# Auth and Quiz schemas (applied to yomu-core database)
psql -h localhost -U postgres -d postgres -f init-scripts/01-auth-schema.sql
psql -h localhost -U postgres -d postgres -f init-scripts/02-quiz-schema.sql
# Gamification schema (applied to yomu-gamification database)
psql -h localhost -U postgres -d postgres -f init-scripts/03-gamification-schema.sql
```

Note: Each microservice owns its schema. The gamification API should only access `gamification.*` tables, and core API should only access `auth.*` and `quiz.*` tables.

### For Production (Render PostgreSQL)

## Schema Structure

### auth schema
- `users` - User accounts with authentication
- `sessions` - User sessions (if used)

### quiz schema
- `categories` - Reading categories (Politik, Ekonomi, dll)
- `readings` - Reading content with questions
- `questions` - Quiz questions (JSONB options)
- `completed_readings` - User completion records
- `quiz_attempts` - Quiz attempt history

### gamification schema
- `clans` - Clan/team data
- `clan_members` - Clan membership with roles
- `achievements` - Achievement definitions
- `user_achievements` - Unlocked achievements
- `daily_missions` - Mission templates
- `user_missions` - User mission progress
- `buffs` - Active clan buffs/debuffs
- `seasons` - Season management
- `notifications` - User notifications

## Events Contract

See `EVENTS_CONTRACT.md` for RabbitMQ message schemas between services.