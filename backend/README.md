# ERP-Global API — contratos e schemas, sem base de dados

Esta fase não utiliza PostgreSQL, Neon, migrations ou ligação a qualquer base de dados. O alvo futuro é PostgreSQL, mas a persistência será implementada apenas após aprovação dos contratos.

## Desenvolvimento

```bash
cd backend
go mod tidy
go test ./...
go run ./cmd/api
```

Rotas nesta fase: `GET /health/live`, `GET /health/ready` e `GET /v1/meta/schema`. Readiness anuncia explicitamente `databaseConnected: false` e `storage: memory`. Não existem endpoints de escrita produtiva nesta etapa.

Os modelos de domínio em `internal/schema/` representam o contrato inicial. As especificações de API existentes estão em `docs/api/openapi.yaml`. Os modelos e contratos precisam de validação conjunta antes da fase de implementação por módulo.

**Regra:** a única entidade administrativa é a instituição, sem divisões institucionais adicionais. Credenciais e segredos nunca entram em fixtures ou no Git.

Ver `docs/11-api-10-phases-agents.md` para plano de execução e responsabilidades dos agentes.
