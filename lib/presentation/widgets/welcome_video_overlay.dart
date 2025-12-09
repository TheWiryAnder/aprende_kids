import 'package:flutter/material.dart';

/// Overlay que muestra el GIF de bienvenida al iniciar sesión
class WelcomeVideoOverlay {
  static OverlayEntry? _currentOverlay;

  /// Muestra el GIF de bienvenida
  static void show(BuildContext context) {
    dismiss(); // Remover overlay previo si existe

    _currentOverlay = OverlayEntry(
      builder: (context) => const _WelcomeVideoWidget(),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }

  /// Cierra el overlay actual
  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

class _WelcomeVideoWidget extends StatefulWidget {
  const _WelcomeVideoWidget();

  @override
  State<_WelcomeVideoWidget> createState() => _WelcomeVideoWidgetState();
}

class _WelcomeVideoWidgetState extends State<_WelcomeVideoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar animación de fade
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();

    // Auto cerrar después de 3 segundos (duración aproximada del GIF)
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _closeOverlay();
      }
    });
  }

  Future<void> _closeOverlay() async {
    if (mounted) {
      await _fadeController.reverse();
      WelcomeVideoOverlay.dismiss();
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtener tamaño de pantalla
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 800;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Material(
        color: Colors.transparent,
        child: GestureDetector(
          onTap: _closeOverlay, // Cerrar al hacer click
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black.withValues(alpha: 0.3), // Fondo semi-transparente suave
            child: Center(
              child: _buildGif(isDesktop),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGif(bool isDesktop) {
    // Calcular tamaño del GIF - Más grande
    final gifSize = isDesktop ? 1000.0 : 700.0;

    return SizedBox(
      width: gifSize,
      height: gifSize,
      child: Image.asset(
        'assets/animacion/bienvenido.gif',
        fit: BoxFit.contain,
        gaplessPlayback: true,
        errorBuilder: (context, error, stackTrace) {
          // Si hay error, cerrar el overlay automáticamente
          Future.microtask(() => _closeOverlay());
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
