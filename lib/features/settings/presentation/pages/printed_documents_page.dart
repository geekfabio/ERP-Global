import 'package:flutter/material.dart';

import '../../../../app/theme/app_tokens.dart';
import '../../../../core/widgets/cards/app_cards.dart';

/// Catálogo do motor único de PDFs. A emissão fica nos módulos de origem, mas
/// a identidade é sempre configurada na área Empresa.
class PrintedDocumentsPage extends StatelessWidget {
  const PrintedDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 960),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        children: [
          Text(
            'Documentos impressos',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.xs),
          const Text(
            'Todos os documentos usam a identidade da instituição definida em Empresa.',
          ),
          const SizedBox(height: AppSpacing.xl),
          const ListCard(
            title: 'Motor institucional de PDF',
            children: [
              ListTile(
                leading: Icon(Icons.account_balance_outlined),
                title: Text('Cabeçalho'),
                subtitle: Text('Logótipo, nome da instituição e cor da marca.'),
              ),
              ListTile(
                leading: Icon(Icons.text_fields_outlined),
                title: Text('Tipografia e tabelas'),
                subtitle: Text(
                  'Estilos consistentes com os tokens da aplicação.',
                ),
              ),
              ListTile(
                leading: Icon(Icons.qr_code_2_outlined),
                title: Text('Rodapé verificável'),
                subtitle: Text(
                  'NIF, contactos, paginação e QR de verificação.',
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          const ListCard(
            title: 'Modelos disponíveis',
            children: [
              ListTile(
                title: Text('Boletim e pauta'),
                subtitle: Text('Módulo Notas'),
              ),
              ListTile(
                title: Text('Recibo e factura'),
                subtitle: Text('Módulo Financeiro'),
              ),
              ListTile(
                title: Text('Ficha do aluno'),
                subtitle: Text('Módulo Alunos'),
              ),
              ListTile(
                title: Text('Certificado'),
                subtitle: Text('Módulo Notas'),
              ),
              ListTile(
                title: Text('Cartão escolar'),
                subtitle: Text('Módulo Cartões'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
