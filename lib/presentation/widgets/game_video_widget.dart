import 'package:flutter/material.dart';

/// Widget que muestra animaciones GIF de feedback durante el juego
class GameVideoWidget extends StatefulWidget {
  final GameVideoType videoType;
  final double width;
  final double height;
  final VoidCallback? onVideoEnd;

  const GameVideoWidget({
    super.key,
    required this.videoType,
    this.width = 300,
    this.height = 300,
    this.onVideoEnd,
  });

  @override
  State<GameVideoWidget> createState() => _GameVideoWidgetState();
}

enum GameVideoType {
  pensando, // Mientras está jugando/pensando
  excelente, // Cuando acierta
  intentalo, // Cuando falla
}

class _GameVideoWidgetState extends State<GameVideoWidget>
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
  }

  @override
  void didUpdateWidget(GameVideoWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Si cambió el tipo de video, reiniciar la animación de fade
    if (oldWidget.videoType != widget.videoType) {
      _fadeController.reset();
      _fadeController.forward();
    }
  }

  String _getGifSource() {
    switch (widget.videoType) {
      case GameVideoType.pensando:
        return 'assets/animacion/pensando.gif';
      case GameVideoType.excelente:
        return 'assets/animacion/excelente.gif';
      case GameVideoType.intentalo:
        return 'assets/animacion/intentato.gif'; // Nota: nombre con typo en el archivo
    }
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
          _getGifSource(),
          fit: BoxFit.contain,
          // GIF se reproduce automáticamente en bucle
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
