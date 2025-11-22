/// Estados emocionales del avatar para mostrar diferentes expresiones
enum AvatarMood {
  /// Estado neutral - por defecto
  neutral,

  /// Estado feliz - cuando el usuario acierta o completa algo
  happy,

  /// Estado de celebración - cuando completa un nivel o logro importante
  celebration,

  /// Estado pensando - durante el juego
  thinking,

  /// Estado de ánimo - cuando falla pero se le motiva
  encouraging,

  /// Estado de saludo - al iniciar sesión
  greeting,

  /// Estado de victoria - al ganar
  victory,
}

/// Extensión para obtener descripciones de los estados
extension AvatarMoodExtension on AvatarMood {
  String get description {
    switch (this) {
      case AvatarMood.neutral:
        return 'Neutral';
      case AvatarMood.happy:
        return 'Feliz';
      case AvatarMood.celebration:
        return 'Celebrando';
      case AvatarMood.thinking:
        return 'Pensando';
      case AvatarMood.encouraging:
        return 'Animando';
      case AvatarMood.greeting:
        return 'Saludando';
      case AvatarMood.victory:
        return 'Victoria';
    }
  }
}
