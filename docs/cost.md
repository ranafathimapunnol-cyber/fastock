# Fastock – Cost Estimation

## Planned Services

| Service | Purpose | Cost |
|---|---|---|
| AWS EC2 | Application hosting | To be verified |
| AWS storage | Persistent storage | To be verified |
| PostgreSQL | Application database | Self-hosted initially |
| pgvector | Vector search | Included with PostgreSQL |
| MongoDB | Agent traces | Local Docker initially |
| Redis | Cache and task broker | Local Docker initially |
| Gemini API | LLM requests | Usage-based |
| GitHub | Source control and CI | Free tier initially |

## Cost Controls
- Use synthetic data.
- Start with local Docker services.
- Set an AWS budget alert before deployment.
- Monitor Gemini token usage.
- Avoid unnecessary cloud resources.

Actual prices and usage will be recorded during implementation.
