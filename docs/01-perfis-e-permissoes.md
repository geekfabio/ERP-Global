# 01 — Perfis, Acessos e Permissões

O ERP-Global é multi-perfil. Cada utilizador vê apenas o que o seu perfil **e** a licença da instituição permitem (ver [02-modulos-e-licenciamento](02-modulos-e-licenciamento.md)).

## Perfis

| Perfil | Quem é | Foco principal | Plataforma típica |
|---|---|---|---|
| `super_admin` | Equipa técnica / dono da instalação | Configuração total, licença, auditoria | Desktop/Web |
| `direcao` | Director geral, subdirectores (pedagógico, administrativo) | Dashboards, aprovações, relatórios | Desktop/Tablet |
| `coordenacao` | Coordenador de curso/classe/ciclo | Turmas, professores, pautas, horários da sua área | Desktop |
| `secretaria` | Secretaria académica | Matrículas, ficha do aluno, documentos, certificados | Desktop |
| `professor` | Docente | Turmas atribuídas, presenças, avaliações, lançamento de notas | Mobile/Desktop |
| `diretor_turma` | Professor com turma a cargo (função adicional) | Visão global da turma, boletim, contacto com encarregados | Mobile/Desktop |
| `financeiro` | Tesouraria / facturação | Propinas, recibos, facturas, caixa | Desktop |
| `contabilista` | Contabilidade | Plano de contas, lançamentos, balancetes | Desktop |
| `rh` | Recursos humanos | Funcionários, contratos, assiduidade, salários | Desktop |
| `refeitorio` | Operador do refeitório | POS, menus, carregamentos | Tablet |
| `seguranca` | Portaria / segurança | Controlo de acessos, logs, cartões | Tablet |
| `bibliotecario` | Biblioteca | Acervo, empréstimos | Desktop |
| `encarregado` | Pai/mãe/tutor | Educandos, notas, pagamentos, comunicados | Mobile |
| `aluno` | Aluno | Notas, horário, faltas, saldo | Mobile |

Um utilizador pode ter **vários perfis** (ex.: professor + coordenador) e um perfil pode ser **restrito por âmbito** (campus, curso, classe, turma).

## Modelo de permissões

```
User ──< UserRole >── Role ──< RolePermission >── Permission
                │
                └── Scope (campus? curso? classe? turma?)
```

- **Permission** = `modulo.recurso.acção`, ex.: `students.record.read`, `grades.entry.write`, `billing.invoice.void`.
- Acções padrão: `read`, `create`, `update`, `delete`, `approve`, `export`, `void`.
- **Scope** limita onde a permissão vale: um professor tem `grades.entry.write` apenas nas turmas/disciplinas atribuídas.
- **Regra de ouro:** a UI esconde, o *router* bloqueia, o *repository* valida. Nunca confiar só na UI.
- Toda a acção sensível (anular factura, alterar nota após fecho, apagar aluno) gera entrada em **audit log** (quem, quando, antes/depois).

## Matriz resumida (módulo × perfil)

Legenda: **T** total · **E** escrita no âmbito · **L** leitura · **P** apenas dados próprios/dos educandos · **—** sem acesso

| Módulo | super_admin | direcao | coord. | secretaria | professor | financeiro | contab. | rh | refeitório | segurança | biblioteca | encarregado | aluno |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Configurações | T | L | — | L | — | L | — | — | — | — | — | — | — |
| Licença/Auditoria | T | L | — | — | — | — | — | — | — | — | — | — | — |
| Alunos/Ficha | T | L | L | T | L (turmas) | L | — | — | — | — | — | P | P |
| Matrículas | T | L | L | T | — | L | — | — | — | — | — | P (pedidos) | — |
| Académico (turmas, horários) | T | L | E | E | L | — | — | — | — | — | — | P | P |
| Avaliações/Notas | T | L | E (aprovar) | L | E (lançar) | — | — | — | — | — | — | P | P |
| Boletim/Pautas | T | T | T | T | L | — | — | — | — | — | — | P | P |
| Presenças | T | L | L | L | E | — | — | — | — | L | — | P | P |
| Financeiro/Facturação | T | L | — | L | — | T | L | — | — | — | — | P | — |
| Contabilidade | T | L | — | — | — | L | T | — | — | — | — | — | — |
| RH/Funcionários | T | L | — | — | — | — | — | T | — | — | — | — | — |
| Refeitório | T | L | — | — | — | L | — | — | T | — | — | P | P |
| Cartões/Acessos | T | L | — | E | — | — | — | — | — | T | — | P | P |
| Biblioteca | T | L | — | — | L | — | — | — | — | — | T | P | P |
| Comunicação | T | T | E | E | E | E | — | E | — | — | — | L | L |
| Relatórios/Dashboards | T | T | E (área) | E (área) | — | E (área) | E (área) | E (área) | E (área) | E (área) | E (área) | — | — |

## Requisitos de segurança

- Autenticação: e-mail/telefone + palavra-passe; 2FA opcional para `super_admin`, `direcao`, `financeiro`.
- Sessão local com refresh token guardado em `flutter_secure_storage`.
- Encarregado só acede a alunos ligados via `GuardianLink` (verificado, com data de validade).
- Menor de idade: dados de alunos nunca expostos em relatórios exportados sem permissão `export`.
- RGPD/Lei de Protecção de Dados (Angola — Lei n.º 22/11): consentimento, exportação e anonimização de dados pessoais.
