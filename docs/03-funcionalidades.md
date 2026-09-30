# 03 — Funcionalidades por Módulo

Documento de referência funcional. Cada bloco vira épicos/issues (ver [05-orquestracao-agentes](05-orquestracao-agentes.md)).

## Estrutura académica (módulo `core` + `academic`)

- **Instituição** → **Campus/Filiais** → **Ciclos/Níveis** (Iniciação, Ensino Primário, 1.º Ciclo, 2.º Ciclo, Ensino Médio/Técnico…) → **Classes** → **Turmas**.
- **Ano lectivo**: código (`2026/2027`), datas, estado `planeado → activo → em_fecho → encerrado`. Só um activo por campus. Encerrar congela notas, matrículas e facturação do ano (apenas leitura).
- **Períodos/Trimestres**: por defeito 3 trimestres (configurável: bimestres, semestres). Cada trimestre tem datas, prazo de lançamento de notas e estado `aberto/fechado`. Reabertura exige permissão `approve` e fica em auditoria.
- **Disciplinas** com carga horária, tipo (comum/opcional/técnica), classe(s) onde se aplica.
- **Currículo**: disciplinas por curso × classe.
- **Salas** e **turnos** (manhã/tarde/noite).
- **Horários**: grelha por turma com detecção de conflitos (professor, sala, turma).

## Professor ↔ Turma ↔ Disciplina

Entidade central `TeachingAssignment` (`professor`, `turma`, `disciplina`, `anoLectivo`, `cargaHoraria`).

- Coordenação/direcção atribui professores a (turma × disciplina); o professor só vê e lança notas nessas atribuições.
- Um professor pode leccionar várias turmas/disciplinas; uma disciplina numa turma tem **um** titular (e opcionalmente substituto com validade).
- **Director de turma**: função adicional (1 por turma) com visão global do boletim, faltas e contactos.
- Validações: carga horária máxima, conflito de horário, professor sem contrato activo (via `hr`) é sinalizado.
- Substituição: transferência de atribuição preserva histórico de notas lançadas.

## Alunos e Ficha do Aluno (módulo `students`)

A **ficha do aluno** é o registo mestre, organizada em separadores:

1. **Identificação**: nome completo, foto, data/local de nascimento, sexo, nacionalidade, BI/cédula/passaporte, NIF, n.º de processo (gerado), morada, contactos.
2. **Encarregados**: vários por aluno; parentesco, contactos, é responsável financeiro?, é contacto de emergência?, autorização de recolha.
3. **Saúde**: grupo sanguíneo, alergias, medicação, condições, seguro, necessidades educativas especiais (NEE), contactos médicos.
4. **Percurso académico**: escola de origem, histórico de matrículas por ano, resultados finais por ano, transferências, repetências.
5. **Matrícula actual**: classe, turma, turno, estado, n.º de chamada.
6. **Notas e boletins**: notas por disciplina/trimestre, médias, boletins emitidos.
7. **Assiduidade**: presenças, faltas justificadas/injustificadas, atrasos.
8. **Financeiro**: conta corrente, propinas, dívidas, bolsas/descontos (visível a quem tem permissão).
9. **Disciplina e ocorrências**: registo de comportamento, advertências, elogios.
10. **Documentos**: BI, cédula, certificado anterior, vacinas, fotos, contratos; upload, validade, verificado por.
11. **Cartão e acessos**: cartão associado, saldo do refeitório, últimas entradas/saídas.
12. **Histórico/Auditoria**: timeline de tudo o que mudou.

Funcionalidades: pesquisa avançada, filtros, cadastro por passos (wizard), detecção de duplicados (nome + data nasc. + BI), estados (`candidato`, `activo`, `suspenso`, `transferido`, `desistente`, `concluído`, `anulado`), fusão de duplicados, exportação da ficha em PDF.

## Matrículas

- Tipos: **nova matrícula**, **renovação/confirmação**, **transferência entrada**, **reingresso**.
- Fluxo: `candidatura → documentos → análise → aprovada → pagamento da taxa → matrícula confirmada → atribuição de turma`.
- Regras configuráveis: idade mínima por classe, vagas por turma, documentos obrigatórios, taxa de matrícula, transição automática (aprovado → classe seguinte, reprovado → repete).
- Renovação em massa no fim do ano (por turma) com pré-visualização.
- Ao confirmar: evento `EnrollmentConfirmed` (gera cobranças no `billing`, cartão no `cards`).
- Geração de **ficha de matrícula**, **comprovativo** e **contrato de prestação de serviços** em PDF.

## Avaliações, Notas e Boletim (módulo `grades`)

- **Esquema de avaliação configurável** por classe/curso: ex. `MAC` (média das avaliações contínuas), `NPP` (prova do professor), `NPT` (prova trimestral) → `MT` (média trimestral) → `MF` (média final), escala 0–20 (configurável), nota mínima de aprovação (10), arredondamento.
- **Lançamento de notas**: grelha por turma × disciplina × trimestre, com validação de intervalo, bloqueio após fecho, prazo por trimestre, log de alterações e justificação para edição pós-fecho.
- **Fórmulas** configuráveis por instituição (pesos, médias ponderadas), com pré-visualização.
- **Boletim de notas**: por aluno e trimestre; notas por disciplina, média, faltas, observações do director de turma, posição na turma (opcional); PDF com logo e assinatura; envio ao encarregado.
- **Pauta**: por turma e trimestre/final; estado por disciplina; resultado final (`aprovado`, `reprovado`, `recurso`, `transita com deficiência`); PDF/Excel.
- **Conselho de turma**: registo de decisões e aprovação de pautas.
- **Certificados e declarações**: declaração de matrícula, de notas, certificado de conclusão, com modelos editáveis, QR de verificação e numeração sequencial.
- Estatísticas: média por turma/disciplina, taxa de aprovação, distribuição de notas, alunos em risco.

## Presenças (`attendance`)

Registo por aula (professor, mobile), por dia (director de turma), justificação de faltas (encarregado/secretaria), limite de faltas configurável com alertas, integração opcional com `access_control` (entrada na portaria ≠ presença na aula, ambas registadas).

## Facturação e Financeiro (`billing`)

- **Tabela de preços** por ano lectivo × classe × campus: matrícula, propina mensal, taxas (uniforme, material, exame, transporte, refeitório).
- **Plano de cobrança**: geração automática de mensalidades (ex. 10–12 meses), vencimentos, multas por atraso e juros configuráveis.
- **Descontos e bolsas**: percentagem/valor, por aluno, por irmãos, por mérito; validade e aprovação.
- **Facturação**: facturas, facturas-recibo, notas de crédito/débito, recibos; numeração por série; anulação com motivo; impostos (IVA/isenções) configuráveis; **preparado para conformidade fiscal local (Angola/AGT: SAF-T, NIF, assinatura de documentos)** — definir com a equipa de backend.
- **Pagamentos**: numerário, transferência, TPA/multicaixa, referência de pagamento, saldo pré-pago; pagamentos parciais e adiantados.
- **Conta corrente do aluno** e do encarregado (responsável financeiro): débitos, créditos, saldo.
- **Caixa**: abertura/fecho por operador, sangrias, conferência, movimentos bancários e reconciliação.
- **Cobrança**: lista de devedores, avisos automáticos (pré-vencimento, vencido), acordos de pagamento.
- **Relatórios**: receitas por período/campus/rubrica, dívida, previsto vs. recebido, fecho de caixa.

## Contabilidade (`accounting`)

Plano de contas (PGC-AO configurável), lançamentos automáticos vindos do `billing`, diário, razão, centros de custo, balancete, contas a pagar/receber, exercícios, fecho contabilístico, demonstrações. Regras próprias e auditáveis.

## RH (`hr`)

Funcionários (docentes e não docentes), contratos, cargos, assiduidade, férias, folha salarial, descontos (INSS/IRT), documentos, avaliação de desempenho. Docentes alimentam `academic`.

## Refeitório e Cartão (`cafeteria`, `cards`, `access_control`)

- Cartão único (RFID/NFC/QR) para aluno e funcionário; emissão, bloqueio, 2.ª via.
- Refeitório: menus, POS, saldo pré-pago, carregamentos, consumos, estornos, limites diários, restrições alimentares/alergias visíveis no POS, extracto.
- Controlo de acesso: validação local (offline), regras por horário/zona/estado financeiro (opcional), logs, alerta ao encarregado em entrada/saída.

## Biblioteca, Inventário, Comunicação

- **Biblioteca**: acervo, exemplares, empréstimos/devoluções, multas, reservas, leitura por cartão.
- **Inventário/Património**: bens, localização, responsável, abates, manutenção, stock de consumíveis.
- **Comunicação**: comunicados por público (escola, turma, encarregados de X), mensagens, push/SMS/e-mail, modelos, confirmação de leitura, agenda/calendário escolar.

## Portal do Encarregado / Aluno (`guardian_portal`)

Multi-educando; boletins, notas, faltas, horário, dívidas e pagamentos (referência), recibos/facturas, saldo do cartão e consumos, entradas/saídas, comunicados, pedidos de documentos, justificação de faltas, marcação de reuniões.

## Relatórios e Dashboards (`reports`)

- **Dashboards por perfil** (direcção, secretaria, coordenação, financeiro, refeitório, portaria, RH, professor) com filtros de ano lectivo/trimestre/campus.
- KPIs: matriculados/activos, taxa de ocupação de turmas, aprovação, assiduidade, receita vs. previsto, dívida, inadimplência, consumo refeitório, saldo pré-pago, acessos por hora.
- Relatórios agendados e exportáveis (PDF/Excel/CSV), respeitando permissões e âmbito.
- Comparação entre trimestres e anos lectivos.

## Transversais

- **Notificações** in-app/push; **auditoria** universal; **anexos**; **pesquisa global** (Ctrl+K); **multi-idioma** (pt-AO base, arquitectura i18n); **acessibilidade**; **modo escuro**; **impressão/PDF** com modelos por instituição (logo, cabeçalho, carimbo).
