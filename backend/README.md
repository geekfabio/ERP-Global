# ERP-Global API (Go)

Backend no mesmo repositório do Flutter, com serviços organizados por instituição.

## Stack
- Go 1.24, Gin, PostgreSQL, pgx
- Migrações SQL pelo goose (CLI)
- Contrato HTTP existente em `docs/api/openapi.yaml`

## Desenvolvimento
1. Copiar `deploy/.env.example` para `deploy/.env` e substituir a palavra-passe.
2. Executar `docker compose --env-file deploy/.env -f deploy/docker-compose.yml up --build -d`.
3. Testar `curl http://127.0.0.1:8080/health/live` e `/health/ready`.
4. Instalar goose e aplicar `backend/db/migrations/` ao PostgreSQL antes de implementar os endpoints de identidade.
5. Executar `cd backend && go mod tidy && go test ./...`.

A API ainda não implementa login nem operações académicas. Os endpoints de health e as migrações são a fundação. Não expor a porta da API publicamente sem TLS, autenticação e regras de rede adequadas.

## Convenções
- Apenas a entidade `institution` / `institution_id` para segregação administrativa.
- Não aceitar um `institution_id` livre fornecido pelo cliente para autorizar operações.
- ULIDs, UTC, valores monetários em inteiros na menor unidade.
- Erros compatíveis com o contrato de `docs/07-mock-api.md`.
- Manter o Flutter actual e trocar os mocks progressivamente após testes de contrato.
