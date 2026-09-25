# Roadmap — ERP-Global

Este roadmap organiza a evolução inicial do ERP-Global, começando pela fundação técnica do Flutter, passando pelos módulos principais, até à integração com backend, offline first, catracas, refeitório e portal do encarregado.

## Fase 0 — Preparação do Projecto

- Criar repositório `ERP-Global`
- Definir padrão de commits
- Configurar Flutter/FVM
- Criar estrutura base do projecto
- Definir tema global e design system
- Definir arquitectura feature-first
- Criar estrutura base para:
  - `models/`
  - `repositories/`
  - `data_mocks/`
  - `presentation/`
  - `domain/`
- Criar documentação inicial
- Definir convenções de nomes
- Definir padrões para erros, estados e carregamentos

## Fase 1 — Fundação Flutter

### Objectivo

Criar uma base escalável para que todos os módulos sejam desenvolvidos com consistência.

### Tarefas

- Configurar Riverpod
- Configurar GoRouter
- Configurar tema claro/escuro
(Usar livrarias ou bibliotecas solidas idealmente)
- Criar componentes base:
  - Botões
  - Inputs
  - Cards
  - Tabelas
  - Modais
  - Toasts/alerts
  - Layout dashboard
  - Sidebar
  - Topbar
- Criar tratamento global de erros
- Criar loading states e empty states
- Criar estrutura base de autenticação mockada
- Criar utilizadores mockados por perfil

### Resultado esperado

Aplicação Flutter navegável, com layout administrativo funcional e dados simulados.

## Fase 2 — Autenticação, Perfis e Permissões

### Objectivo

Preparar o controlo de acesso por tipo de utilizador.

### Perfis iniciais

- Super Administrador
- Direcção
- Secretaria
- Professor
- Financeiro
- Contabilista
- RH
- Operador do Refeitório
- Segurança
- Bibliotecário
- Encarregado
- Aluno

### Tarefas

- Criar `UserModel`
- Criar `RoleModel`
- Criar `PermissionModel`
- Criar `AuthRepository`
- Criar `MockAuthRepository`
- Criar `auth_mock_data.dart`
- Criar login mockado
- Criar controlo de rotas por perfil
- Criar sessão local mockada

## Fase 3 — Configurações Gerais

### Objectivo

Construir o módulo de configurações para evitar regras fixas no código.

### Áreas de configuração

- Dados da instituição
- Campus/filiais
- Ano lectivo
- Períodos
- Classes
- Cursos
- Turmas
- Disciplinas
- Salas
- Turnos
- Moedas
- Impostos
- Regras académicas
- Regras financeiras
- Refeitório
- Cartões
- Catracas
- Cloud/sincronização
- Notificações
- Importação/exportação

### Resultado esperado

Base configurável para alimentar os restantes módulos.

## Fase 4 — Alunos, Matrículas e Encarregados

### Objectivo

Criar a base académica e administrativa do aluno.

### Models

- `StudentModel`
- `EnrollmentModel`
- `GuardianModel`
- `StudentDocumentModel`
- `StudentCardModel`

### Repositories

- `StudentRepository`
- `MockStudentRepository`
- `GuardianRepository`
- `MockGuardianRepository`

### Data Mocks

- `students_mock_data.dart`
- `guardians_mock_data.dart`
- `enrollments_mock_data.dart`

### Funcionalidades

- Listagem de alunos
- Cadastro de aluno
- Associação de encarregados
- Matrícula
- Histórico académico
- Documentos
- Estado do aluno
- Associação de cartão escolar

## Fase 5 — Gestão Académica

### Funcionalidades

- Cursos
- Classes
- Turmas
- Disciplinas
- Professores por disciplina
- Horários
- Presenças
- Faltas
- Avaliações
- Notas
- Médias
- Pautas
- Certificados e declarações

### Objectivo

Permitir que a escola controle o percurso académico do aluno.

## Fase 6 — Financeiro e Tesouraria

### Funcionalidades

- Propinas
- Matrículas
- Mensalidades
- Taxas
- Multas
- Descontos
- Bolsas
- Pagamentos
- Recibos
- Facturas
- Conta corrente do aluno
- Caixa
- Bancos
- Relatórios financeiros

### Models

- `InvoiceModel`
- `ReceiptModel`
- `PaymentModel`
- `StudentAccountModel`
- `CashRegisterModel`

## Fase 7 — Contabilidade

### Funcionalidades

- Plano de contas
- Lançamentos
- Diário
- Razão
- Centros de custo
- Balancetes
- Contas a pagar
- Contas a receber
- Exercícios contabilísticos
- Relatórios contabilísticos

### Observação

A contabilidade deverá receber movimentos gerados pelo financeiro, mas manter regras próprias e auditáveis.

## Fase 8 — Refeitório, Restaurante e Carteira Pré-paga

### Diferencial principal

O aluno poderá usar o cartão escolar para consumir no refeitório/restaurante, descontando automaticamente do saldo pré-pago.

### Funcionalidades

- Gestão de menus
- Tipos de refeição
- Preços
- Horários
- Vendas
- POS do refeitório
- Saldo pré-pago
- Carregamentos
- Consumos
- Estornos
- Extracto
- Limites diários
- Bloqueio do cartão
- Relatórios de consumo

### Fluxo

```txt
Cartão do aluno
  -> Terminal do refeitório
  -> Validação local
  -> Desconto no saldo
  -> Registo da transacção
  -> Sincronização futura
```

## Fase 9 — Catracas, Cartões e Controlo de Acesso

### Funcionalidades

- Registo de cartões
- Associação cartão/aluno/funcionário
- Bloqueio de cartões
- Substituição de cartões
- Entrada e saída
- Logs de acesso
- Regras por horário
- Regras por campus/zona
- Integração futura com catracas
- Integração futura com biometria/RFID/NFC

### Observação

A cloud não deve ser obrigatória para o funcionamento das catracas. A validação principal deve ocorrer localmente.

## Fase 10 — Portal do Encarregado

### Funcionalidades

- Login do encarregado
- Lista de educandos
- Notas
- Faltas
- Horários
- Pagamentos
- Dívidas
- Recibos
- Facturas
- Saldo do cartão
- Consumos no refeitório
- Entradas e saídas
- Comunicados
- Pedidos de documentos
- Justificação de faltas
- Notificações

## Fase 11 — Importação e Exportação

### Importação

- Excel
- CSV
- Templates oficiais
- Validação de dados
- Pré-visualização
- Relatório de erros
- Importação de alunos
- Importação de encarregados
- Importação de professores
- Importação de turmas
- Importação de notas
- Importação financeira

### Exportação

- Excel
- CSV
- PDF
- Relatórios filtrados
- Respeito às permissões

## Fase 12 — Offline First e Sincronização

### Estratégia

- Base local
- Outbox de alterações
- Identificadores UUID/ULID
- Estado de sincronização
- Registos pendentes
- Registos com erro
- Resolução de conflitos
- Sync manual e automático
- Cloud opcional

### Estados

- Apenas local
- Local + backup cloud
- Local + sincronização cloud

## Fase 13 — Relatórios e Dashboards

### Dashboards

- Direcção
- Secretaria
- Financeiro
- Contabilidade
- Refeitório
- Catracas
- RH
- Académico
- Portal do encarregado

### Indicadores

- Alunos matriculados
- Alunos activos
- Propinas pagas
- Dívidas
- Receitas
- Despesas
- Presenças
- Entradas/saídas
- Consumos no refeitório
- Saldo pré-pago
- Stock
- Desempenho académico

## Fase 14 — Testes e Qualidade

- Unit tests
- Widget tests
- Testes de repositories
- Testes de data mocks
- Testes de navegação
- Testes de permissões
- Testes de sincronização
- CI/CD
- Análise estática
- Padronização de código

## Fase 15 — Integração com Backend Real

### Objectivo

Substituir gradualmente mocks por API real.

### Estratégia

- Manter contratos nos repositories
- Trocar `MockRepository` por `ApiRepository`
- Manter fallback local quando necessário
- Sincronizar dados locais com backend
- Validar contratos de API com a equipa backend

## Convenção Recomendada

Cada módulo deve nascer com:

```txt
data/
  models/
  repositories/
  data_mocks/
domain/
  entities/
  usecases/
presentation/
  pages/
  widgets/
  providers/
```

## Prioridade Inicial

1. Fundação Flutter
2. Design system
3. Auth mockado
4. Configurações
5. Alunos
6. Encarregados
7. Financeiro básico
8. Refeitório com saldo pré-pago
9. Cartões
10. Portal do encarregado
