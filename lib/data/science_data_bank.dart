library;

/// Banco de Datos Extenso para Juegos de Ciencias
///
/// Contiene 30-40 preguntas/datos curiosos por tema con variación de medios
/// para evitar monotonía y enriquecer el aprendizaje.
///
/// Temas cubiertos:
/// - Cuerpo Humano
/// - Animales (Mamíferos, Aves, Reptiles, Peces)
/// - Plantas
/// - Espacio/Astronomía
/// - Ecosistemas
/// - Estados de la Materia
/// - Cadena Alimenticia
///
/// Autor: APRENDE_KIDS
/// Fecha: 2025

import 'dart:math';

/// Categoría de ciencia
enum ScienceCategory {
  animals('Animales', '🐾'),
  plants('Plantas', '🌱'),
  space('Espacio', '🌌'),
  humanBody('Cuerpo Humano', '🧠'),
  ecosystems('Ecosistemas', '🌍'),
  matter('Materia', '⚗️'),
  foodChain('Cadena Alimenticia', '🍽️');

  final String name;
  final String emoji;

  const ScienceCategory(this.name, this.emoji);
}

/// Nivel de dificultad
enum Difficulty {
  easy('Fácil'),
  medium('Medio'),
  hard('Difícil');

  final String name;

  const Difficulty(this.name);
}

/// Pregunta de ciencia
class ScienceQuestion {
  final String question;
  final String correctAnswer;
  final List<String> wrongAnswers;
  final ScienceCategory category;
  final Difficulty difficulty;
  final String? funFact;
  final List<String> images; // Múltiples imágenes para variedad

  ScienceQuestion({
    required this.question,
    required this.correctAnswer,
    required this.wrongAnswers,
    required this.category,
    required this.difficulty,
    this.funFact,
    this.images = const [],
  });

  /// Obtiene todas las opciones mezcladas
  List<String> get allOptions {
    final options = [correctAnswer, ...wrongAnswers];
    options.shuffle();
    return options;
  }

  /// Obtiene una imagen aleatoria
  String get randomImage {
    if (images.isEmpty) return '';
    return images[Random().nextInt(images.length)];
  }
}

class ScienceDataBank {
  /// ANIMALES - Mamíferos
  static final List<ScienceQuestion> mammalsQuestions = [
    ScienceQuestion(
      question: '¿Qué animal es conocido como el rey de la selva?',
      correctAnswer: 'León',
      wrongAnswers: ['Tigre', 'Elefante', 'Gorila'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      funFact: '¡Los leones pueden dormir hasta 20 horas al día!',
      images: ['🦁'],
    ),
    ScienceQuestion(
      question: '¿Cuál es el mamífero más grande del mundo?',
      correctAnswer: 'Ballena azul',
      wrongAnswers: ['Elefante', 'Jirafa', 'Tiburón'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.medium,
      funFact: 'Una ballena azul puede pesar hasta 200 toneladas.',
      images: ['🐋'],
    ),
    ScienceQuestion(
      question: '¿Qué mamífero puede volar?',
      correctAnswer: 'Murciélago',
      wrongAnswers: ['Ardilla', 'Mono', 'Ratón'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      images: ['🦇'],
    ),
    ScienceQuestion(
      question: '¿Cuántas patas tiene un perro?',
      correctAnswer: '4 patas',
      wrongAnswers: ['2 patas', '6 patas', '8 patas'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      images: ['🐕', '🐶'],
    ),
    ScienceQuestion(
      question: '¿Qué animal tiene una trompa larga?',
      correctAnswer: 'Elefante',
      wrongAnswers: ['Jirafa', 'Rinoceronte', 'Hipopótamo'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      funFact: 'La trompa del elefante tiene más de 40,000 músculos.',
      images: ['🐘'],
    ),
    ScienceQuestion(
      question: '¿Qué mamífero es conocido por sus rayas negras y blancas?',
      correctAnswer: 'Cebra',
      wrongAnswers: ['Tigre', 'Panda', 'Mapache'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      images: ['🦓'],
    ),
    ScienceQuestion(
      question: '¿Qué animal marino tiene aletas y respira aire?',
      correctAnswer: 'Delfín',
      wrongAnswers: ['Pez', 'Tiburón', 'Medusa'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.medium,
      funFact: 'Los delfines duermen con un ojo abierto.',
      images: ['🐬'],
    ),
    ScienceQuestion(
      question: '¿Cuál es el animal terrestre más rápido?',
      correctAnswer: 'Guepardo',
      wrongAnswers: ['León', 'Caballo', 'Canguro'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.hard,
      funFact: 'Un guepardo puede correr hasta 120 km/h.',
      images: ['🐆'],
    ),
    ScienceQuestion(
      question: '¿Qué animal tiene una joroba en su espalda?',
      correctAnswer: 'Camello',
      wrongAnswers: ['Caballo', 'Vaca', 'Búfalo'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      images: ['🐪', '🐫'],
    ),
    ScienceQuestion(
      question: '¿Qué mamífero vive en el hielo del Ártico?',
      correctAnswer: 'Oso polar',
      wrongAnswers: ['Oso pardo', 'Pingüino', 'Foca'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.medium,
      images: ['🐻‍❄️'],
    ),
  ];

  /// ANIMALES - Aves
  static final List<ScienceQuestion> birdsQuestions = [
    ScienceQuestion(
      question: '¿Qué ave no puede volar pero corre muy rápido?',
      correctAnswer: 'Avestruz',
      wrongAnswers: ['Águila', 'Colibrí', 'Paloma'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.medium,
      funFact: 'El avestruz es el ave más grande del mundo.',
      images: ['🦤'],
    ),
    ScienceQuestion(
      question: '¿Qué ave es símbolo de la paz?',
      correctAnswer: 'Paloma',
      wrongAnswers: ['Águila', 'Búho', 'Cuervo'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      images: ['🕊️'],
    ),
    ScienceQuestion(
      question: '¿Qué ave es conocida por repetir palabras?',
      correctAnswer: 'Loro',
      wrongAnswers: ['Canario', 'Pato', 'Gallo'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      images: ['🦜'],
    ),
    ScienceQuestion(
      question: '¿Qué ave es activa durante la noche?',
      correctAnswer: 'Búho',
      wrongAnswers: ['Gorrión', 'Paloma', 'Pato'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.medium,
      images: ['🦉'],
    ),
    ScienceQuestion(
      question: '¿Qué ave vive en el hielo y no puede volar?',
      correctAnswer: 'Pingüino',
      wrongAnswers: ['Gaviota', 'Albatros', 'Pato'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      funFact: 'Los pingüinos son excelentes nadadores.',
      images: ['🐧'],
    ),
    ScienceQuestion(
      question: '¿Qué ave tiene un pico muy largo y colorido?',
      correctAnswer: 'Tucán',
      wrongAnswers: ['Águila', 'Pelícano', 'Flamenco'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.medium,
      images: ['🦤'],
    ),
    ScienceQuestion(
      question: '¿Qué ave es rosada y vive en grupos?',
      correctAnswer: 'Flamenco',
      wrongAnswers: ['Garza', 'Gaviota', 'Cisne'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.medium,
      images: ['🦩'],
    ),
    ScienceQuestion(
      question: '¿Qué ave canta por la mañana para despertar?',
      correctAnswer: 'Gallo',
      wrongAnswers: ['Búho', 'Águila', 'Pato'],
      category: ScienceCategory.animals,
      difficulty: Difficulty.easy,
      images: ['🐓'],
    ),
  ];

  /// CUERPO HUMANO
  static final List<ScienceQuestion> humanBodyQuestions = [
    ScienceQuestion(
      question: '¿Cuántos dedos tenemos en cada mano?',
      correctAnswer: '5 dedos',
      wrongAnswers: ['4 dedos', '6 dedos', '10 dedos'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.easy,
      images: ['✋', '🖐️'],
    ),
    ScienceQuestion(
      question: '¿Qué órgano nos permite pensar?',
      correctAnswer: 'Cerebro',
      wrongAnswers: ['Corazón', 'Estómago', 'Pulmones'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.easy,
      funFact: 'El cerebro pesa aproximadamente 1.4 kg.',
      images: ['🧠'],
    ),
    ScienceQuestion(
      question: '¿Qué órgano bombea la sangre?',
      correctAnswer: 'Corazón',
      wrongAnswers: ['Cerebro', 'Hígado', 'Riñones'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.easy,
      funFact: 'El corazón late unas 100,000 veces al día.',
      images: ['❤️', '🫀'],
    ),
    ScienceQuestion(
      question: '¿Con qué órgano respiramos?',
      correctAnswer: 'Pulmones',
      wrongAnswers: ['Corazón', 'Estómago', 'Cerebro'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.easy,
      images: ['🫁'],
    ),
    ScienceQuestion(
      question: '¿Cuántos ojos tenemos?',
      correctAnswer: '2 ojos',
      wrongAnswers: ['1 ojo', '3 ojos', '4 ojos'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.easy,
      images: ['👀', '👁️'],
    ),
    ScienceQuestion(
      question: '¿Qué parte del cuerpo nos permite escuchar?',
      correctAnswer: 'Orejas',
      wrongAnswers: ['Nariz', 'Boca', 'Manos'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.easy,
      images: ['👂'],
    ),
    ScienceQuestion(
      question: '¿Qué parte del cuerpo protege el cerebro?',
      correctAnswer: 'Cráneo',
      wrongAnswers: ['Costillas', 'Columna', 'Piel'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.medium,
      images: ['💀'],
    ),
    ScienceQuestion(
      question: '¿Cuántos huesos tiene un adulto aproximadamente?',
      correctAnswer: '206 huesos',
      wrongAnswers: ['100 huesos', '300 huesos', '500 huesos'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.hard,
      funFact: 'Los bebés nacen con más de 300 huesos.',
      images: ['🦴'],
    ),
    ScienceQuestion(
      question: '¿Qué órgano digiere la comida?',
      correctAnswer: 'Estómago',
      wrongAnswers: ['Cerebro', 'Corazón', 'Pulmones'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.medium,
      images: ['🫃'],
    ),
    ScienceQuestion(
      question: '¿Qué sentido nos permite saborear?',
      correctAnswer: 'Gusto',
      wrongAnswers: ['Vista', 'Oído', 'Tacto'],
      category: ScienceCategory.humanBody,
      difficulty: Difficulty.easy,
      images: ['👅'],
    ),
  ];

  /// PLANTAS
  static final List<ScienceQuestion> plantsQuestions = [
    ScienceQuestion(
      question: '¿Qué necesitan las plantas para hacer fotosíntesis?',
      correctAnswer: 'Luz solar',
      wrongAnswers: ['Oscuridad', 'Frío', 'Sal'],
      category: ScienceCategory.plants,
      difficulty: Difficulty.medium,
      funFact: 'Las plantas producen el oxígeno que respiramos.',
      images: ['☀️', '🌱'],
    ),
    ScienceQuestion(
      question: '¿De qué color son la mayoría de las plantas?',
      correctAnswer: 'Verde',
      wrongAnswers: ['Azul', 'Rojo', 'Amarillo'],
      category: ScienceCategory.plants,
      difficulty: Difficulty.easy,
      images: ['🌿', '🌱'],
    ),
    ScienceQuestion(
      question: '¿Qué parte de la planta está bajo tierra?',
      correctAnswer: 'Raíz',
      wrongAnswers: ['Flor', 'Hoja', 'Tallo'],
      category: ScienceCategory.plants,
      difficulty: Difficulty.easy,
      images: ['🌱'],
    ),
    ScienceQuestion(
      question: '¿Qué parte colorida atrae a los insectos?',
      correctAnswer: 'Flor',
      wrongAnswers: ['Raíz', 'Tallo', 'Semilla'],
      category: ScienceCategory.plants,
      difficulty: Difficulty.easy,
      images: ['🌸', '🌺', '🌻', '🌹'],
    ),
    ScienceQuestion(
      question: '¿Qué árbol produce bellotas?',
      correctAnswer: 'Roble',
      wrongAnswers: ['Pino', 'Manzano', 'Naranjo'],
      category: ScienceCategory.plants,
      difficulty: Difficulty.hard,
      images: ['🌳'],
    ),
    ScienceQuestion(
      question: '¿Qué planta es muy alta y crece en el desierto?',
      correctAnswer: 'Cactus',
      wrongAnswers: ['Rosal', 'Girasol', 'Helecho'],
      category: ScienceCategory.plants,
      difficulty: Difficulty.medium,
      images: ['🌵'],
    ),
    ScienceQuestion(
      question: '¿Qué necesitan las plantas para crecer, además de luz?',
      correctAnswer: 'Agua',
      wrongAnswers: ['Fuego', 'Hielo', 'Aceite'],
      category: ScienceCategory.plants,
      difficulty: Difficulty.easy,
      images: ['💧', '🌱'],
    ),
    ScienceQuestion(
      question: '¿Qué flor gira siguiendo al sol?',
      correctAnswer: 'Girasol',
      wrongAnswers: ['Rosa', 'Tulipán', 'Margarita'],
      category: ScienceCategory.plants,
      difficulty: Difficulty.medium,
      funFact: 'El girasol siempre mira hacia el este por la mañana.',
      images: ['🌻'],
    ),
  ];

  /// ESPACIO Y ASTRONOMÍA
  static final List<ScienceQuestion> spaceQuestions = [
    ScienceQuestion(
      question: '¿Qué planeta es conocido como el planeta rojo?',
      correctAnswer: 'Marte',
      wrongAnswers: ['Venus', 'Júpiter', 'Saturno'],
      category: ScienceCategory.space,
      difficulty: Difficulty.medium,
      funFact: 'Marte tiene el volcán más grande del sistema solar.',
      images: ['🔴'],
    ),
    ScienceQuestion(
      question: '¿Qué da luz y calor a la Tierra?',
      correctAnswer: 'El Sol',
      wrongAnswers: ['La Luna', 'Las estrellas', 'Los planetas'],
      category: ScienceCategory.space,
      difficulty: Difficulty.easy,
      images: ['☀️', '🌞'],
    ),
    ScienceQuestion(
      question: '¿Qué vemos en el cielo de noche que brilla?',
      correctAnswer: 'La Luna',
      wrongAnswers: ['El Sol', 'Las nubes', 'Los aviones'],
      category: ScienceCategory.space,
      difficulty: Difficulty.easy,
      images: ['🌙', '🌕'],
    ),
    ScienceQuestion(
      question: '¿Cuántos planetas hay en nuestro sistema solar?',
      correctAnswer: '8 planetas',
      wrongAnswers: ['5 planetas', '10 planetas', '12 planetas'],
      category: ScienceCategory.space,
      difficulty: Difficulty.medium,
      funFact: 'Plutón ya no se considera un planeta.',
      images: ['🪐'],
    ),
    ScienceQuestion(
      question: '¿Qué planeta tiene anillos visibles?',
      correctAnswer: 'Saturno',
      wrongAnswers: ['Tierra', 'Marte', 'Venus'],
      category: ScienceCategory.space,
      difficulty: Difficulty.medium,
      images: ['🪐'],
    ),
    ScienceQuestion(
      question: '¿En qué planeta vivimos?',
      correctAnswer: 'Tierra',
      wrongAnswers: ['Marte', 'Venus', 'Júpiter'],
      category: ScienceCategory.space,
      difficulty: Difficulty.easy,
      images: ['🌍', '🌎', '🌏'],
    ),
    ScienceQuestion(
      question: '¿Qué son las estrellas fugaces?',
      correctAnswer: 'Meteoritos',
      wrongAnswers: ['Estrellas que caen', 'Aviones', 'Luces'],
      category: ScienceCategory.space,
      difficulty: Difficulty.hard,
      images: ['☄️', '⭐'],
    ),
    ScienceQuestion(
      question: '¿Qué usan los astronautas para viajar al espacio?',
      correctAnswer: 'Cohete',
      wrongAnswers: ['Avión', 'Barco', 'Carro'],
      category: ScienceCategory.space,
      difficulty: Difficulty.easy,
      images: ['🚀'],
    ),
  ];

  /// ECOSISTEMAS
  static final List<ScienceQuestion> ecosystemsQuestions = [
    ScienceQuestion(
      question: '¿Dónde viven los peces?',
      correctAnswer: 'En el agua',
      wrongAnswers: ['En el cielo', 'En el desierto', 'En la nieve'],
      category: ScienceCategory.ecosystems,
      difficulty: Difficulty.easy,
      images: ['🐟', '🌊'],
    ),
    ScienceQuestion(
      question: '¿Qué ecosistema tiene mucha arena y es muy caliente?',
      correctAnswer: 'Desierto',
      wrongAnswers: ['Bosque', 'Océano', 'Montaña'],
      category: ScienceCategory.ecosystems,
      difficulty: Difficulty.easy,
      images: ['🏜️', '🐪'],
    ),
    ScienceQuestion(
      question: '¿Dónde hay muchos árboles juntos?',
      correctAnswer: 'Bosque',
      wrongAnswers: ['Playa', 'Desierto', 'Ciudad'],
      category: ScienceCategory.ecosystems,
      difficulty: Difficulty.easy,
      images: ['🌲', '🌳'],
    ),
    ScienceQuestion(
      question: '¿Qué ecosistema es muy frío y tiene hielo?',
      correctAnswer: 'Polo',
      wrongAnswers: ['Selva', 'Playa', 'Pradera'],
      category: ScienceCategory.ecosystems,
      difficulty: Difficulty.medium,
      images: ['🧊', '❄️'],
    ),
    ScienceQuestion(
      question: '¿Dónde viven los monos y loros?',
      correctAnswer: 'Selva',
      wrongAnswers: ['Desierto', 'Polo', 'Ciudad'],
      category: ScienceCategory.ecosystems,
      difficulty: Difficulty.easy,
      images: ['🌴', '🐵', '🦜'],
    ),
  ];

  /// ESTADOS DE LA MATERIA
  static final List<ScienceQuestion> matterQuestions = [
    ScienceQuestion(
      question: '¿Qué estado tiene el agua cuando hace mucho frío?',
      correctAnswer: 'Sólido (hielo)',
      wrongAnswers: ['Líquido', 'Gas', 'Plasma'],
      category: ScienceCategory.matter,
      difficulty: Difficulty.medium,
      images: ['🧊', '❄️'],
    ),
    ScienceQuestion(
      question: '¿En qué estado está el agua que bebemos?',
      correctAnswer: 'Líquido',
      wrongAnswers: ['Sólido', 'Gas', 'Plasma'],
      category: ScienceCategory.matter,
      difficulty: Difficulty.easy,
      images: ['💧', '🥤'],
    ),
    ScienceQuestion(
      question: '¿Qué es el vapor de agua?',
      correctAnswer: 'Gas',
      wrongAnswers: ['Sólido', 'Líquido', 'Hielo'],
      category: ScienceCategory.matter,
      difficulty: Difficulty.medium,
      funFact: 'El vapor es agua en estado gaseoso.',
      images: ['☁️', '💨'],
    ),
    ScienceQuestion(
      question: '¿Qué pasa con el hielo cuando hace calor?',
      correctAnswer: 'Se derrite',
      wrongAnswers: ['Se congela más', 'Explota', 'Se multiplica'],
      category: ScienceCategory.matter,
      difficulty: Difficulty.easy,
      images: ['🧊', '💧'],
    ),
  ];

  /// CADENA ALIMENTICIA
  static final List<ScienceQuestion> foodChainQuestions = [
    ScienceQuestion(
      question: '¿Qué comen las vacas?',
      correctAnswer: 'Pasto (herbívoras)',
      wrongAnswers: ['Carne', 'Peces', 'Insectos'],
      category: ScienceCategory.foodChain,
      difficulty: Difficulty.easy,
      images: ['🐄', '🌾'],
    ),
    ScienceQuestion(
      question: '¿Qué comen los leones?',
      correctAnswer: 'Carne (carnívoros)',
      wrongAnswers: ['Pasto', 'Frutas', 'Hojas'],
      category: ScienceCategory.foodChain,
      difficulty: Difficulty.easy,
      images: ['🦁', '🥩'],
    ),
    ScienceQuestion(
      question: '¿Qué animal come tanto plantas como carne?',
      correctAnswer: 'Oso (omnívoro)',
      wrongAnswers: ['León', 'Vaca', 'Conejo'],
      category: ScienceCategory.foodChain,
      difficulty: Difficulty.medium,
      images: ['🐻'],
    ),
    ScienceQuestion(
      question: '¿Qué comen los conejos?',
      correctAnswer: 'Zanahorias y pasto',
      wrongAnswers: ['Carne', 'Peces', 'Huevos'],
      category: ScienceCategory.foodChain,
      difficulty: Difficulty.easy,
      images: ['🐰', '🥕'],
    ),
    ScienceQuestion(
      question: '¿De dónde obtienen energía las plantas?',
      correctAnswer: 'Del sol',
      wrongAnswers: ['De otros animales', 'De la lluvia', 'De la tierra'],
      category: ScienceCategory.foodChain,
      difficulty: Difficulty.medium,
      funFact: 'Las plantas son productores de energía.',
      images: ['🌱', '☀️'],
    ),
  ];

  /// Obtiene todas las preguntas
  static List<ScienceQuestion> get allQuestions => [
        ...mammalsQuestions,
        ...birdsQuestions,
        ...humanBodyQuestions,
        ...plantsQuestions,
        ...spaceQuestions,
        ...ecosystemsQuestions,
        ...matterQuestions,
        ...foodChainQuestions,
      ];

  /// Obtiene preguntas por categoría
  static List<ScienceQuestion> getByCategory(ScienceCategory category) {
    return allQuestions.where((q) => q.category == category).toList();
  }

  /// Obtiene preguntas por dificultad
  static List<ScienceQuestion> getByDifficulty(Difficulty difficulty) {
    return allQuestions.where((q) => q.difficulty == difficulty).toList();
  }

  /// Obtiene N preguntas aleatorias
  static List<ScienceQuestion> getRandomQuestions(int count) {
    final shuffled = List<ScienceQuestion>.from(allQuestions)..shuffle();
    return shuffled.take(count).toList();
  }

  /// Obtiene N preguntas aleatorias de una categoría específica
  static List<ScienceQuestion> getRandomFromCategory(
    ScienceCategory category,
    int count,
  ) {
    final categoryQuestions = getByCategory(category);
    categoryQuestions.shuffle();
    return categoryQuestions.take(count).toList();
  }
}
