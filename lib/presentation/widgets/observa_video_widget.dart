import 'package:flutter/material.dart';

/// Widget que muestra el GIF "observa" en la parte izquierda
class ObservaVideoWidget extends StatefulWidget {
  final VoidCallback? onComplete;
  final bool autoPlay;
  final double width;
  final double height;

  const ObservaVideoWidget({
    super.key,
    this.onComplete,
    this.autoPlay = true,
    this.width = 300,
    this.height = 300,
  });

  @override
  State<ObservaVideoWidget> createState() => _ObservaVideoWidgetState();
}

class _ObservaVideoWidgetState extends State<ObservaVideoWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Configurar animación de fade
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: Image.asset(
          'assets/animacion/observa.gif',
          fit: BoxFit.contain,
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colors.grey.shade200,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Error cargando animación',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
