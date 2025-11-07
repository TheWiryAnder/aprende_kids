/// Widget de Avatar Animado
///
/// Renderiza un avatar personalizado utilizando capas SVG o PNG con un estilo
/// caricaturesco. Mantiene compatibilidad con las expresiones animadas.
///
/// Autor: Sistema Educativo
/// Fecha: 2025

import 'package:flutter/material.dart';
import '../../app/config/avatar_catalog.dart';
import '../../domain/models/avatar_model.dart';
import '../../domain/models/avatar_part_item.dart';
import 'avatar_asset.dart';

class _LayerLayout {
  final double widthFactor;
  final double heightFactor;
  final double topFactor;
  final double dxFactor;

  const _LayerLayout({
    required this.widthFactor,
    required this.heightFactor,
    required this.topFactor,
    this.dxFactor = 0,
  });
}

const Map<String, _LayerLayout> _layerLayouts = {
  'face': _LayerLayout(widthFactor: 0.68, heightFactor: 0.46, topFactor: 0.18),
  'body': _LayerLayout(widthFactor: 0.9, heightFactor: 0.68, topFactor: 0.34),
  'eyes': _LayerLayout(widthFactor: 0.36, heightFactor: 0.16, topFactor: 0.32),
  'mouth': _LayerLayout(widthFactor: 0.32, heightFactor: 0.12, topFactor: 0.46),
  'hair': _LayerLayout(widthFactor: 0.96, heightFactor: 0.48, topFactor: -0.02),
  'accessory': _LayerLayout(widthFactor: 0.72, heightFactor: 0.22, topFactor: 0.32),
  'top': _LayerLayout(widthFactor: 0.84, heightFactor: 0.46, topFactor: 0.4),
  'hands': _LayerLayout(widthFactor: 1.02, heightFactor: 0.32, topFactor: 0.52),
  'bottom': _LayerLayout(widthFactor: 0.76, heightFactor: 0.34, topFactor: 0.66),
  'shoes': _LayerLayout(widthFactor: 0.72, heightFactor: 0.2, topFactor: 0.84),
};

class AvatarWidget extends StatefulWidget {
  final AvatarModel avatar;
  final double size;
  final String? expression; // Sobrescribe la expresión del modelo si se proporciona
  final bool animate;

  const AvatarWidget({
    super.key,
    required this.avatar,
    this.size = 120,
    this.expression,
    this.animate = false,
  });

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget>
    with SingleTickerProviderStateMixin {
  static const double _canvasWidth = 300;
  static const double _canvasHeight = 420;

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _bounceAnimation = Tween<double>(begin: 0.0, end: -10.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Determina si se debe usar una variación de ojos según la expresión.
  String _resolveEyesForExpression(String expression) {
    switch (expression) {
      case 'excited':
        return 'eyes_round_blue';
      case 'cool':
        return 'eyes_round_green';
      case 'thinking':
        return widget.avatar.eyes;
      case 'surprised':
        return 'eyes_round_green';
      default:
        return widget.avatar.eyes;
    }
  }

  /// Determina si se debe usar una variación de boca según la expresión.
  String _resolveMouthForExpression(String expression) {
    switch (expression) {
      case 'happy':
      case 'celebrating':
      case 'jumping':
      case 'running':
        return 'mouth_grin';
      case 'thinking':
      case 'confused':
        return 'mouth_shy';
      case 'sad':
      case 'tired':
        return 'mouth_shy';
      default:
        return widget.avatar.mouth;
    }
  }

  /// Obtiene el contenido extra según la expresión (efectos)
  Widget? _getExpressionEffect(String expression) {
    switch (expression) {
      case 'celebrating':
        return Positioned(
          top: -10,
          right: -10,
          child: Text(
            '🎉',
            style: TextStyle(fontSize: widget.size * 0.4),
          ),
        );
      case 'thinking':
        return Positioned(
          top: -5,
          right: -5,
          child: Text(
            '💭',
            style: TextStyle(fontSize: widget.size * 0.3),
          ),
        );
      case 'excited':
        return Positioned(
          top: -10,
          left: -10,
          child: Text(
            '✨',
            style: TextStyle(fontSize: widget.size * 0.3),
          ),
        );
      case 'jumping':
        return Positioned(
          bottom: -5,
          child: Text(
            '💨',
            style: TextStyle(fontSize: widget.size * 0.25),
          ),
        );
      case 'running':
        return Positioned(
          right: -10,
          bottom: widget.size * 0.3,
          child: Text(
            '💨💨',
            style: TextStyle(fontSize: widget.size * 0.2),
          ),
        );
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final expression = widget.expression ?? widget.avatar.currentExpression;
    final effect = _getExpressionEffect(expression);

    Widget avatarContent = _buildAvatarStack(expression);

    // Aplicar animación de bouncing para expresiones de salto
    if (expression == 'jumping' || expression == 'celebrating') {
      avatarContent = AnimatedBuilder(
        animation: _bounceAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _bounceAnimation.value),
            child: child,
          );
        },
        child: avatarContent,
      );
    }

    // Aplicar animación de escala
    if (widget.animate) {
      avatarContent = ScaleTransition(
        scale: _scaleAnimation,
        child: avatarContent,
      );
    }

    // Aplicar efecto de expresión
    if (effect != null) {
      avatarContent = Stack(
        clipBehavior: Clip.none,
        children: [
          avatarContent,
          effect,
        ],
      );
    }

    return SizedBox(
      width: widget.size,
      height: _canvasHeight * _scaleFactor,
      child: avatarContent,
    );
  }

  double get _scaleFactor => widget.size / _canvasWidth;

  Widget _buildAvatarStack(String expression) {
    final background = AvatarCatalog.getPartById(widget.avatar.background);
    final face = AvatarCatalog.getPartById(widget.avatar.face);
    final body = AvatarCatalog.getPartById(widget.avatar.body);
    final eyes = AvatarCatalog.getPartById(_resolveEyesForExpression(expression));
    final mouth = AvatarCatalog.getPartById(_resolveMouthForExpression(expression));
    final hair = AvatarCatalog.getPartById(widget.avatar.hair);
    final accessory = AvatarCatalog.getPartById(widget.avatar.accessory);
    final top = AvatarCatalog.getPartById(widget.avatar.top);
    final hands = AvatarCatalog.getPartById(widget.avatar.hands);
    final bottom = AvatarCatalog.getPartById(widget.avatar.bottom);
    final shoes = AvatarCatalog.getPartById(widget.avatar.shoes);

    final double scale = _scaleFactor;
    final double canvasHeight = _canvasHeight * scale;
    final double canvasWidth = widget.size;
    final Color baseBackgroundColor = _resolveBackgroundColor(background);

    final children = <Widget>[
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                baseBackgroundColor,
                baseBackgroundColor.withOpacity(0.85),
              ],
            ),
            borderRadius: BorderRadius.circular(24 * scale),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 18 * scale,
                offset: Offset(0, 10 * scale),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24 * scale),
            child: background != null && background.assetPath.isNotEmpty
                ? AvatarAsset(
                    assetPath: background.assetPath,
                    fit: BoxFit.cover,
                  )
                : const SizedBox.shrink(),
          ),
        ),
      ),
    ];

    void addLayer(AvatarPartItem? part, String key) {
      if (part == null || part.assetPath.isEmpty) {
        return;
      }

      final isPng = part.assetPath.toLowerCase().endsWith('.png');

      if (isPng) {
        children.add(
          Positioned.fill(
            child: Center(
              child: _buildAsset(part),
            ),
          ),
        );
        return;
      }

      final layout = _layerLayouts[key];
      if (layout == null) {
        children.add(Center(child: _buildAsset(part)));
        return;
      }

      final double layerWidth = layout.widthFactor * canvasWidth;
      final double layerHeight = layout.heightFactor * canvasHeight;
      final double left =
          (canvasWidth - layerWidth) / 2 + layout.dxFactor * canvasWidth;
      final double top = layout.topFactor * canvasHeight;

      children.add(
        Positioned(
          top: top,
          left: left,
          width: layerWidth,
          height: layerHeight,
          child: _buildAsset(
            part,
            width: layerWidth,
            height: layerHeight,
          ),
        ),
      );
    }

    children.add(
      Positioned(
        bottom: 16 * scale,
        left: canvasWidth * 0.2,
        right: canvasWidth * 0.2,
        child: Container(
          height: 18 * scale,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.08),
            borderRadius: BorderRadius.circular(20 * scale),
          ),
        ),
      ),
    );

    addLayer(body, 'body');
    addLayer(bottom, 'bottom');
    addLayer(shoes, 'shoes');
    addLayer(top, 'top');
    addLayer(hands, 'hands');
    addLayer(face, 'face');
    addLayer(eyes, 'eyes');
    addLayer(mouth, 'mouth');
    addLayer(accessory, 'accessory');
    addLayer(hair, 'hair');

    return SizedBox(
      width: widget.size,
      height: canvasHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: children,
      ),
    );
  }

  Widget _buildAsset(
    AvatarPartItem? part, {
    double? width,
    double? height,
  }) {
    if (part == null || part.assetPath.isEmpty) {
      return const SizedBox.shrink();
    }

    final isPng = part.assetPath.toLowerCase().endsWith('.png');

    return AvatarAsset(
      assetPath: part.assetPath,
      width: isPng ? null : width,
      height: isPng ? null : height,
      fit: BoxFit.contain,
    );
  }

  Color _resolveBackgroundColor(AvatarPartItem? background) {
    switch (background?.id) {
      case 'bg_library':
        return Colors.amber.shade100;
      case 'bg_science_lab':
        return Colors.lightBlue.shade100;
      case 'bg_space':
        return Colors.deepPurple.shade200;
      case 'bg_classroom':
      default:
        return Colors.grey.shade100;
    }
  }
}

/// Widget de Avatar Simple (sin animaciones, para listas)
class SimpleAvatarWidget extends StatelessWidget {
  final AvatarModel avatar;
  final double size;

  const SimpleAvatarWidget({
    super.key,
    required this.avatar,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final background = AvatarCatalog.getPartById(avatar.background);
    final face = AvatarCatalog.getPartById(avatar.face);
    final eyes = AvatarCatalog.getPartById(avatar.eyes);
    final mouth = AvatarCatalog.getPartById(avatar.mouth);
    final hair = AvatarCatalog.getPartById(avatar.hair);
    final accessory = AvatarCatalog.getPartById(avatar.accessory);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _backgroundColor(background),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (background != null && background.assetPath.isNotEmpty)
              AvatarAsset(
                assetPath: background.assetPath,
                fit: BoxFit.cover,
              ),
            Align(
              alignment: Alignment.topCenter,
              child: _buildCompactAsset(hair, size * 0.7),
            ),
            Align(
              alignment: Alignment.center,
              child: _buildCompactAsset(face, size * 0.75),
            ),
            Align(
              alignment: Alignment.center,
              child: _buildCompactAsset(eyes, size * 0.45),
            ),
            Align(
              alignment: Alignment(0, 0.4),
              child: _buildCompactAsset(mouth, size * 0.35),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: _buildCompactAsset(accessory, size * 0.6),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompactAsset(AvatarPartItem? part, double size) {
    if (part == null || part.assetPath.isEmpty) {
      return const SizedBox.shrink();
    }

    final isPng = part.assetPath.toLowerCase().endsWith('.png');

    return AvatarAsset(
      assetPath: part.assetPath,
      width: isPng ? null : size,
      height: isPng ? null : size,
      fit: BoxFit.contain,
    );
  }

  Color _backgroundColor(AvatarPartItem? background) {
    switch (background?.id) {
      case 'bg_library':
        return Colors.amber.shade100;
      case 'bg_science_lab':
        return Colors.lightBlue.shade100;
      case 'bg_space':
        return Colors.deepPurple.shade200;
      case 'bg_classroom':
      default:
        return Colors.grey.shade100;
    }
  }
}
