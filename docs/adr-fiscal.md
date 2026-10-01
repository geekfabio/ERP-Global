# ADR-001 — Numeração fiscal, SAF-T (AO) e assinatura de documentos

| | |
|---|---|
| **Estado** | Proposta — a aguardar aprovação da equipa backend |
| **Issue** | #94 (depende de #55 facturas/notas de crédito; relacionado com #56 recibos, #83 outbox, #84 modos de sync) |
| **Âmbito** | Módulo `billing` (docs/02) e transversais de docs/06 |
| **Decisores** | Equipa backend (aprovação), equipa cliente Flutter (revisão) |

> Este documento é uma **proposta**. As referências legais angolanas (AGT, regime jurídico das facturas, esquema SAF-T (AO), certificação de software) são citadas de memória como ponto de partida e **têm de ser confirmadas** pelo backend/jurídico/contabilidade antes da aprovação (ver secção 6).

## 1. Contexto

docs/06 (Regras transversais) já fixa: documentos fiscais são imutáveis (correcção por novo documento), "servidor decide" para financeiro/numeração fiscal, e "numeração fiscal atribuída pelo servidor / série local reservada por dispositivo (definir com backend)". Este ADR concretiza esse ponto.

### 1.1 O que o cliente faz hoje

- **Facturas e notas de crédito (#55)** — `lib/features/billing/data/mock_api/invoice_mock_handlers.dart`: `POST /v1/invoices` emite com série `FT <ano>` e número `FT 2026/000001`; `POST /v1/invoices/{id}/cancel` exige `reason`, cria nota de crédito de série `NC <ano>` (`NC 2026/000001`) pelo valor total e marca a factura `cancelled`. `PATCH/PUT/DELETE` devolvem 409 (imutável). O formato vem de `formatDocumentNumber(series, seq)` em `domain/invoicing.dart`.
- **Recibos (#56)** — `payment_mock_handlers.dart`: série `RC <ano>`, mesmo contador em memória; pagamentos com saldo pré-pago não geram recibo.
- A sequência é um `Map<String,int>` **em memória do mock** (`_sequences`), por série `<prefixo> <ano>`. Não há série por dispositivo, nem por campus, nem persistência, nem relógio do servidor (usa `DateTime.now().toUtc()` do cliente/mock).
- Os modelos `Invoice`/`CreditNote`/`Receipt` têm `number`, `series`, `issuedAt`, `status`, mas **não têm** hash, assinatura, chave, tipo de documento fiscal, NIF do cliente, data de registo no sistema (`systemEntryDate`) nem ligação à certificação.
- **Sync (#83/#84)** — `lib/core/sync`: outbox por registo (`create/update/delete`, coalescência, estado `error` que bloqueia o registo), `POST /v1/sync/push`, `GET /v1/sync/{entity}/{id}`, `ConflictPolicies` com `serverWins` para `invoice`, `payment`, `receipt`, `fiscal_document`, etc.; modos `localOnly | cloudBackup | cloudSync` (`cloud_sync` é módulo licenciado; sem licença nada sai do dispositivo). Hoje só `students` tem repositório Drift/binding; billing é 100 % mock em memória.
- Não existe nada de SAF-T, assinatura, QR/ATCUD equivalente, nem identificação de dispositivo fiscal.

### 1.2 Lacuna para produção

1. Numeração sem garantia de sequência única/sem falhas em ambiente real (concorrência, vários dispositivos/campus, offline).
2. Sem cadeia de hashes nem assinatura: documentos não são verificáveis nem certificáveis.
3. Sem exportação SAF-T (AO) nem dados mestre exigidos (NIF, clientes, produtos/serviços, impostos).
4. Sem modelo para emissão offline: se `billing` for usado sem rede (sobretudo em modo `localOnly`) não há como emitir números definitivos.
5. Relógio: o cliente pode ter data errada; documentos fiscais exigem data/hora fiável.

## 2. Decisão proposta — Numeração fiscal

**D1. Quem numera.** O **backend é a única autoridade de numeração definitiva e de assinatura**. O cliente nunca assina nem produz número fiscal definitivo por si.

**D2. Tipos e séries.** Tipos de documento (códigos SAF-T entre parênteses, a confirmar): `FT` factura, `FR` factura-recibo, `NC` nota de crédito, `ND` nota de débito, `RC` recibo (`RG` no SAF-T). Formato do número: `<TIPO> <SÉRIE>/<SEQ>`, onde a série codifica tipo + ano fiscal + origem:

```
FT 2026A/000001      -- série "2026A" = ano 2026, origem A
FT 2026B/000001      -- série "2026B" = ano 2026, origem B
```

Mantém-se o `FT 2026/000001` actual como série "central" (origem do servidor/web). Recomenda-se **um identificador curto de origem** (`deviceSeriesCode`, ex.: letra/2 dígitos) atribuído pelo backend a cada dispositivo registado (ver secção 5). Séries independentes por `(institutionId, campusId?, tipo, anoFiscal, origem)`; cada série tem a sua sequência **contígua a partir de 1**, sem falhas.

**D3. Regras invioláveis.**
- Sequência **sem saltos**; a atribuição é atómica com a persistência do documento (mesma transacção).
- **Nunca reutilizar um número**, mesmo de documento anulado ou rejeitado. Não existe "apagar" documento emitido (soft delete proibido para documentos fiscais finais).
- Número é atribuído **na emissão definitiva** (não em rascunho). Rascunhos (`draft`) não consomem número.
- Datas do documento não retrocedem dentro da mesma série (data do documento ≥ a do anterior).
- Nova série por ano fiscal (reinício a 1); a série fecha no fim do exercício (`FiscalYear` já existe no modelo contabilístico, #60).

**D4. Anulação.** Documento emitido é imutável. Anulação = **nota de crédito** (`NC`) que referencia o documento original (`reference`), com `reason` obrigatório; o original passa a `cancelled` apenas como *estado derivado* (campo de controlo, sem alterar conteúdo assinado). Recibos anulados → estorno via novo documento/`reversed` no pagamento, também com número próprio. Correcção de valores = NC + nova factura. Mantém o comportamento actual do cliente.

**D5. Impostos.** IVA em pontos base (`taxRateBp`, já existente) e `exemptionReason` obrigatório para taxa 0 (já validado). O backend mapeia para os códigos de isenção do SAF-T.

## 3. Decisão proposta — SAF-T (AO)

**D6. Responsabilidade.** O backend **gera, valida e arquiva** o ficheiro SAF-T (AO) (XML) — é o único com a série completa, hashes e dados mestre consistentes. O cliente: pede a geração, mostra estado/erros, descarrega o ficheiro e assina nada. Não gerar SAF-T no cliente (dados parciais por dispositivo; risco de divergência).

**D7. Escopo (a confirmar com contabilidade/AGT).** `Header` (NIF, nome, morada, ano fiscal, período, software/versão/certificado), `MasterFiles` (`Customer`, `Product/Service` — rubricas de `FeeItem`, `TaxTable`, plano de contas se exigido), `SourceDocuments` (`SalesInvoices` — FT/FR/NC/ND, `Payments` — recibos, com `Hash`, `HashControl`, `DocumentStatus`, `SystemEntryDate`, linhas e impostos). Contabilidade (`GeneralLedgerEntries`) **fora de âmbito da v1**, a decidir depois (módulo `accounting` é add-on).

**D8. Periodicidade.** Exportação **mensal** por período (`YYYY-MM`) com possibilidade de re-gerar o mesmo período (versão nova do ficheiro, histórico guardado). Submissão à AGT é acto do contribuinte (portal AGT) na v1; integração directa fica em aberto.

**D9. Campos obrigatórios a acrescentar ao modelo** (nos DTOs de `Invoice`, `CreditNote`, `Receipt`): `documentType`, `hash`, `hashControl` (versão da chave), `previousHash` (opcional no payload), `systemEntryDate` (UTC, servidor), `documentDate`, `customerTaxId` (NIF; "consumidor final" quando aplicável), `customerName`, `reference` (NC/ND), `status` (`N` normal / `A` anulado / `F` facturado, conforme SAF-T), `sourceId` (utilizador) e `series.originCode`. O cliente só os consome; é o backend que os preenche.

## 4. Decisão proposta — Assinatura, hash e certificação

**D10. Cadeia de hashes.** Por série, cada documento assina a concatenação `documentDate;systemEntryDate;documentNumber;grossTotal;hashDoDocumentoAnterior` (hash anterior vazio no 1.º da série) com **RSA-SHA1/assinatura PKCS#1 v1.5 em base64**, conforme regime angolano (a confirmar; se a AGT tiver migrado para SHA-256 usar o exigido). O documento mostra 4 caracteres do hash (posições 1.ª, 11.ª, 21.ª e 31.ª) + referência de certificação, na impressão/PDF.

**D11. Quem assina.** **Backend**, com chave privada RSA por instituição (ou por NIF emissor) guardada em HSM/KMS; a chave pública é registada na certificação. O cliente **nunca** recebe nem armazena a chave. Rotação por `hashControl`/versão de chave sem quebrar a cadeia (o documento guarda a versão usada).

**D12. Certificação.** O software tem de estar certificado/validado pela AGT (número de certificação/validação no `Header` SAF-T e no rodapé dos PDFs). Responsável pelo processo: backend/negócio. O cliente expõe `softwareCertificateNo` vindo de `GET /v1/fiscal/config` para o rodapé dos PDFs (hoje inexistente em `lib/core/pdf`).

**D13. Imutabilidade verificável.** Endpoint de verificação de integridade da cadeia (`GET /v1/fiscal/series/{id}/verify`) usado pela auditoria; alteração de qualquer campo assinado é rejeitada com 409.

## 5. Impacto offline-first

Princípio: **o servidor decide**; o cliente reserva capacidade e emite *provisoriamente* quando está offline.

**D14. Séries por dispositivo.** Cada dispositivo (ligado ao registo de `AccessDevice`/instalação, a definir) é registado no backend (`POST /v1/fiscal/devices`) e recebe `deviceSeriesCode`. Séries são independentes por dispositivo → sem colisões entre caixas offline em simultâneo.

**D15. Reserva de intervalos.** O dispositivo, quando online, pede um **bloco de números** por série (`POST /v1/fiscal/series/{id}/reserve`, p.ex. 50–200). Os números do bloco são consumidos localmente por ordem. Blocos não usados ao fim do ano/quando o dispositivo é retirado têm de ser **devolvidos ou inutilizados com documento de anulação "N/A"** — nunca saltos silenciosos (decisão em aberto, secção 6). O cliente renova quando restar < 20 %.

**D16. Emissão provisória vs. definitiva.**
- Online com rede: `POST /v1/invoices` → backend atribui número, assina, devolve documento definitivo.
- Offline: o cliente cria documento com `fiscalState = provisional`, ID ULID local, **sem número fiscal nem hash**, e mostra/imprime um **comprovativo provisório** claramente marcado "Documento não fiscal — sem valor de factura". Entra na outbox (`entity: fiscal_document`) com `Idempotency-Key = id` ULID.
- Ao sincronizar, o backend numera, assina e devolve o definitivo; o cliente substitui (política `serverWins`). Só então se imprime a factura fiscal.
- Alternativa com blocos reservados (opção B abaixo) permite emitir número definitivo offline, mas só com assinatura diferida — **dependente de a lei permitir emissão sem assinatura imediata** (questão aberta, crítica).

**D17. Ordem e conflitos.** O backend processa a outbox de cada dispositivo **por `seq`** e atribui números segundo a ordem de chegada dentro da série do dispositivo. Idempotência por `id` (ULID): reenvio devolve o mesmo documento (200, nunca duplica). Conflitos: `serverWins` (já configurado para `invoice`, `receipt`, `fiscal_document`); o cliente não faz merge por campo de documentos fiscais. Falha de validação → 422, a entrada fica em `error` (já bloqueia o registo) e exige acção do utilizador (corrigir via NC). `create` + `delete` local de um provisório nunca chegou ao servidor → descartado sem número (coalescência actual do outbox serve).

**D18. Relógio/UTC.** `systemEntryDate` e hora legal do documento são **do servidor (UTC)**; o cliente envia `clientCreatedAt` apenas informativo, e o servidor guarda `clientClockSkew`. Se o dispositivo estiver offline, a `documentDate` provisória é a local, mas o definitivo fixa a data de sincronização como `systemEntryDate`; se a data legal do documento tiver de coincidir com a emissão, alterar `documentDate` na conversão (a decidir). O cliente deve avisar quando o desvio do relógio (medido na última chamada, cabeçalho `Date`) for > 5 min e bloquear emissão acima de um limite (ex.: 24 h). Datas: ISO-8601 UTC (já convenção de docs/07); apresentação em `Africa/Luanda` (UTC+1).

**D19. Modos de sync (#84).** Emissão fiscal definitiva exige o backend, logo:
- `localOnly` **não é compatível** com emissão fiscal em produção → `billing` fiscal exige modo `cloudSync` ou `cloudBackup`+rede (tratar como requisito de licenciamento do módulo; a decidir se o plano com `billing` implica `cloud_sync`).
- `cloudBackup`/`cloudSync`: emissão provisória offline + sync como acima.
- O mock actual (`localOnly`/numeração em memória) mantém-se **só em dev**.

## 6. Contratos de API propostos (estilo docs/07)

Envelope e erros como em docs/07 (`{ "data": ... }`, `{ "error": { code, message, fields } }`); novos códigos: `409 SERIES_EXHAUSTED`, `409 NUMBER_RANGE_CONFLICT`, `409 DOCUMENT_IMMUTABLE`, `422 INVALID_TAX_ID`, `409 CLOCK_SKEW`, `403 FISCAL_NOT_CONFIGURED`. Dinheiro em `int` (menor unidade). Cabeçalho `Idempotency-Key` em POSTs de emissão.

| Método | Path | Descrição |
|---|---|---|
| GET | `/v1/fiscal/config` | NIF emissor, `softwareCertificateNo`, versão de chave, regras activas |
| POST | `/v1/fiscal/devices` | regista dispositivo → `{ id, deviceSeriesCode }` |
| GET | `/v1/fiscal/series` | séries (`type`, `year`, `deviceId`, `lastNumber`, `status`) |
| POST | `/v1/fiscal/series/{id}/reserve` | reserva bloco de números |
| POST | `/v1/fiscal/series/{id}/release` | devolve/inutiliza números não usados |
| GET | `/v1/fiscal/series/{id}/verify` | verifica cadeia de hashes |
| POST | `/v1/invoices` | emite factura definitiva (já existe; payload alargado) |
| POST | `/v1/invoices/{id}/cancel` | anula via NC (já existe) |
| POST | `/v1/sync/push` | idem #83; `entity: fiscal_document` com `serverWins` |
| POST | `/v1/saft/exports` | pede exportação de um período |
| GET | `/v1/saft/exports` / `/{id}` | estado e metadados |
| GET | `/v1/saft/exports/{id}/file` | descarrega XML |

Reserva de intervalo:

```json
POST /v1/fiscal/series/01J...S/reserve
{ "deviceId": "01J...D", "count": 100 }
→ 201
{ "data": { "seriesId": "01J...S", "series": "FT 2026A", "from": 101, "to": 200,
            "expiresAt": "2026-12-31T23:59:59Z" } }
```

Emissão (online):

```json
POST /v1/invoices          Idempotency-Key: 01J...F
{ "id": "01J...F", "studentId": "...", "chargeIds": ["..."], "taxRateBp": 1400,
  "exemptionReason": null, "customerTaxId": "5417000000",
  "deviceId": "01J...D", "clientCreatedAt": "2026-03-02T09:14:00Z" }
→ 201
{ "data": { "id": "01J...F", "documentType": "FT", "series": "FT 2026A",
            "number": "FT 2026A/000101", "status": "issued", "fiscalState": "final",
            "documentDate": "2026-03-02", "systemEntryDate": "2026-03-02T09:14:07Z",
            "totalMinor": 5700000, "taxMinor": 700000,
            "hash": "base64...", "hashControl": "1",
            "lines": [ ... ] } }
```

Sincronização de documento provisório (via push; resposta com definitivo):

```json
POST /v1/sync/push
{ "entity": "fiscal_document", "entityId": "01J...F", "operation": "create",
  "payload": { "documentType": "FT", "fiscalState": "provisional", "...": "..." } }
→ 200
{ "data": { "applied": true, "record": { "number": "FT 2026A/000102", "hash": "...", "fiscalState": "final" } } }
```

Exportação SAF-T:

```json
POST /v1/saft/exports  { "period": "2026-03", "kind": "invoicing" }
→ 202 { "data": { "id": "01J...X", "status": "processing", "period": "2026-03" } }
GET  /v1/saft/exports/01J...X
→ 200 { "data": { "status": "ready", "version": 2, "issues": [], "fileUrl": "/v1/saft/exports/01J...X/file" } }
```

Permissões novas (nomenclatura docs/01): `billing.fiscal.manage`, `billing.saft.export`; `licença`: módulo `billing` (docs/02); `403 MODULE_NOT_LICENSED` aplica-se.

## 7. Alternativas consideradas

| Opção | Descrição | Prós | Contras |
|---|---|---|---|
| **A (recomendada)** | Servidor numera e assina; offline = provisório; blocos reservados só para *emitir número reservado* quando a lei o permitir | Cadeia de hashes simples e única; conformidade; sem lógica fiscal no cliente | Sem rede, não há factura fiscal definitiva imediata |
| B | Blocos reservados por dispositivo; número definitivo offline, assinatura/hash diferidos | UX offline melhor | Cadeia de hash por série **depende** da ordem; risco legal de documento sem assinatura; "buracos" se dispositivo se perder |
| C | Assinatura no cliente (chave por dispositivo) | Funciona 100 % offline | Chaves em dispositivos; certificação muito mais difícil; superfície de ataque; **rejeitada** |
| D | Só online para emitir (sem provisório) | Mais simples | Bloqueia a secretaria sem rede; contraria o princípio offline-first |

**Recomendação:** opção **A** como base, evoluindo para **B** apenas se o jurídico confirmar que é admissível emitir com número definitivo e assinatura diferida; **C** fica fora.

## 8. Questões em aberto para o backend

1. Versão actual exigida do esquema SAF-T (AO) e algoritmo de hash/assinatura (RSA-SHA1 vs SHA-256) segundo a AGT.
2. É legal emitir documento com número definitivo mas assinatura diferida (offline)? Ou a assinatura tem de ser imediata?
3. Séries por dispositivo são aceites pela AGT, ou exige-se série única por estabelecimento/NIF? Como se comunicam séries à AGT?
4. Qual o tamanho do bloco de reserva por dispositivo e a política para números não usados (devolver vs. documento "nulo")?
5. Quem gere a chave privada (HSM/KMS) e o processo de certificação do software (prazos/custo)?
6. Escopo da v1 do SAF-T: só facturação (`SalesInvoices` + `Payments`) ou também contabilidade (`GeneralLedgerEntries`)?
7. Submissão à AGT: manual (portal) ou integração directa?
8. Data legal do documento emitido offline: data local, ou data de sincronização?
9. Um plano com `billing` implica obrigatoriamente `cloud_sync` (docs/02 licenciamento)? E o que acontece a um documento provisório se a licença expirar antes de sincronizar?
10. Identificação do dispositivo: reutilizar `AccessDevice` ou nova entidade `FiscalDevice`?
11. Como tratar facturas-recibo (`FR`) e consumidores finais sem NIF, e limites de valor?
12. Retenção/arquivo (anos) dos ficheiros SAF-T e dos documentos.

## 9. Consequências e trabalho resultante

Após aprovação, abrir issues pequenas (cliente): (a) alargar DTOs de `Invoice`/`CreditNote`/`Receipt` com campos da D9; (b) estado `provisional`/`final` e comprovativo provisório; (c) registar dispositivo e cache de séries/blocos; (d) ligar `fiscal_document` à outbox/Drift; (e) ecrã de exportação SAF-T; (f) rodapé de PDFs com certificação; (g) verificação de desvio de relógio. O mock em `invoice_mock_handlers.dart` e `payment_mock_handlers.dart` deve passar a reflectir o contrato (séries por dispositivo, `hash` fictício, `Idempotency-Key`). Backend: implementar secções 2–6. Este ADR **não** altera código nem dependências.
