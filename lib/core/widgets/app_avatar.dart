import 'package:flutter/material.dart';

/// Avatar com foto (se existir) ou iniciais do [name].
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.radius = 20,
  });

  final String name;
  final String? imageUrl;
  final double radius;

  /// Primeira letra do primeiro e do último nome, em maiúsculas.
  static String initialsOf(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return (first + last).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    return Semantics(
      label: name,
      child: ExcludeSemantics(
        child: CircleAvatar(
          radius: radius,
          backgroundImage: url == null ? null : NetworkImage(url),
          child: url == null
              ? Text(initialsOf(name), style: TextStyle(fontSize: radius * 0.8))
              : null,
        ),
      ),
    );
  }
}
