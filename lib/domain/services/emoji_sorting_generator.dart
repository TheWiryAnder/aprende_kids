import 'dart:math';
import '../models/emoji_sorting_model.dart';

/// Generador de juegos de clasificación de emojis
class EmojiSortingGenerator {
  final Random _random = Random();

  // Base de datos de categorías con sus emojis
  static const Map<String, Map<String, dynamic>> _categoryDatabase = {
    'Frutas': {
      'emoji': '🍎',
      'items': ['🍌', '🍇', '🍉', '🍊', '🍓', '🍒', '🥝', '🍑'],
    },
    'Vehículos': {
      'emoji': '🚗',
      'items': ['✈️', '🛵', '🚁', '🚂', '🚢', '🚲', '🏍️', '🚜'],
    },
    'Deportes': {
      'emoji': '⚽',
      'items': ['🏀', '🎾', '🏐', '🏈', '⚾', '🏓', '🏸', '🥊'],
    },
    'Animales': {
      'emoji': '🦁',
      'items': ['🐶', '🐱', '🐭', '🐹', '🐰', '🦊', '🐻', '🐼'],
    },
    'Comida': {
      'emoji': '🍕',
      'items': ['🍔', '🌭', '🥪', '🌮', '🍝', '🍜', '🍲', '🥗'],
    },
    'Naturaleza': {
      'emoji': '🌳',
      'items': ['🌺', '🌻', '🌷', '🌹', '🌸', '🌼', '🌵', '🍃'],
    },
    'Clima': {
      'emoji': '☀️',
      'items': ['🌧️', '⛈️', '🌩️', '❄️', '☁️', '🌈', '⭐', '🌙'],
    },
    'Instrumentos': {
      'emoji': '🎸',
      'items': ['🎹', '🥁', '🎺', '🎻', '🪕', '🎷', '🪘', '🎤'],
    },
  };

  /// Genera un juego según el nivel especificado
  EmojiSortingModel generate(EmojiSortingLevel level) {
    final config = LevelConfig.configs[level]!;

    // Seleccionar categorías aleatorias
    final availableCategories = _categoryDatabase.keys.toList()..shuffle(_random);
    final selectedCategoryNames = availableCategories.take(config.categoryCount).toList();

    // Crear las categorías con sus emojis
    final categories = <EmojiCategory>[];
    final allEmojis = <String>[];

    for (final categoryName in selectedCategoryNames) {
      final categoryData = _categoryDatabase[categoryName]!;
      final availableEmojis = List<String>.from(categoryData['items'] as List);
      availableEmojis.shuffle(_random);

      // Tomar solo los emojis necesarios
      final selectedEmojis = availableEmojis.take(config.emojisPerCategory).toList();

      categories.add(EmojiCategory(
        name: categoryName,
        emoji: categoryData['emoji'] as String,
        correctEmojis: selectedEmojis,
      ));

      allEmojis.addAll(selectedEmojis);
    }

    // Mezclar todos los emojis
    allEmojis.shuffle(_random);

    return EmojiSortingModel(
      level: level,
      categories: categories,
      shuffledEmojis: allEmojis,
    );
  }
}
