library;

/// Banco de Datos para Juegos de Creatividad
///
/// Generador aleatorio de prompts creativos para evitar repetición.
/// Usa estructura [Acción] + [Objeto] + [Modificador]
///
/// Ejemplos generados:
/// - "Dibuja un [Gato] [Azul]"
/// - "Pinta un [Árbol] [Gigante]"
/// - "Crea un [Robot] [Volador]"
///
/// Para juegos musicales: Secuencias de notas aleatorias (Simón Dice)
/// con complejidad progresiva.
///
/// Autor: APRENDE_KIDS
/// Fecha: 2025

import 'dart:math';

/// Acción creativa
enum CreativeAction {
  draw('Dibuja', '✏️'),
  paint('Pinta', '🎨'),
  create('Crea', '✨'),
  design('Diseña', '🖌️'),
  imagine('Imagina', '💭'),
  build('Construye', '🏗️');

  final String name;
  final String emoji;

  const CreativeAction(this.name, this.emoji);

  static CreativeAction random() {
    final values = CreativeAction.values;
    return values[Random().nextInt(values.length)];
  }
}

/// Objeto para dibujar/crear
class CreativeObject {
  final String name;
  final String emoji;
  final String category;

  const CreativeObject({
    required this.name,
    required this.emoji,
    required this.category,
  });
}

/// Modificador/adjetivo
class CreativeModifier {
  final String name;
  final String emoji;
  final String type; // color, size, mood, style

  const CreativeModifier({
    required this.name,
    required this.emoji,
    required this.type,
  });
}

/// Nota musical
enum MusicalNote {
  do_('DO', '🎵', 1),
  re('RE', '🎶', 2),
  mi('MI', '🎵', 3),
  fa('FA', '🎶', 4),
  sol('SOL', '🎵', 5),
  la('LA', '🎶', 6),
  si('SI', '🎵', 7);

  final String name;
  final String emoji;
  final int noteIndex;

  const MusicalNote(this.name, this.emoji, this.noteIndex);

  static MusicalNote random() {
    final values = MusicalNote.values;
    return values[Random().nextInt(values.length)];
  }
}

/// Prompt creativo generado
class CreativePrompt {
  final CreativeAction action;
  final CreativeObject object;
  final CreativeModifier modifier;
  final String fullPrompt;

  CreativePrompt({
    required this.action,
    required this.object,
    required this.modifier,
  }) : fullPrompt = '${action.name} un ${object.name} ${modifier.name}';

  @override
  String toString() => fullPrompt;
}

class CreativityDataBank {
  static final Random _random = Random();

  /// OBJETOS CREATIVOS (80+ objetos variados)
  static const List<CreativeObject> objects = [
    // Animales
    CreativeObject(name: 'Gato', emoji: '🐱', category: 'animales'),
    CreativeObject(name: 'Perro', emoji: '🐕', category: 'animales'),
    CreativeObject(name: 'Pájaro', emoji: '🐦', category: 'animales'),
    CreativeObject(name: 'Mariposa', emoji: '🦋', category: 'animales'),
    CreativeObject(name: 'Pez', emoji: '🐟', category: 'animales'),
    CreativeObject(name: 'Elefante', emoji: '🐘', category: 'animales'),
    CreativeObject(name: 'León', emoji: '🦁', category: 'animales'),
    CreativeObject(name: 'Conejo', emoji: '🐰', category: 'animales'),
    CreativeObject(name: 'Tortuga', emoji: '🐢', category: 'animales'),
    CreativeObject(name: 'Oso', emoji: '🐻', category: 'animales'),
    CreativeObject(name: 'Dragón', emoji: '🐉', category: 'animales'),
    CreativeObject(name: 'Unicornio', emoji: '🦄', category: 'animales'),
    CreativeObject(name: 'Dinosaurio', emoji: '🦕', category: 'animales'),

    // Naturaleza
    CreativeObject(name: 'Árbol', emoji: '🌳', category: 'naturaleza'),
    CreativeObject(name: 'Flor', emoji: '🌸', category: 'naturaleza'),
    CreativeObject(name: 'Sol', emoji: '☀️', category: 'naturaleza'),
    CreativeObject(name: 'Luna', emoji: '🌙', category: 'naturaleza'),
    CreativeObject(name: 'Estrella', emoji: '⭐', category: 'naturaleza'),
    CreativeObject(name: 'Nube', emoji: '☁️', category: 'naturaleza'),
    CreativeObject(name: 'Arcoíris', emoji: '🌈', category: 'naturaleza'),
    CreativeObject(name: 'Montaña', emoji: '⛰️', category: 'naturaleza'),
    CreativeObject(name: 'Volcán', emoji: '🌋', category: 'naturaleza'),
    CreativeObject(name: 'Cascada', emoji: '💦', category: 'naturaleza'),

    // Transportes
    CreativeObject(name: 'Carro', emoji: '🚗', category: 'transportes'),
    CreativeObject(name: 'Avión', emoji: '✈️', category: 'transportes'),
    CreativeObject(name: 'Barco', emoji: '⛵', category: 'transportes'),
    CreativeObject(name: 'Cohete', emoji: '🚀', category: 'transportes'),
    CreativeObject(name: 'Tren', emoji: '🚂', category: 'transportes'),
    CreativeObject(name: 'Bicicleta', emoji: '🚲', category: 'transportes'),
    CreativeObject(name: 'Helicóptero', emoji: '🚁', category: 'transportes'),
    CreativeObject(name: 'Globo', emoji: '🎈', category: 'transportes'),

    // Edificios y Estructuras
    CreativeObject(name: 'Casa', emoji: '🏠', category: 'edificios'),
    CreativeObject(name: 'Castillo', emoji: '🏰', category: 'edificios'),
    CreativeObject(name: 'Pirámide', emoji: '🔺', category: 'edificios'),
    CreativeObject(name: 'Torre', emoji: '🗼', category: 'edificios'),
    CreativeObject(name: 'Puente', emoji: '🌉', category: 'edificios'),
    CreativeObject(name: 'Faro', emoji: '🗽', category: 'edificios'),

    // Objetos Fantásticos
    CreativeObject(name: 'Robot', emoji: '🤖', category: 'fantasia'),
    CreativeObject(name: 'Monstruo', emoji: '👾', category: 'fantasia'),
    CreativeObject(name: 'Extraterrestre', emoji: '👽', category: 'fantasia'),
    CreativeObject(name: 'Hada', emoji: '🧚', category: 'fantasia'),
    CreativeObject(name: 'Fantasma', emoji: '👻', category: 'fantasia'),
    CreativeObject(name: 'Bruja', emoji: '🧙', category: 'fantasia'),
    CreativeObject(name: 'Mago', emoji: '🧙‍♂️', category: 'fantasia'),
    CreativeObject(name: 'Superhéroe', emoji: '🦸', category: 'fantasia'),

    // Comida
    CreativeObject(name: 'Pastel', emoji: '🎂', category: 'comida'),
    CreativeObject(name: 'Helado', emoji: '🍦', category: 'comida'),
    CreativeObject(name: 'Pizza', emoji: '🍕', category: 'comida'),
    CreativeObject(name: 'Hamburguesa', emoji: '🍔', category: 'comida'),
    CreativeObject(name: 'Donut', emoji: '🍩', category: 'comida'),
    CreativeObject(name: 'Galleta', emoji: '🍪', category: 'comida'),

    // Objetos Cotidianos
    CreativeObject(name: 'Reloj', emoji: '⏰', category: 'objetos'),
    CreativeObject(name: 'Lámpara', emoji: '💡', category: 'objetos'),
    CreativeObject(name: 'Libro', emoji: '📚', category: 'objetos'),
    CreativeObject(name: 'Lápiz', emoji: '✏️', category: 'objetos'),
    CreativeObject(name: 'Paraguas', emoji: '☂️', category: 'objetos'),
    CreativeObject(name: 'Sombrero', emoji: '🎩', category: 'objetos'),
    CreativeObject(name: 'Corona', emoji: '👑', category: 'objetos'),
    CreativeObject(name: 'Espada', emoji: '⚔️', category: 'objetos'),

    // Instrumentos Musicales
    CreativeObject(name: 'Guitarra', emoji: '🎸', category: 'musica'),
    CreativeObject(name: 'Piano', emoji: '🎹', category: 'musica'),
    CreativeObject(name: 'Tambor', emoji: '🥁', category: 'musica'),
    CreativeObject(name: 'Trompeta', emoji: '🎺', category: 'musica'),
  ];

  /// MODIFICADORES (70+ adjetivos variados)
  static const List<CreativeModifier> modifiers = [
    // Colores
    CreativeModifier(name: 'Azul', emoji: '💙', type: 'color'),
    CreativeModifier(name: 'Rojo', emoji: '❤️', type: 'color'),
    CreativeModifier(name: 'Verde', emoji: '💚', type: 'color'),
    CreativeModifier(name: 'Amarillo', emoji: '💛', type: 'color'),
    CreativeModifier(name: 'Morado', emoji: '💜', type: 'color'),
    CreativeModifier(name: 'Naranja', emoji: '🧡', type: 'color'),
    CreativeModifier(name: 'Rosa', emoji: '🩷', type: 'color'),
    CreativeModifier(name: 'Arcoíris', emoji: '🌈', type: 'color'),
    CreativeModifier(name: 'Dorado', emoji: '⭐', type: 'color'),
    CreativeModifier(name: 'Plateado', emoji: '✨', type: 'color'),

    // Tamaños
    CreativeModifier(name: 'Gigante', emoji: '🏔️', type: 'size'),
    CreativeModifier(name: 'Pequeño', emoji: '🔬', type: 'size'),
    CreativeModifier(name: 'Enorme', emoji: '📏', type: 'size'),
    CreativeModifier(name: 'Diminuto', emoji: '🐜', type: 'size'),
    CreativeModifier(name: 'Alto', emoji: '📐', type: 'size'),
    CreativeModifier(name: 'Bajo', emoji: '➖', type: 'size'),

    // Estados de ánimo/Personalidad
    CreativeModifier(name: 'Feliz', emoji: '😊', type: 'mood'),
    CreativeModifier(name: 'Triste', emoji: '😢', type: 'mood'),
    CreativeModifier(name: 'Enojado', emoji: '😠', type: 'mood'),
    CreativeModifier(name: 'Sorprendido', emoji: '😲', type: 'mood'),
    CreativeModifier(name: 'Dormido', emoji: '😴', type: 'mood'),
    CreativeModifier(name: 'Divertido', emoji: '🤣', type: 'mood'),
    CreativeModifier(name: 'Tímido', emoji: '🙈', type: 'mood'),
    CreativeModifier(name: 'Valiente', emoji: '💪', type: 'mood'),

    // Estilos/Características
    CreativeModifier(name: 'Mágico', emoji: '✨', type: 'style'),
    CreativeModifier(name: 'Brillante', emoji: '💫', type: 'style'),
    CreativeModifier(name: 'Volador', emoji: '🦅', type: 'style'),
    CreativeModifier(name: 'Invisible', emoji: '👻', type: 'style'),
    CreativeModifier(name: 'Transparente', emoji: '💎', type: 'style'),
    CreativeModifier(name: 'Peludo', emoji: '🦁', type: 'style'),
    CreativeModifier(name: 'Suave', emoji: '🧸', type: 'style'),
    CreativeModifier(name: 'Áspero', emoji: '🪨', type: 'style'),
    CreativeModifier(name: 'Congelado', emoji: '❄️', type: 'style'),
    CreativeModifier(name: 'Ardiente', emoji: '🔥', type: 'style'),
    CreativeModifier(name: 'Eléctrico', emoji: '⚡', type: 'style'),
    CreativeModifier(name: 'Espacial', emoji: '🌌', type: 'style'),
    CreativeModifier(name: 'Submarino', emoji: '🌊', type: 'style'),
    CreativeModifier(name: 'Prehistórico', emoji: '🦕', type: 'style'),
    CreativeModifier(name: 'Futurista', emoji: '🚀', type: 'style'),
    CreativeModifier(name: 'Medieval', emoji: '⚔️', type: 'style'),
    CreativeModifier(name: 'Tropical', emoji: '🌴', type: 'style'),
    CreativeModifier(name: 'Nevado', emoji: '⛄', type: 'style'),
    CreativeModifier(name: 'Salvaje', emoji: '🦁', type: 'style'),
    CreativeModifier(name: 'Domesticado', emoji: '🏠', type: 'style'),

    // Texturas
    CreativeModifier(name: 'Rayado', emoji: '🦓', type: 'pattern'),
    CreativeModifier(name: 'Punteado', emoji: '🔴', type: 'pattern'),
    CreativeModifier(name: 'Cuadriculado', emoji: '⬛', type: 'pattern'),
    CreativeModifier(name: 'Espiral', emoji: '🌀', type: 'pattern'),
    CreativeModifier(name: 'Estrellado', emoji: '⭐', type: 'pattern'),

    // Condiciones
    CreativeModifier(name: 'Roto', emoji: '💔', type: 'condition'),
    CreativeModifier(name: 'Nuevo', emoji: '✨', type: 'condition'),
    CreativeModifier(name: 'Viejo', emoji: '📜', type: 'condition'),
    CreativeModifier(name: 'Limpio', emoji: '🧽', type: 'condition'),
    CreativeModifier(name: 'Sucio', emoji: '🥴', type: 'condition'),
    CreativeModifier(name: 'Brilloso', emoji: '💎', type: 'condition'),
    CreativeModifier(name: 'Opaco', emoji: '🌫️', type: 'condition'),
  ];

  /// Genera un prompt creativo aleatorio
  static CreativePrompt generatePrompt({String? category, String? modifierType}) {
    // Filtrar objetos por categoría si se especifica
    final availableObjects = category != null
        ? objects.where((obj) => obj.category == category).toList()
        : objects;

    // Filtrar modificadores por tipo si se especifica
    final availableModifiers = modifierType != null
        ? modifiers.where((mod) => mod.type == modifierType).toList()
        : modifiers;

    final action = CreativeAction.random();
    final object = availableObjects[_random.nextInt(availableObjects.length)];
    final modifier = availableModifiers[_random.nextInt(availableModifiers.length)];

    return CreativePrompt(
      action: action,
      object: object,
      modifier: modifier,
    );
  }

  /// Genera múltiples prompts únicos
  static List<CreativePrompt> generateMultiplePrompts(int count) {
    final prompts = <CreativePrompt>[];
    final usedCombinations = <String>{};

    int attempts = 0;
    final maxAttempts = count * 10;

    while (prompts.length < count && attempts < maxAttempts) {
      attempts++;
      final prompt = generatePrompt();
      final signature = '${prompt.object.name}_${prompt.modifier.name}';

      if (!usedCombinations.contains(signature)) {
        usedCombinations.add(signature);
        prompts.add(prompt);
      }
    }

    return prompts;
  }

  /// Genera una secuencia de notas musicales (Simón Dice)
  /// La complejidad aumenta con el nivel
  static List<MusicalNote> generateMelody({required int level}) {
    int length;

    switch (level) {
      case 1:
        length = 3; // 3 notas
        break;
      case 2:
        length = 5; // 5 notas
        break;
      case 3:
        length = 7; // 7 notas
        break;
      default:
        length = 4;
    }

    final melody = <MusicalNote>[];
    for (int i = 0; i < length; i++) {
      melody.add(MusicalNote.random());
    }

    return melody;
  }

  /// Genera una secuencia de notas progresiva
  /// Cada ronda agrega una nota más
  static List<MusicalNote> generateProgressiveMelody(int round) {
    final melody = <MusicalNote>[];
    final length = 2 + round; // Empieza con 3 notas (2+1), crece cada ronda

    for (int i = 0; i < length; i++) {
      melody.add(MusicalNote.random());
    }

    return melody;
  }

  /// Genera un desafío de mezcla de colores
  static Map<String, dynamic> generateColorMixChallenge() {
    final primaryColors = [
      {'name': 'Rojo', 'emoji': '🔴', 'code': 'red'},
      {'name': 'Azul', 'emoji': '🔵', 'code': 'blue'},
      {'name': 'Amarillo', 'emoji': '🟡', 'code': 'yellow'},
    ];

    final mixResults = {
      'red_blue': {'name': 'Morado', 'emoji': '🟣'},
      'red_yellow': {'name': 'Naranja', 'emoji': '🟠'},
      'blue_yellow': {'name': 'Verde', 'emoji': '🟢'},
    };

    // Seleccionar dos colores primarios al azar
    final shuffled = List<Map<String, dynamic>>.from(primaryColors)..shuffle();
    final color1 = shuffled[0];
    final color2 = shuffled[1];

    // Ordenar alfabéticamente para la clave
    final code1 = color1['code'];
    final code2 = color2['code'];
    final key = [code1, code2]..sort();
    final resultKey = key.join('_');

    final result = mixResults[resultKey];

    return {
      'color1': color1,
      'color2': color2,
      'correctResult': result,
      'question': '¿Qué color se forma al mezclar ${color1['name']} y ${color2['name']}?',
    };
  }

  /// Genera un desafío de diseño de monstruo
  static Map<String, dynamic> generateMonsterDesignChallenge() {
    final eyes = ['1 ojo', '2 ojos', '3 ojos', '4 ojos', 'Muchos ojos'];
    final colors = ['Verde', 'Azul', 'Morado', 'Naranja', 'Rosa', 'Multicolor'];
    final features = [
      'con cuernos',
      'con alas',
      'con cola',
      'con antenas',
      'con tentáculos',
      'con garras',
      'con pelaje',
      'con escamas',
    ];
    final moods = ['feliz', 'enojado', 'asustado', 'tímido', 'divertido'];

    return {
      'eyes': eyes[_random.nextInt(eyes.length)],
      'color': colors[_random.nextInt(colors.length)],
      'feature': features[_random.nextInt(features.length)],
      'mood': moods[_random.nextInt(moods.length)],
      'prompt':
          'Diseña un monstruo ${moods[_random.nextInt(moods.length)]} de color ${colors[_random.nextInt(colors.length)]} con ${eyes[_random.nextInt(eyes.length)]} ${features[_random.nextInt(features.length)]}',
    };
  }

  /// Obtiene objetos por categoría
  static List<CreativeObject> getObjectsByCategory(String category) {
    return objects.where((obj) => obj.category == category).toList();
  }

  /// Obtiene modificadores por tipo
  static List<CreativeModifier> getModifiersByType(String type) {
    return modifiers.where((mod) => mod.type == type).toList();
  }

  /// Categorías disponibles
  static List<String> get categories =>
      objects.map((obj) => obj.category).toSet().toList();

  /// Tipos de modificadores disponibles
  static List<String> get modifierTypes =>
      modifiers.map((mod) => mod.type).toSet().toList();
}
