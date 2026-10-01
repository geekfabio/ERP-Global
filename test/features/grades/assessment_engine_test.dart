import 'package:erp_global/features/grades/data/models/assessment_scheme_model.dart';
import 'package:erp_global/features/grades/domain/assessment_engine.dart';
import 'package:flutter_test/flutter_test.dart';

AssessmentComponentModel _c(String code, int w) =>
    AssessmentComponentModel(code: code, name: code, weight: w);

AssessmentSchemeModel _scheme({
  List<AssessmentComponentModel>? components,
  int scaleMax = 20,
  int minPassing = 10,
  RoundingMode rounding = RoundingMode.nearest,
  int decimals = 0,
  bool roundTerm = true,
  List<int> termWeights = const [],
}) => AssessmentSchemeModel(
  id: 's',
  name: 'Teste',
  components: components ?? [_c('MAC', 30), _c('NPP', 30), _c('NPT', 40)],
  scaleMax: scaleMax,
  minPassing: minPassing,
  rounding: rounding,
  decimals: decimals,
  roundTerm: roundTerm,
  termWeights: termWeights,
);

Matcher get _invalid => throwsA(isA<InvalidGradeException>());

void main() {
  group('roundGrade', () {
    test('nearest: meio para cima', () {
      expect(roundGrade(9.5, RoundingMode.nearest, 0), 10);
      expect(roundGrade(9.49, RoundingMode.nearest, 0), 9);
      expect(roundGrade(0.5, RoundingMode.nearest, 0), 1);
      expect(roundGrade(0, RoundingMode.nearest, 0), 0);
    });

    test('up e down', () {
      expect(roundGrade(9.01, RoundingMode.up, 0), 10);
      expect(roundGrade(9.99, RoundingMode.down, 0), 9);
      expect(roundGrade(9, RoundingMode.up, 0), 9);
      expect(roundGrade(9, RoundingMode.down, 0), 9);
    });

    test('casas decimais', () {
      expect(roundGrade(12.345, RoundingMode.nearest, 2), 12.35);
      expect(roundGrade(12.344, RoundingMode.nearest, 1), 12.3);
      expect(roundGrade(12.31, RoundingMode.up, 1), 12.4);
      expect(roundGrade(12.39, RoundingMode.down, 1), 12.3);
    });

    test('absorve erros binários (1.005, 14.499999…)', () {
      expect(roundGrade(1.005, RoundingMode.nearest, 2), 1.01);
      expect(roundGrade(0.1 + 0.2, RoundingMode.up, 1), 0.3);
      expect(roundGrade(0.1 * 3, RoundingMode.down, 1), 0.3);
    });
  });

  group('MAC', () {
    final e = AssessmentEngine(_scheme());
    test('média simples das avaliações contínuas', () {
      expect(e.mac([10, 12, 14]), 12);
      expect(e.mac([13]), 13);
    });
    test('sem avaliações = pendente', () => expect(e.mac([]), isNull));
    test('valida intervalo', () {
      expect(() => e.mac([10, 21]), _invalid);
      expect(() => e.mac([-1]), _invalid);
    });
  });

  group('MT', () {
    test('média ponderada 30/30/40', () {
      final e = AssessmentEngine(_scheme(roundTerm: false));
      expect(e.termAverage({'MAC': 10, 'NPP': 12, 'NPT': 15}), 3 + 3.6 + 6);
      expect(e.termAverage({'MAC': 20, 'NPP': 20, 'NPT': 20}), 20);
      expect(e.termAverage({'MAC': 0, 'NPP': 0, 'NPT': 0}), 0);
    });

    test('arredonda a MT quando roundTerm', () {
      final e = AssessmentEngine(_scheme());
      // 12.6 → 13
      expect(e.termAverage({'MAC': 10, 'NPP': 12, 'NPT': 15}), 13);
      // 9.7 → 10 ; 9.2 → 9
      expect(e.termAverage({'MAC': 9, 'NPP': 10, 'NPT': 10}), 10);
      expect(e.termAverage({'MAC': 9, 'NPP': 9, 'NPT': 9.5}), 9);
    });

    test('componente em falta → pendente, nunca zero', () {
      final e = AssessmentEngine(_scheme());
      expect(e.termAverage({'MAC': 10, 'NPP': 12}), isNull);
      expect(e.termAverage({'MAC': 10, 'NPP': null, 'NPT': 15}), isNull);
      expect(e.termAverage({}), isNull);
    });

    test('componente desconhecido ou nota inválida', () {
      final e = AssessmentEngine(_scheme());
      expect(() => e.termAverage({'XYZ': 10}), _invalid);
      expect(() => e.termAverage({'MAC': 21, 'NPP': 1, 'NPT': 1}), _invalid);
      expect(() => e.termAverage({'MAC': -0.5, 'NPP': 1, 'NPT': 1}), _invalid);
      expect(
        () => e.termAverage({'MAC': double.nan, 'NPP': 1, 'NPT': 1}),
        _invalid,
      );
    });

    test('escala configurável', () {
      final e = AssessmentEngine(_scheme(scaleMax: 100, minPassing: 50));
      expect(e.termAverage({'MAC': 100, 'NPP': 50, 'NPT': 25}), 55);
      expect(() => e.termAverage({'MAC': 101, 'NPP': 0, 'NPT': 0}), _invalid);
    });

    test('esquema com 2 componentes e casas decimais', () {
      final e = AssessmentEngine(
        _scheme(components: [_c('A', 50), _c('B', 50)], decimals: 1),
      );
      expect(e.termAverage({'A': 11, 'B': 12}), 11.5);
      expect(e.termAverage({'A': 11, 'B': 12.1}), 11.6);
    });
  });

  group('MF', () {
    test('média simples dos trimestres, arredondada', () {
      final e = AssessmentEngine(_scheme());
      expect(e.finalAverage([10, 12, 14]), 12);
      expect(e.finalAverage([10, 10, 11]), 10); // 10.33
      expect(e.finalAverage([10, 11, 11]), 11); // 10.67
      expect(e.finalAverage([9, 10]), 10); // 9.5 → 10
    });

    test('trimestre pendente → pendente', () {
      final e = AssessmentEngine(_scheme());
      expect(e.finalAverage([10, null, 12]), isNull);
      expect(e.finalAverage([]), isNull);
    });

    test('pesos por trimestre', () {
      final e = AssessmentEngine(_scheme(termWeights: [20, 30, 50]));
      expect(e.finalAverage([10, 10, 20]), 15); // 2+3+10
      expect(e.finalAverage([20, 0, 0]), 4);
    });

    test('nº de trimestres incompatível com os pesos', () {
      final e = AssessmentEngine(_scheme(termWeights: [50, 50]));
      expect(() => e.finalAverage([10, 10, 10]), _invalid);
    });

    test('arredondamento up/down e decimais', () {
      expect(
        AssessmentEngine(
          _scheme(rounding: RoundingMode.up),
        ).finalAverage([10, 10, 11]),
        11,
      );
      expect(
        AssessmentEngine(
          _scheme(rounding: RoundingMode.down),
        ).finalAverage([10, 11, 11]),
        10,
      );
      expect(
        AssessmentEngine(_scheme(decimals: 2)).finalAverage([10, 10, 11]),
        10.33,
      );
    });

    test('valida intervalo das MT', () {
      final e = AssessmentEngine(_scheme());
      expect(() => e.finalAverage([10, 25, 10]), _invalid);
    });
  });

  group('aprovação', () {
    final e = AssessmentEngine(_scheme());
    test('limite na nota mínima', () {
      expect(e.outcome(10), GradeOutcome.approved);
      expect(e.outcome(9.99), GradeOutcome.failed);
      expect(e.outcome(0), GradeOutcome.failed);
      expect(e.outcome(20), GradeOutcome.approved);
    });
    test(
      'sem MF = pendente',
      () => expect(e.outcome(null), GradeOutcome.pending),
    );
    test('nota mínima configurável', () {
      final s = AssessmentEngine(_scheme(minPassing: 14));
      expect(s.outcome(13), GradeOutcome.failed);
      expect(s.outcome(14), GradeOutcome.approved);
    });
  });

  test('fluxo completo MAC/NPP/NPT → MT → MF → aprovação', () {
    final e = AssessmentEngine(_scheme());
    final terms = [
      for (final t in [
        (mac: [12.0, 14.0], npp: 11.0, npt: 13.0),
        (mac: [9.0, 10.0], npp: 8.0, npt: 10.0),
        (mac: [15.0, 16.0], npp: 14.0, npt: 15.0),
      ])
        e.termAverage({'MAC': e.mac(t.mac), 'NPP': t.npp, 'NPT': t.npt}),
    ];
    // 13*.3+11*.3+13*.4=12.4→12 ; 9.5*.3+8*.3+10*.4=9.25→9 ; 15.5*.3+14*.3+15*.4=14.85→15
    expect(terms, [12, 9, 15]);
    final mf = e.finalAverage(terms);
    expect(mf, 12);
    expect(e.outcome(mf), GradeOutcome.approved);
  });

  group('validateScheme', () {
    test('esquema válido', () => expect(validateScheme(_scheme()), isEmpty));

    test('pesos têm de somar 100', () {
      expect(
        validateScheme(_scheme(components: [_c('A', 50), _c('B', 40)])),
        contains('components'),
      );
    });

    test('códigos únicos, peso positivo e pelo menos um componente', () {
      expect(
        validateScheme(_scheme(components: [_c('A', 50), _c('A', 50)])),
        contains('components'),
      );
      expect(
        validateScheme(_scheme(components: [_c('A', 100), _c('B', 0)])),
        contains('components'),
      );
      expect(validateScheme(_scheme(components: [])), contains('components'));
    });

    test('escala, nota mínima e casas decimais', () {
      expect(validateScheme(_scheme(scaleMax: 0)), contains('scaleMax'));
      expect(validateScheme(_scheme(scaleMax: 101)), contains('scaleMax'));
      expect(validateScheme(_scheme(minPassing: 21)), contains('minPassing'));
      expect(validateScheme(_scheme(minPassing: -1)), contains('minPassing'));
      expect(validateScheme(_scheme(decimals: 3)), contains('decimals'));
    });

    test('pesos dos trimestres somam 100', () {
      expect(
        validateScheme(_scheme(termWeights: [30, 30, 30])),
        contains('termWeights'),
      );
      expect(validateScheme(_scheme(termWeights: [30, 30, 40])), isEmpty);
    });
  });
}
