// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'ERP-Global';

  @override
  String get loginTitle => 'Iniciar sessão';

  @override
  String get identifierLabel => 'E-mail ou telefone';

  @override
  String get passwordLabel => 'Palavra-passe';

  @override
  String get signInAction => 'Entrar';

  @override
  String get loadingMessage => 'A carregar…';

  @override
  String get retryAction => 'Tentar novamente';
}

/// The translations for Portuguese, as used in Angola (`pt_AO`).
class AppLocalizationsPtAo extends AppLocalizationsPt {
  AppLocalizationsPtAo() : super('pt_AO');

  @override
  String get appTitle => 'ERP-Global';

  @override
  String get loginTitle => 'Iniciar sessão';

  @override
  String get identifierLabel => 'E-mail ou telefone';

  @override
  String get passwordLabel => 'Palavra-passe';

  @override
  String get signInAction => 'Entrar';

  @override
  String get loadingMessage => 'A carregar…';

  @override
  String get retryAction => 'Tentar novamente';
}
