import 'package:erp_global/app/theme/app_tokens.dart';
import 'package:erp_global/core/animations/app_animate.dart';
import 'package:erp_global/core/animations/app_transitions.dart';
import 'package:erp_global/core/animations/reduce_motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  test('reduceMotionProvider alterna a flag', () {
    final c = ProviderContainer();
    addTearDown(c.dispose);
    expect(c.read(reduceMotionProvider), isFalse);
    c.read(reduceMotionProvider.notifier).set(true);
    expect(c.read(reduceMotionProvider), isTrue);
  });

  testWidgets('shouldReduceMotion respeita disableAnimations do sistema', (
    tester,
  ) async {
    late bool result;
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(disableAnimations: true),
        child: Builder(
          builder: (context) {
            result = shouldReduceMotion(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(result, isTrue);
  });

  testWidgets('páginas usam duração dos tokens e zero com reduceMotion', (
    tester,
  ) async {
    late GoRouterState state;
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, s) {
            state = s;
            return const SizedBox();
          },
        ),
      ],
    );
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    final normal = fadeThroughPage<void>(state: state, child: const SizedBox());
    final reduced = slidePage<void>(
      state: state,
      child: const SizedBox(),
      reduceMotion: true,
    );
    expect(normal.transitionDuration, AppMotion.page);
    expect(reduced.transitionDuration, Duration.zero);
  });

  testWidgets('appStagger não anima além do limite e SuccessCheck renderiza', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Column(
          children: [
            const SizedBox(key: Key('late')).appStagger(kMaxStaggerItems),
            const SuccessCheck(color: Colors.green),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('late')), findsOneWidget);
    expect(find.byIcon(Icons.check_circle), findsOneWidget);
  });
}
