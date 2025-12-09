/// Modelo de datos para el juego de clasificación de emojis
class EmojiSortingModel {
  final EmojiSortingLevel level;
  final List<EmojiCategory> categories;
  final List<String> shuffledEmojis;

  EmojiSortingModel({
    required this.level,
    required this.categories,
    required this.shuffledEmojis,
  });
}

/// Niveles de dificultad
enum EmojiSortingLevel {
  basico,    // 2 categorías, 6 emojis totales
  intermedio, // 3 categorías, 9 emojis totales
  avanzado,   // 4 categorías, 12 emojis totales
}

/// Categoría de emojis
class EmojiCategory {
  final String name;
  final String emoji;
  final List<String> correctEmojis;
  final List<String> placedEmojis;

  EmojiCategory({
    required this.name,
    required this.emoji,
    required this.correctEmojis,
    List<String>? placedEmojis,
  }) : placedEmojis = placedEmojis ?? [];

  /// Crea una copia con nuevos valores
  EmojiCategory copyWith({
    String? name,
    String? emoji,
    List<String>? correctEmojis,
    List<String>? placedEmojis,
  }) {
    return EmojiCategory(
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      correctEmojis: correctEmojis ?? this.correctEmojis,
      placedEmojis: placedEmojis ?? this.placedEmojis,
    );
  }

  /// Verifica si un emoji pertenece a esta categoría
  bool isCorrectEmoji(String emoji) {
    return correctEmojis.contains(emoji);
  }

  /// Verifica si la categoría está completa
  bool isComplete() {
    return placedEmojis.length == correctEmojis.length;
  }

  /// Obtiene el progreso (0.0 a 1.0)
  double get progress {
    if (correctEmojis.isEmpty) return 0.0;
    return placedEmojis.length / correctEmojis.length;
  }
}

/// Configuración de cada nivel
class LevelConfig {
  final int categoryCount;
  final int emojisPerCategory;
  final String description;
  final int timeLimit; // Tiempo en segundos

  const LevelConfig({
    required this.categoryCount,
    required this.emojisPerCategory,
    required this.description,
    required this.timeLimit,
  });

  static const Map<EmojiSortingLevel, LevelConfig> configs = {
    EmojiSortingLevel.basico: LevelConfig(
      categoryCount: 2,
      emojisPerCategory: 3,
      description: 'Fácil - 2 categorías',
      timeLimit: 90, // 1.5 minutos
    ),
    EmojiSortingLevel.intermedio: LevelConfig(
      categoryCount: 3,
      emojisPerCategory: 3,
      description: 'Medio - 3 categorías',
      timeLimit: 150, // 2.5 minutos
    ),
    EmojiSortingLevel.avanzado: LevelConfig(
      categoryCount: 4,
      emojisPerCategory: 3,
      description: 'Difícil - 4 categorías',
      timeLimit: 180, // 3 minutos
    ),
  };

  /// Calcula las monedas ganadas basado en el tiempo restante
  static int calculateCoins(int timeRemaining, int timeLimit) {
    if (timeRemaining <= 0) return 10; // Mínimo por completar

    // Fórmula: más tiempo restante = más monedas
    // Máximo 50, mínimo 10
    final percentage = timeRemaining / timeLimit;
    final coins = (10 + (40 * percentage)).round();
    return coins.clamp(10, 50);
  }
}
