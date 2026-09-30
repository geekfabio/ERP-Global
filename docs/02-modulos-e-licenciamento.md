# 02 — Módulos e Licenciamento

O ERP-Global é vendido **por módulos**. Cada secção do colégio (académica, financeira, refeitório, portaria, biblioteca…) é um módulo independente que a instituição activa através da **licença**. Módulos não licenciados **não aparecem** no menu, não têm rotas e não carregam dados.

## Catálogo de módulos

| Código | Módulo | Tipo | Depende de |
|---|---|---|---|
| `core` | Núcleo (auth, perfis, configurações, ano lectivo, auditoria, notificações) | **Obrigatório** | — |
| `students` | Alunos, ficha do aluno e matrículas | Base | `core` |
| `guardians` | Encarregados de educação | Base | `students` |
| `academic` | Cursos, classes, turmas, disciplinas, horários, professor↔turma | Base | `students` |
| `grades` | Avaliações, notas, boletim, pautas, certificados | Base | `academic` |
| `attendance` | Presenças e faltas | Add-on | `academic` |
| `billing` | Propinas, facturação, recibos, caixa, conta corrente | Add-on | `students` |
| `accounting` | Contabilidade | Add-on | `billing` |
| `hr` | Recursos humanos e folha salarial | Add-on | `core` |
| `cafeteria` | Refeitório, POS e carteira pré-paga | Add-on | `students`, `cards` |
| `cards` | Cartão escolar (RFID/NFC/QR) | Add-on | `students` |
| `access_control` | Catracas e controlo de acesso | Add-on | `cards` |
| `library` | Biblioteca | Add-on | `students` |
| `inventory` | Inventário e património | Add-on | `core` |
| `transport` | Transporte escolar | Add-on (futuro) | `students` |
| `communication` | Comunicados, mensagens, notificações push/SMS/e-mail | Add-on | `core` |
| `guardian_portal` | Portal do encarregado e do aluno | Add-on | `guardians` |
| `reports` | Relatórios avançados e dashboards | Add-on | — (usa módulos activos) |
| `import_export` | Importação/exportação Excel/CSV/PDF | Add-on | — |
| `cloud_sync` | Sincronização e backup cloud | Add-on | `core` |

## Planos sugeridos (comerciais)

| Plano | Módulos incluídos |
|---|---|
| **Essencial** | `core`, `students`, `guardians`, `academic`, `grades` |
| **Gestão** | Essencial + `attendance`, `billing`, `communication`, `reports`, `import_export` |
| **Completo** | Gestão + `accounting`, `hr`, `guardian_portal`, `library`, `inventory` |
| **Campus Inteligente** | Completo + `cards`, `cafeteria`, `access_control`, `cloud_sync` |

Planos são apenas *pacotes* de módulos; a licença guarda sempre a **lista explícita** de módulos.

## Modelo de licença

```jsonc
{
  "licenseId": "01J...",            // ULID
  "institutionId": "01J...",
  "institutionName": "Colégio Exemplo",
  "plan": "gestao",
  "modules": ["core","students","guardians","academic","grades","billing"],
  "limits": { "campuses": 2, "students": 800, "users": 60, "devices": 5 },
  "issuedAt": "2026-01-01",
  "expiresAt": "2027-01-01",
  "graceDays": 30,
  "signature": "<Ed25519>"
}
```

### Regras

1. **Assinada** (Ed25519). A chave pública vai embebida na app; a privada fica só no servidor de licenças. Tocar no JSON invalida a assinatura.
2. **Validação offline**: a app valida assinatura, datas e limites localmente — funciona sem internet (offline first).
3. **Renovação online** quando houver ligação; nova licença substitui a antiga.
4. **Período de graça** (`graceDays`) após expirar: aviso visível, tudo funciona. Depois: modo **só leitura**, nunca perda de dados.
5. **Limites** (alunos, campus, utilizadores) impedem novos registos além do contratado, com mensagem clara; nunca apagam dados existentes.
6. **Dependências** são resolvidas: activar `cafeteria` exige `cards` e `students` na licença.
7. Anti-fraude: detectar recuo do relógio do sistema (guardar último timestamp visto).

## Como o código aplica módulos

- `ModuleRegistry`: cada feature regista `ModuleDescriptor(code, nome, ícone, rotas, permissões, dependências)`.
- `LicenseService` expõe `isModuleEnabled(code)`, `limitsOf(...)` e `status` (activa, graça, expirada).
- **Menu/sidebar** gerado a partir de `ModuleRegistry ∩ licença ∩ permissões do utilizador`.
- **Router** com `ModuleGuard`: rota de módulo desactivado redirecciona para ecrã "Módulo não licenciado" (com CTA de contacto comercial).
- **Providers**: cada feature só inicializa se o módulo estiver activo.
- Módulos comunicam por **contratos/eventos** (ex.: `EnrollmentConfirmed` → `billing` gera propina). Se o módulo consumidor não estiver licenciado, o evento é ignorado sem erro.
- Testes: cada módulo tem teste "app arranca com este módulo desligado".
