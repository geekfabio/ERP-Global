import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/app.dart';
import 'core/audit/audit_providers.dart';
import 'core/audit/audit_service.dart';
import 'core/export/export_contract.dart';
import 'core/modules/license_gate.dart';
import 'core/network/api_client.dart';
import 'core/notifications/notification_service.dart';
import 'core/security/permission_providers.dart';
import 'core/sync/sync_providers.dart';
import 'core/utils/pt_ao_formatters.dart';
import 'features/auth/presentation/providers/auth_providers.dart';
import 'features/auth/presentation/providers/auth_state.dart';
import 'features/cards/presentation/providers/card_providers.dart';
import 'features/communication/presentation/providers/communication_providers.dart';
import 'features/import_export/presentation/providers/export_providers.dart';
import 'features/import_export/presentation/providers/import_providers.dart';
import 'features/inventory/presentation/providers/inventory_providers.dart';
import 'features/license/presentation/providers/license_providers.dart';
import 'features/students/presentation/providers/student_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Datas e números em pt-AO têm de estar carregados antes de qualquer ecrã.
  await PtAoFormatters.initialize();
  runApp(
    ProviderScope(
      overrides: [
        tokenStoreProvider.overrideWith(
          (ref) => ref.watch(persistentTokenStoreProvider),
        ),
        // O `core` não conhece `features/`: liga as permissões à sessão de auth.
        sessionPermissionsProvider.overrideWith(
          (ref) => ref.watch(currentSessionProvider)?.permissions,
        ),
        // Quem pratica as acções auditadas: o utilizador da sessão de auth.
        auditActorProvider.overrideWith((ref) {
          final user = ref.watch(currentSessionProvider)?.user;
          return user == null
              ? null
              : AuditActor(
                  id: user.id,
                  name: user.name,
                  institutionId: user.institutionId,
                );
        }),
        // Liga o gate de licença do core ao serviço de licenciamento.
        licenseGateProvider.overrideWith(
          (ref) => ref.watch(licenseGateFromServiceProvider),
        ),
        // Contrato de notificações do core → implementação do módulo communication.
        notificationServiceProvider.overrideWith(
          (ref) => ref.watch(communicationNotificationServiceProvider),
        ),
        // Contrato de exportação do core → serviço do módulo import_export.
        exportHandlerProvider.overrideWith(
          (ref) => ref.watch(exportRunnerProvider),
        ),
        // Módulos com API mock; só têm efeito com `AppConfig.useMockApi`.
        mockApiModulesProvider.overrideWith(
          (ref) => [
            ref.watch(authMockHandlersProvider),
            ref.watch(studentsMockHandlersProvider),
            ref.watch(auditMockHandlersProvider),
            ref.watch(syncMockHandlersProvider),
            ref.watch(communicationMockHandlersProvider),
            ref.watch(importMockHandlersProvider),
            ref.watch(cardsMockHandlersProvider),
            ref.watch(inventoryMockHandlersProvider),
          ],
        ),
      ],
      child: const ErpGlobalApp(),
    ),
  );
}
