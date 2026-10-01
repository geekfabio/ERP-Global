# 09 — Contratos de API (OpenAPI) e fallback local

Contrato com a equipa de backend: [`docs/api/openapi.yaml`](api/openapi.yaml) (OpenAPI 3.0.3). Cobre autenticação (`login`/`refresh`) e **alunos** (`/v1/students`); os restantes módulos seguem o mesmo envelope, convenções e códigos de erro de [07-mock-api.md](07-mock-api.md) e serão acrescentados à medida que forem integrados.

## Regras do contrato

- Envelope `{data, meta}` / `{error:{code,message,fields}}`; códigos e HTTP em 07-mock-api.md.
- Datas ISO-8601 UTC (`birthDate` só data), IDs ULID gerados no cliente, dinheiro em `int`.
- Listas: `page`, `pageSize` (máx. 100), `q`, `sort=campo,-outro`, `filter[campo]`; paginação/ordenação/filtros **no servidor**.
- Duplicados: BI repetido → `409 CONFLICT` sempre; nome + data de nascimento só com `confirmDuplicate=true`.
- Sem registo público: só `/v1/auth/login` e `/v1/auth/refresh` são abertas.

## Cliente (`lib/core/network`)

`ApiClient` (Dio) aplica, por ordem: log → **auth** (Bearer; em `401 TOKEN_EXPIRED` faz `POST /v1/auth/refresh` uma só vez e repete o pedido; refresh falhado limpa os tokens) → **erros** (envelope ou falha de rede → `Failure` em `DioException.error`).

## Alunos: API com fallback local

`ApiStudentRepository` (Dio) é a implementação por omissão. Com `--dart-define=LOCAL_FALLBACK=true`, o `studentRepositoryProvider` devolve `FallbackStudentRepository`: tenta a API e, **só** em `NetworkFailure` (`NETWORK_ERROR`/`TIMEOUT`), repete a operação no `DriftStudentRepository` (que escreve na outbox para sincronizar depois). Erros do servidor (401/403/404/409/422/5xx) nunca disparam o fallback. `USE_LOCAL_DB=true` continua a forçar só Drift.

## Contract tests

`test/features/students/students_contract_test.dart` define a suite sobre a interface `StudentRepository` e corre-a contra a Mock API; a mesma suite deve correr contra o servidor real (trocar a fábrica do repository).
