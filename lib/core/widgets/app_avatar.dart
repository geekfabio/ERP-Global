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
      child: ExcludeSemantics(child: _image(context, url)),
    );
  }

  Widget _image(BuildContext context, String? url) {
    final fallback = CircleAvatar(
      radius: radius,
      child: Text(initialsOf(name), style: TextStyle(fontSize: radius * 0.8)),
    );
    if (url == null || url.isEmpty) return fallback;
    final cacheWidth = (radius * 2 * MediaQuery.devicePixelRatioOf(context))
        .ceil();

    if (url.startsWith('data:')) {
      try {
        final bytes = UriData.parse(url).contentAsBytes();
        return CircleAvatar(
          radius: radius,
          child: ClipOval(
            child: Image.memory(
              bytes,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              cacheWidth: cacheWidth,
              filterQuality: FilterQuality.low,
              errorBuilder: (_, _, _) => fallback,
            ),
          ),
        );
      } on FormatException {
        return fallback;
      }
    }
    return CircleAvatar(
      radius: radius,
      child: ClipOval(
        child: Image.network(
          url,
          width: radius * 2,
          height: radius * 2,
          fit: BoxFit.cover,
          cacheWidth: cacheWidth,
          filterQuality: FilterQuality.low,
          errorBuilder: (_, _, _) => fallback,
        ),
      ),
    );
  }
}
