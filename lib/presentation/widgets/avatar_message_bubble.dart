import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../app/theme/colors.dart';

/// Widget que muestra un mensaje en forma de burbuja de diálogo estilo cómic
class AvatarMessageBubble extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback? onDismiss;
  final Color? backgroundColor;
  final Color? textColor;

  const AvatarMessageBubble({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 4),
    this.onDismiss,
    this.backgroundColor,
    this.textColor,
  });

  @override
  State<AvatarMessageBubble> createState() => _AvatarMessageBubbleState();
}

class _AvatarMessageBubbleState extends State<AvatarMessageBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Iniciar animación de entrada
    _controller.forward();

    // Auto-ocultar después del tiempo especificado
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          if (widget.onDismiss != null) {
            widget.onDismiss!();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: CustomPaint(
          painter: _BubblePainter(
            color: widget.backgroundColor ?? Colors.white,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 12,
            ),
            constraints: const BoxConstraints(
              maxWidth: 280,
              minHeight: 60,
            ),
            child: Center(
              child: Text(
                widget.message,
                style: GoogleFonts.fredoka(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: widget.textColor ?? AppColors.textPrimary,
                  height: 1.3,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Painter personalizado para dibujar la burbuja de diálogo con cola
class _BubblePainter extends CustomPainter {
  final Color color;

  _BubblePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final path = Path();

    // Cuerpo principal de la burbuja (rectángulo redondeado)
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height - 15),
      const Radius.circular(20),
    );

    // Dibujar sombra
    canvas.drawRRect(
      rect.shift(const Offset(0, 2)),
      shadowPaint,
    );

    // Dibujar burbuja principal
    path.addRRect(rect);

    // Añadir cola de la burbuja (triángulo en la parte inferior)
    final tailPath = Path();
    tailPath.moveTo(size.width / 2 - 15, size.height - 15);
    tailPath.lineTo(size.width / 2, size.height);
    tailPath.lineTo(size.width / 2 + 15, size.height - 15);
    tailPath.close();

    path.addPath(tailPath, Offset.zero);

    canvas.drawPath(path, paint);

    // Borde de la burbuja
    final borderPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
