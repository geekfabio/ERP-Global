import 'dart:convert';

import 'package:erp_global/features/billing/data/models/cash_register.dart';
import 'package:erp_global/features/billing/data/models/charge.dart';
import 'package:erp_global/features/billing/data/models/fee_item.dart';
import 'package:erp_global/features/billing/data/models/invoice.dart';
import 'package:erp_global/features/billing/data/models/payment.dart';
import 'package:erp_global/features/billing/data/models/receipt.dart';
import 'package:erp_global/features/billing/data/models/student_account.dart';
import 'package:flutter_test/flutter_test.dart';

const _id = '01ARZ3NDEKTSV4RRFFQ69G5FAV';
const _time = '2026-09-01T09:00:00+01:00';
const _utc = '2026-09-01T08:00:00.000Z';
const _amount = 1234567890123;
const _base = {
  'id': _id,
  'institutionId': _id,
  'campusId': _id,
  'createdAt': _time,
  'updatedAt': _time,
  'deletedAt': _time,
  'syncState': 'pending',
};
const _line = {
  'chargeId': _id,
  'description': 'Propina de Setembro',
  'amountMinor': _amount,
};
const _allocation = {'chargeId': _id, 'amountMinor': _amount};
const _entry = {
  'id': _id,
  'referenceId': _id,
  'occurredAt': _time,
  'debitMinor': 0,
  'creditMinor': _amount,
};

void _contract<T>(
  String name,
  T Function(Map<String, dynamic>) fromJson,
  Map<String, dynamic> Function(T) toJson,
  Map<String, dynamic> fields, {
  Map<String, List<String>> enums = const {},
}) {
  final json = <String, dynamic>{..._base, ...fields};
  group(name, () {
    test('preserva campos e inteiros no ciclo JSON completo', () {
      final model = fromJson(json);
      final encoded = toJson(model);
      final decoded = jsonDecode(jsonEncode(encoded)) as Map<String, dynamic>;
      expect(fromJson(decoded), model);
      for (final field in json.entries) {
        if (field.key.endsWith('At')) {
          expect(encoded[field.key], _utc);
        } else if (field.value is! List) {
          expect(encoded[field.key], field.value);
        }
      }
    });

    test('campos opcionais e sincronização por omissão', () {
      final minimal = {...json}
        ..remove('campusId')
        ..remove('deletedAt')
        ..remove('syncState');
      final encoded = toJson(fromJson(minimal));
      expect(encoded['campusId'], isNull);
      expect(encoded['deletedAt'], isNull);
      expect(encoded['syncState'], 'synced');
    });

    test('rejeita datas de auditoria sem fuso', () {
      for (final key in ['createdAt', 'updatedAt', 'deletedAt']) {
        expect(
          () => fromJson({...json, key: '2026-09-01T09:00:00'}),
          throwsFormatException,
        );
      }
    });

    for (final key in fields.keys.where((key) => key.endsWith('Minor'))) {
      test('$key mantém cêntimos e rejeita valores não inteiros', () {
        for (final value in [0, 1, _amount]) {
          expect(toJson(fromJson({...json, key: value}))[key], value);
        }
        for (final value in [1.5, '150', null]) {
          // Campos obrigatórios rejeitam null; discountMinor tem default zero.
          if (value == null && key == 'discountMinor') continue;
          expect(
            () => fromJson({...json, key: value}),
            throwsA(isA<TypeError>()),
          );
        }
      });
    }

    for (final field in enums.entries) {
      test('${field.key} preserva o contrato dos enums', () {
        for (final value in field.value) {
          expect(
            toJson(fromJson({...json, field.key: value}))[field.key],
            value,
          );
        }
        expect(
          () => fromJson({...json, field.key: 'unknown'}),
          throwsArgumentError,
        );
      });
    }
  });
}

void main() {
  _contract(
    'FeeItem',
    FeeItem.fromJson,
    (m) => m.toJson(),
    {
      'academicYearId': _id,
      'gradeId': _id,
      'type': 'tuition',
      'amountMinor': _amount,
    },
    enums: {
      'type': [
        'enrollment',
        'tuition',
        'uniform',
        'material',
        'exam',
        'transport',
        'cafeteria',
        'other',
      ],
      'status': ['active', 'inactive'],
    },
  );
  _contract(
    'Charge',
    Charge.fromJson,
    (m) => m.toJson(),
    {
      'studentId': _id,
      'feeItemId': _id,
      'dueDate': '2026-09-30',
      'amountMinor': _amount,
      'discountMinor': 12501,
    },
    enums: {
      'status': ['pending', 'partially_paid', 'paid', 'overdue', 'cancelled'],
    },
  );
  _contract(
    'Invoice',
    Invoice.fromJson,
    (m) => m.toJson(),
    {
      'studentId': _id,
      'number': 'FT 2026/1',
      'issuedAt': _time,
      'totalMinor': _amount,
      'lines': [_line],
    },
    enums: {
      'status': ['draft', 'issued', 'cancelled'],
    },
  );
  _contract(
    'Receipt',
    Receipt.fromJson,
    (m) => m.toJson(),
    {
      'studentId': _id,
      'paymentId': _id,
      'number': 'RC 2026/1',
      'issuedAt': _time,
      'amountMinor': _amount,
    },
    enums: {
      'status': ['issued', 'cancelled'],
    },
  );
  _contract(
    'Payment',
    Payment.fromJson,
    (m) => m.toJson(),
    {
      'studentId': _id,
      'method': 'bank_transfer',
      'paidAt': _time,
      'amountMinor': _amount,
      'allocations': [_allocation],
    },
    enums: {
      'method': [
        'cash',
        'bank_transfer',
        'card',
        'payment_reference',
        'prepaid_balance',
      ],
      'status': ['pending', 'completed', 'failed', 'reversed'],
    },
  );
  _contract('StudentAccount', StudentAccount.fromJson, (m) => m.toJson(), {
    'studentId': _id,
    'balanceMinor': -_amount,
    'entries': [_entry],
  });
  _contract(
    'CashRegister',
    CashRegister.fromJson,
    (m) => m.toJson(),
    {'name': 'Caixa principal'},
    enums: {
      'status': ['active', 'inactive'],
    },
  );

  test('listas aninhadas são JSON explícito, tipadas e imutáveis', () {
    final invoice = Invoice.fromJson({
      ..._base,
      'studentId': _id,
      'totalMinor': _amount,
      'lines': [_line],
    });
    final payment = Payment.fromJson({
      ..._base,
      'studentId': _id,
      'method': 'cash',
      'paidAt': _time,
      'amountMinor': _amount,
      'allocations': [_allocation],
    });
    final account = StudentAccount.fromJson({
      ..._base,
      'studentId': _id,
      'balanceMinor': -_amount,
      'entries': [_entry],
    });
    expect(invoice.toJson()['lines'], [_line]);
    expect(payment.toJson()['allocations'], [_allocation]);
    expect(account.toJson()['entries'], [
      {..._entry, 'occurredAt': _utc},
    ]);
    expect(account.entries.single.occurredAt.isUtc, isTrue);
    expect(() => invoice.lines.clear(), throwsUnsupportedError);
    expect(() => payment.allocations.clear(), throwsUnsupportedError);
    expect(() => account.entries.clear(), throwsUnsupportedError);
    expect(invoice.copyWith(), invoice);
    expect(payment.copyWith(amountMinor: 1).amountMinor, 1);
    expect(payment.amountMinor, _amount);
    expect(account.copyWith(balanceMinor: 0), isNot(account));
    expect(invoice.number, isNull);
    expect(invoice.issuedAt, isNull);
  });

  test('montantes aninhados também rejeitam decimais', () {
    expect(
      () => InvoiceLine.fromJson({..._line, 'amountMinor': 1.5}),
      throwsA(isA<TypeError>()),
    );
    expect(
      () => PaymentAllocation.fromJson({..._allocation, 'amountMinor': 1.5}),
      throwsA(isA<TypeError>()),
    );
    for (final key in ['debitMinor', 'creditMinor']) {
      expect(
        () => LedgerEntry.fromJson({..._entry, key: 1.5}),
        throwsA(isA<TypeError>()),
      );
    }
  });
}
