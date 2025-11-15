/// Utilidades para diseño responsive
///
/// Proporciona breakpoints y funciones helper para adaptar la UI
/// a diferentes tamaños de pantalla (móvil, tablet, desktop).
///
/// Autor: Sistema Educativo
/// Fecha: 2025

import 'package:flutter/material.dart';

/// Breakpoints para diseño responsive
class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1200;
}

/// Tipo de dispositivo según el ancho de pantalla
enum DeviceType {
  mobile,
  tablet,
  desktop,
}

/// Extensión de BuildContext para facilitar queries responsive
extension ResponsiveContext on BuildContext {
  /// Obtiene el ancho de la pantalla
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Obtiene el alto de la pantalla
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Verifica si es móvil (< 480px)
  bool get isMobile => screenWidth < Breakpoints.mobile;

  /// Verifica si es tablet (480px - 768px)
  bool get isTablet =>
      screenWidth >= Breakpoints.mobile && screenWidth < Breakpoints.tablet;

  /// Verifica si es desktop (>= 768px)
  bool get isDesktop => screenWidth >= Breakpoints.tablet;

  /// Obtiene el tipo de dispositivo
  DeviceType get deviceType {
    if (isMobile) return DeviceType.mobile;
    if (isTablet) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  /// Retorna un valor según el tipo de dispositivo
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop) return desktop ?? tablet ?? mobile;
    if (isTablet) return tablet ?? mobile;
    return mobile;
  }
}

/// Calcula el número de columnas para un grid según el ancho
int getGridCrossAxisCount(double width, {double minItemWidth = 120}) {
  if (width < Breakpoints.mobile) {
    // Móvil: 2 columnas
    return 2;
  } else if (width < Breakpoints.tablet) {
    // Tablet pequeño: 3 columnas
    return 3;
  } else if (width < Breakpoints.desktop) {
    // Tablet grande: 4 columnas
    return 4;
  } else {
    // Desktop: 5-6 columnas
    return (width / minItemWidth).floor().clamp(4, 6);
  }
}

/// Obtiene el padding responsive según el ancho de pantalla
EdgeInsets getResponsivePadding(BuildContext context) {
  return EdgeInsets.symmetric(
    horizontal: context.responsive(
      mobile: 16.0,
      tablet: 24.0,
      desktop: 32.0,
    ),
    vertical: context.responsive(
      mobile: 12.0,
      tablet: 16.0,
      desktop: 20.0,
    ),
  );
}

/// Obtiene el tamaño de fuente responsive
double getResponsiveFontSize(
  BuildContext context, {
  required double mobile,
  double? tablet,
  double? desktop,
}) {
  return context.responsive(
    mobile: mobile,
    tablet: tablet ?? mobile * 1.1,
    desktop: desktop ?? mobile * 1.2,
  );
}

/// Widget que adapta su contenido según el breakpoint
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return builder(context, context.deviceType);
      },
    );
  }
}

/// Widget que centra contenido con ancho máximo
class CenteredConstrainedBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;

  const CenteredConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
