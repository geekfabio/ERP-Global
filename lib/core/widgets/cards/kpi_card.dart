import 'package:flutter/material.dart';

import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_tokens.dart';

/// Indicador com contagem animada e variação face ao período anterior.
/// A animação é omitida quando `MediaQuery.disableAnimations` está activo.
///
/// Opcionalmente: [accent] (cor do módulo no ícone, tendência e progresso),
/// [trend] (mini-gráfico), [progress] (0–1, ex.: percentagem ou meta) e
/// [caption] (contexto da variação, ex.: "vs. trimestre anterior").
class KpiCard extends StatelessWidget {
  const KpiCard({
    super.key,
    required this.label,
    required this.value,
    this.format,
    this.deltaPercent,
    this.icon,
    this.accent,
    this.trend,
    this.progress,
    this.caption,
    this.higherIsBetter = true,
  });

  final String label;

  /// Valor inteiro (ex.: cêntimos ou contagem); [format] apresenta-o.
  final int value;
  final String Function(int value)? format;

  /// Variação em %; verde quando melhora, vermelha quando piora.
  final double? deltaPercent;
  final IconData? icon;
  final Color? accent;
  final List<double>? trend;
  final double? progress;
  final String? caption;

  /// `false` nos indicadores em que subir é mau (dívida, inadimplência).
  final bool higherIsBetter;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final color = accent ?? scheme.primary;
    final animate = !(MediaQuery.maybeDisableAnimationsOf(context) ?? false);
    final show = format ?? (v) => '$v';
    final points = trend;
    final bar = progress;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (icon != null) ...[
                  _IconBox(icon: icon!, color: color),
                  const SizedBox(width: AppSpacing.md),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Lido uma só vez, com o valor ("Alunos: 312").
                      ExcludeSemantics(
                        child: Text(
                          label,
                          style: text.labelLarge?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: TweenAnimationBuilder<int>(
                              tween: IntTween(
                                begin: animate ? 0 : value,
                                end: value,
                              ),
                              duration: animate
                                  ? AppMotion.page
                                  : Duration.zero,
                              curve: AppMotion.curve,
                              builder: (_, v, _) => Semantics(
                                label: '$label: ${show(value)}',
                                child: ExcludeSemantics(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    alignment: Alignment.centerLeft,
                                    // Uma linha: o FittedBox reduz em vez
                                    // de quebrar (e a altura intrínseca,
                                    // usada nas grelhas, bate certo).
                                    child: Text(
                                      show(v),
                                      maxLines: 1,
                                      softWrap: false,
                                      style: text.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          if (points != null && points.length > 1) ...[
                            const SizedBox(width: AppSpacing.sm),
                            _TrendLine(values: points, color: color),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (bar != null) ...[
              const SizedBox(height: AppSpacing.md),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadius.input),
                child: LinearProgressIndicator(
                  value: bar.clamp(0, 1).toDouble(),
                  minHeight: 6,
                  color: color,
                  backgroundColor: color.withValues(alpha: 0.15),
                  semanticsLabel: label,
                ),
              ),
            ],
            if (deltaPercent != null || caption != null) ...[
              const SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  if (deltaPercent != null)
                    _Delta(deltaPercent!, higherIsBetter: higherIsBetter),
                  if (caption != null)
                    Text(
                      caption!,
                      style: text.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Ícone do indicador num quadrado tingido com a cor de destaque.
class _IconBox extends StatelessWidget {
  const _IconBox({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: SizedBox.square(
        dimension: AppSizes.minTouchTarget,
        child: Icon(icon, color: color),
      ),
    ),
  );
}

/// Tendência com área em gradiente; desenhada à mão para não pesar em grelhas
/// com muitos cartões (o `Sparkline` usa `fl_chart`).
class _TrendLine extends StatelessWidget {
  const _TrendLine({required this.values, required this.color});

  final List<double> values;
  final Color color;

  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      width: 72,
      height: 32,
      child: CustomPaint(painter: _TrendPainter(values, color)),
    ),
  );
}

class _TrendPainter extends CustomPainter {
  _TrendPainter(this.values, this.color);

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final lo = values.reduce((a, b) => a < b ? a : b);
    final hi = values.reduce((a, b) => a > b ? a : b);
    final span = hi == lo ? 1 : hi - lo;
    final step = size.width / (values.length - 1);
    final line = Path();
    for (final (i, v) in values.indexed) {
      final x = i * step;
      final y = size.height * (1 - (v - lo) / span);
      i == 0 ? line.moveTo(x, y) : line.lineTo(x, y);
    }
    final area = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    final fill = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0)],
      ).createShader(Offset.zero & size);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    canvas
      ..drawPath(area, fill)
      ..drawPath(line, stroke);
  }

  @override
  bool shouldRepaint(_TrendPainter old) =>
      old.color != color || old.values.join(',') != values.join(',');
}

class _Delta extends StatelessWidget {
  const _Delta(this.percent, {required this.higherIsBetter});

  final double percent;
  final bool higherIsBetter;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final up = percent >= 0;
    final color = up == higherIsBetter ? colors.success : colors.danger;
    final sign = up ? '+' : '';
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadius.modal),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs / 2,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              up ? Icons.arrow_upward : Icons.arrow_downward,
              size: 14,
              color: color,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$sign${percent.toStringAsFixed(1).replaceAll('.', ',')}%',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
