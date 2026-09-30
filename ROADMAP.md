# Roadmap — ERP-Global

Plataforma completa de gestão escolar, **modular e licenciada por módulos**. Detalhe funcional em [`docs/03-funcionalidades.md`](docs/03-funcionalidades.md); licenciamento em [`docs/02-modulos-e-licenciamento.md`](docs/02-modulos-e-licenciamento.md); execução por issues pequenas em [`docs/05-orquestracao-agentes.md`](docs/05-orquestracao-agentes.md).

Cada fase entrega algo navegável sobre uma **API mockada** ([`docs/07-mock-api.md`](docs/07-mock-api.md)). Não há registo público: só login; contas criadas por administração. Cada módulo respeita perfis/permissões e a licença.

## Fase 0 — Preparação do Projecto

- Repositório, padrão de commits, Flutter/FVM
- Estrutura feature-first (`models/`, `repositories/`, `data_mocks/`, `domain/`, `presentation/`)
- Convenções de nomes; padrões de erros, estados e carregamentos
- Documentação completa (`docs/`), `AGENTS.md`, template de issues, labels
- **Logo e identidade geradas por IA** (brief em `docs/04-design-system.md`)

## Fase 1 — Fundação Flutter e Design System

- Riverpod, GoRouter, tema claro/escuro com **tokens** (usar bibliotecas sólidas)
- Componentes base: botões, inputs, cards, **DataTable**, modais, toasts/alerts, layout dashboard, sidebar, topbar (responsivos)
- Gráficos, skeletons, empty/loading/error states
- **Animações** (transições, KPIs, feedback) respeitando acessibilidade
- Tratamento global de erros, i18n pt-AO
- Autenticação mockada e utilizadores mockados por perfil

**Resultado:** app navegável com layout administrativo funcional.

## Fase 2 — Autenticação, Perfis, Permissões e Licenciamento

### Perfis
Super Administrador, Direcção, Coordenação, Secretaria, Professor, Director de turma, Financeiro, Contabilista, RH, Operador do Refeitório, Segurança, Bibliotecário, Encarregado, Aluno.

### Tarefas
- `UserModel`, `RoleModel`, `PermissionModel` (com **âmbito**: campus/curso/classe/turma)
- `AuthRepository` + `MockAuthRepository` + `auth_mock_data.dart`; login e sessão local mockados
- Controlo de rotas por perfil (`PermissionGuard`) e auditoria
- **`ModuleRegistry` + `LicenseService`**: licença assinada, validação offline, planos, limites, período de graça, `ModuleGuard`, ecrã "módulo não licenciado"

## Fase 3 — Configurações Gerais e Estrutura Escolar

- Dados da instituição, campus/filiais
- **Ano lectivo** (planeado → activo → em fecho → encerrado)
- **Períodos/Trimestres** (datas, prazos de notas, abertura/fecho)
- Ciclos, classes, cursos, currículo, turmas, disciplinas, salas, turnos
- Moedas, impostos, regras académicas, regras financeiras
- Refeitório, cartões, catracas, cloud/sincronização, notificações, importação/exportação

**Resultado:** base configurável que alimenta os restantes módulos.

## Fase 4 — Alunos, Ficha do Aluno, Matrículas e Encarregados

- Models: `StudentModel`, `EnrollmentModel`, `GuardianModel`, `StudentDocumentModel`, `StudentCardModel` (+ saúde, ocorrências, transferências)
- Listagem, pesquisa avançada, detecção de duplicados
- **Ficha do aluno completa** (identificação, encarregados, saúde, percurso, matrícula, notas, assiduidade, financeiro, disciplina, documentos, cartão, auditoria)
- Encarregados e vínculo (responsável financeiro, emergência, recolha)
- **Matrículas**: nova, renovação (em massa), transferência, reingresso; wizard com documentos e taxa; ficha/comprovativo/contrato em PDF
- Histórico académico, estado do aluno, associação de cartão escolar

## Fase 5 — Gestão Académica, Professores e Avaliações

- Cursos, classes, turmas, disciplinas
- **Professores e atribuição professor↔turma↔disciplina**, director de turma
- Horários com detecção de conflitos
- Presenças e faltas (justificações, limites, alertas)
- **Avaliações e notas**: esquema configurável (MAC/NPP/NPT → MT → MF), lançamento por trimestre, fecho/reabertura auditada
- Médias, **boletim de notas** (PDF), **pautas**, conselho de turma
- Certificados e declarações (QR de verificação)
- Estatísticas de desempenho

**Objectivo:** controlar o percurso académico do aluno.

## Fase 6 — Financeiro, Facturação e Tesouraria

- Tabela de preços por ano lectivo × classe × campus
- Propinas, matrículas, mensalidades, taxas, multas/juros, descontos, bolsas
- **Facturação**: facturas, facturas-recibo, recibos, notas de crédito, séries, IVA/isenções; preparação fiscal local (AGT/SAF-T)
- Pagamentos (numerário, transferência, TPA, referência, saldo pré-pago), parciais e adiantados
- Conta corrente do aluno e do encarregado
- Caixa (abertura/fecho, sangrias), bancos e reconciliação
- Devedores, avisos automáticos, acordos de pagamento
- Relatórios financeiros
- Models: `InvoiceModel`, `ReceiptModel`, `PaymentModel`, `StudentAccountModel`, `CashRegisterModel`

## Fase 7 — Contabilidade e Recursos Humanos

### Contabilidade
Plano de contas, lançamentos (automáticos do financeiro), diário, razão, centros de custo, balancetes, contas a pagar/receber, exercícios, relatórios. Regras próprias e auditáveis.

### RH
Funcionários (docentes e não docentes), contratos, cargos, assiduidade, férias, folha salarial, documentos. Docentes alimentam a Fase 5.

## Fase 8 — Refeitório, Restaurante e Carteira Pré-paga

Menus, tipos de refeição, preços, horários, POS, saldo pré-pago, carregamentos, consumos, estornos, extracto, limites diários, alergias visíveis no POS, bloqueio do cartão, relatórios de consumo.

```txt
Cartão do aluno -> Terminal do refeitório -> Validação local
  -> Desconto no saldo -> Registo da transacção -> Sincronização futura
```

## Fase 9 — Cartões, Catracas, Controlo de Acesso e Serviços do Campus

- Registo, associação (aluno/funcionário), bloqueio e substituição de cartões
- Entrada/saída, logs, regras por horário e campus/zona, alertas a encarregados
- Validação **local** (cloud não obrigatória); integração futura com catracas, RFID/NFC/biometria
- **Biblioteca**: acervo, empréstimos, multas, reservas
- **Inventário/Património**: bens, localização, stock

## Fase 10 — Portais (Encarregado, Aluno) e Comunicação

- Login do encarregado/aluno; multi-educando
- Notas, boletins, faltas, horários, pagamentos, dívidas, recibos, facturas
- Saldo do cartão, consumos, entradas e saídas
- Comunicados, mensagens, notificações (push/SMS/e-mail), agenda escolar
- Pedidos de documentos, justificação de faltas

## Fase 11 — Importação e Exportação

**Importação:** Excel/CSV, templates oficiais, validação, pré-visualização, relatório de erros — alunos, encarregados, professores, turmas, notas, financeiro.
**Exportação:** Excel, CSV, PDF, relatórios filtrados, respeito às permissões.

## Fase 12 — Offline First e Sincronização

Base local (Drift), outbox, ULID, estados de sincronização, pendentes/erros, conflitos, sync manual e automático, cloud opcional (módulo `cloud_sync`).
Estados: apenas local · local + backup cloud · local + sincronização cloud.

## Fase 13 — Relatórios e Dashboards

Dashboards: Direcção, Coordenação, Secretaria, Professor, Financeiro, Contabilidade, Refeitório, Catracas, RH, Académico, Portal.
Indicadores: matriculados/activos, aprovação, propinas pagas, dívidas, receitas/despesas, presenças, entradas/saídas, consumos, saldo pré-pago, stock, desempenho — com filtros por **ano lectivo, trimestre e campus** e comparação entre períodos. Relatórios agendados e exportáveis.

## Fase 14 — Testes e Qualidade

Unit, widget, repositories, data mocks, navegação, **permissões e licença** (app arranca com cada módulo desligado), sincronização, CI/CD, análise estática, padronização.

## Fase 15 — Integração com Backend Real

Manter contratos nos repositories, trocar `MockRepository` por `ApiRepository`, fallback local, sincronizar com backend, validar contratos de API e numeração fiscal com a equipa backend.

## Convenção por módulo

```txt
data/         models/  repositories/  data_mocks/
domain/       entities/  usecases/
presentation/ pages/  widgets/  providers/
```

## Prioridade Inicial

1. Fundação Flutter + CI
2. Design system
3. Auth mockado, perfis, módulos e licença
4. Configurações (ano lectivo, trimestres, turmas)
5. Alunos, ficha, matrículas, encarregados
6. Professor↔turma, notas, boletim
7. Financeiro/facturação básica
8. Refeitório com saldo pré-pago, cartões
9. Portal do encarregado
