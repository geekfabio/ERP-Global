# Localização pt-AO

`app_pt.arb` é o catálogo base, com português de Angola; `app_pt_AO.arb`
declara a variante regional. `AppLocalizations.supportedLocales` dá prioridade
a `Locale('pt', 'AO')`. As dependências `flutter_localizations` e `intl` já
existem no projecto.

Para adicionar textos:

1. Acrescentar uma chave em inglês e o texto pt-AO aos dois ARB.
2. Acrescentar `@chave.description` ao catálogo base. Para parâmetros e plurais,
   usar a sintaxe ICU e os metadados `placeholders` do gerador Flutter.
3. Executar `dart run lib/app/l10n/generate_localizations.dart` com o Flutter no
   PATH. O comando usa `flutter gen-l10n` num projecto temporário e escreve os
   ficheiros gerados nesta pasta; não editar estes ficheiros manualmente.
4. Executar `dart format .`, `flutter analyze`, `flutter test` e os testes locais:
   `flutter test lib/app/l10n/localizations_test.dart lib/core/utils/pt_ao_formatters_test.dart`.

A geração isolada mantém esta pista dentro das pastas autorizadas, sem exigir
`l10n.yaml` na raiz nem alterar o `pubspec.yaml`. Os ficheiros gerados devem ser
versionados. A integração seguinte pertence à pista que pode editar a shell:

```dart
MaterialApp.router(
  locale: const Locale('pt', 'AO'),
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
  // Manter a configuração existente do router e do tema.
)
```

Nos widgets, usar `AppLocalizations.of(context).chave`. Substituir também o texto
do placeholder em `lib/app/router/app_router.dart` por `appTitle`.
Esses dois ficheiros estão fora do âmbito autorizado desta pista; o critério
«sem textos fixos na app shell» fica pendente dessa integração.

Os formatadores estão em `lib/core/utils/pt_ao_formatters.dart`. Aguardar
`PtAoFormatters.initialize()` antes de apresentar datas. `currency(123456)`
apresenta `1 234,56 Kz`: a entrada é sempre um `int` em cêntimos, sem conversão
para `double`. `number` aceita números gerais e casas decimais; usa os símbolos
`pt_PT` porque o `intl` não contém símbolos `pt_AO`, evitando o agrupamento
brasileiro do fallback `pt`. Os espaços de agrupamento e moeda são inquebráveis.
`date` e `dateTime` usam `dd/MM/yyyy` e `dd/MM/yyyy HH:mm`; preservam o fuso da
entrada. O chamador converte para o fuso de apresentação quando necessário,
mantendo UTC na persistência.
