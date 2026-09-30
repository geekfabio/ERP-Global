# 07 — Mock API e Autenticação (só login)

Até o backend existir, a app fala com uma **API simulada**. A UI e os repositories são os definitivos; só o *adaptador de rede* é mock. Trocar para a API real = `AppConfig.useMockApi = false` + `baseUrl`.

## Arquitectura

```
UI → Provider (Riverpod) → Repository (interface) → ApiXRepository → ApiClient (Dio)
                                                                   └─ MockApiAdapter  (useMockApi = true)
                                                                       └─ handlers por módulo + estado em memória + fixtures
```

- `core/network/api_client.dart` — Dio, `baseUrl`, interceptors (auth + refresh, erros → `Failure`, logging).
- `core/network/mock/mock_api_adapter.dart` — `HttpClientAdapter` que resolve rotas (`method + path`) para handlers.
- `features/<modulo>/data/mock_api/<modulo>_mock_handlers.dart` — handlers do módulo (registam-se no adapter).
- `features/<modulo>/data/data_mocks/` — fixtures (seed) no **mesmo formato JSON** do futuro backend.
- DTOs com `json_serializable`; nunca passar dados Dart "crus" à UI.
- **Não existe** `Mock...Repository` que devolve listas directas. Só `Api...Repository`.

## Contrato de resposta

Sucesso:
```json
{ "data": { }, "meta": { "page": 1, "pageSize": 20, "total": 312 } }
```
`meta` só em listas. Erro:
```json
{ "error": { "code": "VALIDATION_ERROR", "message": "Dados inválidos", "fields": { "email": "Formato inválido" } } }
```

| HTTP | `code` |
|---|---|
| 400 | `BAD_REQUEST` |
| 401 | `UNAUTHENTICATED`, `TOKEN_EXPIRED`, `INVALID_CREDENTIALS` |
| 403 | `FORBIDDEN`, `MODULE_NOT_LICENSED`, `LICENSE_READ_ONLY` |
| 404 | `NOT_FOUND` |
| 409 | `CONFLICT` (duplicado, estado inválido) |
| 422 | `VALIDATION_ERROR` |
| 500 | `INTERNAL_ERROR` |

Convenções: `GET /v1/<recurso>?page=&pageSize=&sort=campo,-outro&q=&filter[campo]=`; recursos no plural, kebab-case; datas ISO-8601 UTC; dinheiro em `int` (menor unidade); IDs ULID.

## Simulação realista

- Latência configurável (padrão 150–600 ms), determinística por seed nos testes.
- Paginação, ordenação, filtros e pesquisa **no handler** (como o servidor faria).
- Validação 422 por campo; 409 em duplicados (ex.: BI repetido).
- `401 TOKEN_EXPIRED` → o interceptor faz `POST /auth/refresh` e repete o pedido.
- `403` por permissão/âmbito e por licença de módulo.
- Estado **mutável em memória** (POST/PUT/PATCH/DELETE persistem na sessão); `POST /__mock/reset` repõe o seed.
- Flag `chaos` (dev): falhas aleatórias 5xx/timeout para testar estados de erro.
- **Seed determinístico** (mesma seed → mesmos dados): ~300 alunos, ~60 professores, turmas e classes angolanas, notas coerentes por trimestre, cobranças/pagamentos consistentes, nomes e BI plausíveis.

## Autenticação: apenas login

Regras:
- **Sem registo.** Não existe rota, ecrã, botão nem endpoint de sign-up nem de recuperação auto-serviço.
- Contas são criadas por **administração** (`super_admin` ou quem tiver `users.account.create`); reset de password também é feito por admin.
- Única rota pública: `/login`. Qualquer outra redirecciona para `/login` sem sessão.

Endpoints:

| Método | Path | Descrição |
|---|---|---|
| POST | `/v1/auth/login` | `{ identifier, password }` → `{ accessToken, refreshToken, expiresIn, user, roles, permissions, license }` |
| POST | `/v1/auth/refresh` | `{ refreshToken }` → novos tokens |
| POST | `/v1/auth/logout` | invalida refresh token |
| GET | `/v1/auth/me` | utilizador, perfis, permissões, licença |
| POST | `/v1/auth/change-password` | utilizador autenticado (obrigatório se `mustChangePassword`) |
| GET/POST/PATCH | `/v1/users` … | gestão de contas (admin) |
| POST | `/v1/users/{id}/reset-password` | admin gera password temporária |

### Seed de desenvolvimento (só-dev)

| Perfil | Identificador | Password |
|---|---|---|
| `super_admin` | `admin@erp-global.local` | `Admin@12345` |
| restantes 13 perfis | `<perfil>@erp-global.local` | `Dev@12345` |

Estas credenciais existem **apenas** em `auth_mock_data.dart` e só carregam com `useMockApi = true`. Builds de produção não incluem o adaptador mock nem o seed (excluir por `kReleaseMode`/flavor).

### super_admin
Único perfil que: gere licença, cria/desactiva contas e atribui perfis, edita configurações globais, consulta auditoria completa. Nunca pode ser eliminado; tem de existir sempre pelo menos um activo.

## Como um módulo adiciona a sua API mock

1. Definir DTOs e a interface do repository.
2. Criar `ApiXRepository` (Dio).
3. Criar `x_mock_handlers.dart` + fixtures; registar no `MockApiRegistry`.
4. Testes de contrato partilhados: os mesmos testes correm contra o adaptador mock e (futuramente) contra o servidor real.
