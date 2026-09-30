# 04 — Design System, Animações e Identidade

## Princípios

1. **Clareza antes de decoração** — é uma ferramenta de trabalho diário para secretaria, professores e tesouraria.
2. **Consistência** — um só conjunto de componentes, tokens e padrões em todos os módulos.
3. **Responsivo real** — mobile (aluno/encarregado/professor), tablet (POS/portaria), desktop (administração).
4. **Acessível** — contraste AA, alvos de toque ≥ 44 px, navegação por teclado, textos escaláveis.
5. **Movimento com propósito** — animações curtas que explicam mudanças de estado, nunca atrasam o trabalho.

## Tokens

Todos em `lib/app/theme/`, nunca valores soltos nos widgets.

| Token | Valores iniciais |
|---|---|
| Cores semânticas | `primary`, `secondary`, `success`, `warning`, `danger`, `info`, `surface`, `onSurface`, `outline` (claro + escuro) |
| Cores de módulo | uma cor de acento por módulo (académico, financeiro, refeitório, acessos…) para orientação visual |
| Tipografia | Inter (ou Plus Jakarta Sans) — `display`, `headline`, `title`, `body`, `label`, `mono` para números/códigos |
| Espaçamento | escala de 4 px: 4, 8, 12, 16, 24, 32, 48 |
| Raios | 6 (inputs), 12 (cards), 20 (modais) |
| Elevação | 0, 1, 2, 4 (sombras suaves) |
| Breakpoints | compact < 600, medium 600–1024, expanded > 1024 |
| Duração de movimento | 120 ms (micro), 220 ms (padrão), 360 ms (transição de página); curva `easeOutCubic` |

Base: **Material 3** com `ColorScheme.fromSeed` + extensões de tema (`ThemeExtension`) para tokens próprios. Cor da marca **configurável por instituição** (white-label leve: logo + cor primária).

## Biblioteca de componentes (`core/widgets/`)

Botões (primário, secundário, texto, perigo, ícone), inputs (texto, password, número/moeda, data, select pesquisável, telefone, upload), cards (KPI, lista, entidade), **DataTable** (ordenação, filtros, paginação, selecção, exportação, colunas configuráveis), formulários em passos (stepper/wizard), modais/bottom-sheets, toasts/snackbars, badges de estado, avatar, tabs, breadcrumbs, empty/loading/error states, skeletons, gráficos (linha, barra, donut, sparkline), timeline, calendário/agenda, sidebar + topbar responsiva (rail em tablet, drawer em mobile), pesquisa global, ecrã "módulo não licenciado".

Bibliotecas sólidas recomendadas: `fl_chart` (gráficos), `data_table_2` ou `pluto_grid` (tabelas), `flutter_animate`, `skeletonizer`, `responsive_framework`/`flutter_adaptive_scaffold`, `pdf` + `printing`, `intl`, `flutter_form_builder` (ou formulários próprios com validação central).

## Animações

- Transições de página: fade-through/shared axis (módulo → módulo), slide (drill-down).
- Listas: entrada escalonada (stagger) até 8 itens; sem animar centenas.
- KPIs: contagem animada dos números e gráficos que "crescem" ao entrar.
- Feedback: sucesso (check animado), erro (shake leve), carregamento (skeleton, não spinner isolado).
- Cartão/POS: animação de leitura de cartão e confirmação de débito (Lottie/Rive, só aqui e no onboarding).
- Respeitar `MediaQuery.disableAnimations` (acessibilidade) e permitir "reduzir movimento" nas definições.

## Identidade e Logo (gerado por IA)

O logo é gerado com ferramenta de IA de imagem e depois **vectorizado e refinado** (SVG) antes de entrar na app.

**Brief:**
- Nome: **ERP-Global** (sugestão de marca: “Global Escola”).
- Conceito: educação + conexão + gestão integrada (livro aberto/capelo + nós de rede/globo estilizado).
- Estilo: geométrico, minimalista, moderno, legível a 24 px; funciona a uma cor.
- Paleta: azul-profundo (confiança) + verde/teal (crescimento) + acento âmbar.
- Entregáveis: símbolo, logotipo horizontal, versão vertical, versão monocromática, favicon/ícone app (1024²), variante para fundo escuro.

**Prompt base sugerido:**
> "Minimalist vector logo for a school management platform called ERP-Global, stylized open book merging with a globe made of connected nodes, flat geometric shapes, deep blue and teal gradient with a small amber accent, clean modern sans-serif wordmark, white background, no text artifacts, suitable for app icon, vector style"

Gerar 8–12 variações, escolher 2–3, refinar em ferramenta vectorial, validar legibilidade em tamanhos pequenos. Guardar em `assets/brand/` com `README` a indicar ferramenta, prompt e data (rastreabilidade).

## Documentos impressos (PDF)

Boletim, pauta, recibo, factura, ficha do aluno, certificado e cartão partilham o mesmo motor de modelos: cabeçalho com logo da instituição, tipografia e cores dos tokens, rodapé com NIF/contactos, QR de verificação.
