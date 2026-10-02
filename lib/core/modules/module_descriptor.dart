import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Descrição de um módulo licenciável (docs/02-modulos-e-licenciamento.md).
@immutable
class ModuleDescriptor {
  const ModuleDescriptor({
    required this.code,
    required this.name,
    required this.icon,
    required this.path,
    this.permissions = const [],
    this.dependencies = const [],
    this.permissionNamespace,
    this.required = false,
    this.showInMenu = true,
    this.routes,
  });

  /// Código estável (`students`, `billing`, …) — o mesmo da licença.
  final String code;

  /// Nome apresentado no menu (pt-AO).
  final String name;
  final IconData icon;

  /// Caminho base das rotas do módulo (`/students`).
  final String path;

  /// Permissões que o módulo define (`students.record.read`, …).
  final List<String> permissions;

  /// Códigos de módulos de que depende (resolvidos pelo [ModuleRegistry]).
  final List<String> dependencies;

  /// Prefixo das permissões do módulo (`students.record.read` → `students`);
  /// por omissão, o próprio [code].
  final String? permissionNamespace;
  String get namespace => permissionNamespace ?? code;

  /// Módulo obrigatório (`core`): sempre activo.
  final bool required;
  final bool showInMenu;

  /// Rotas do módulo; sem elas, é gerada uma página placeholder em [path].
  final List<RouteBase> Function()? routes;
}
