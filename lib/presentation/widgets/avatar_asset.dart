import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Widget auxiliar que carga assets del catálogo de avatar soportando
/// tanto SVG como PNG sin duplicar lógica en la UI.
class AvatarAsset extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;

  const AvatarAsset({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.placeholder,
  });

  bool get _isSvg => assetPath.toLowerCase().endsWith('.svg');

  @override
  Widget build(BuildContext context) {
    if (assetPath.isEmpty) {
      return placeholder ?? const SizedBox.shrink();
    }

    if (_isSvg) {
      return SvgPicture.asset(
        assetPath,
        width: width,
        height: height,
        fit: fit,
        placeholderBuilder: placeholder != null ? (_) => placeholder! : null,
      );
    }

    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // SILENCIAR ERROR: retornar contenedor vacío transparente
        // Esto evita que aparezca el texto amarillo de error
        return SizedBox(
          width: width,
          height: height,
          child: placeholder ?? const SizedBox.shrink(),
        );
      },
      // Deshabilitar el mensaje de error en consola
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (frame == null) {
          return SizedBox(
            width: width,
            height: height,
            child: placeholder ?? const SizedBox.shrink(),
          );
        }
        return child;
      },
    );
  }
}
