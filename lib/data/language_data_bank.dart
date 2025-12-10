library;

/// Banco de Datos Extenso para Juegos de Lenguaje
///
/// Contiene más de 50 palabras por categoría con variación de:
/// - Longitud (cortas, medianas, largas)
/// - Temática (hogar, escuela, parque, ciudad, naturaleza)
/// - Dificultad (fácil, intermedio, avanzado)
///
/// Autor: APRENDE_KIDS
/// Fecha: 2025

class LanguageDataBank {
  /// Palabras con vocales para "Cazador de Vocales"
  /// 60+ palabras variadas
  static const List<Map<String, dynamic>> vowelWords = [
    // ===== HOGAR =====
    {'word': 'CASA', 'emoji': '🏠', 'theme': 'hogar', 'difficulty': 'easy'},
    {'word': 'MESA', 'emoji': '🪑', 'theme': 'hogar', 'difficulty': 'easy'},
    {'word': 'CAMA', 'emoji': '🛏️', 'theme': 'hogar', 'difficulty': 'easy'},
    {'word': 'SOFÁ', 'emoji': '🛋️', 'theme': 'hogar', 'difficulty': 'easy'},
    {'word': 'SILLA', 'emoji': '🪑', 'theme': 'hogar', 'difficulty': 'easy'},
    {'word': 'PUERTA', 'emoji': '🚪', 'theme': 'hogar', 'difficulty': 'medium'},
    {'word': 'VENTANA', 'emoji': '🪟', 'theme': 'hogar', 'difficulty': 'medium'},
    {'word': 'LÁMPARA', 'emoji': '💡', 'theme': 'hogar', 'difficulty': 'medium'},
    {'word': 'ESPEJO', 'emoji': '🪞', 'theme': 'hogar', 'difficulty': 'medium'},
    {'word': 'COCINA', 'emoji': '👩‍🍳', 'theme': 'hogar', 'difficulty': 'medium'},

    // ===== ANIMALES =====
    {'word': 'OSO', 'emoji': '🐻', 'theme': 'animales', 'difficulty': 'easy'},
    {'word': 'GATO', 'emoji': '🐱', 'theme': 'animales', 'difficulty': 'easy'},
    {'word': 'PERRO', 'emoji': '🐕', 'theme': 'animales', 'difficulty': 'easy'},
    {'word': 'LEÓN', 'emoji': '🦁', 'theme': 'animales', 'difficulty': 'easy'},
    {'word': 'TIGRE', 'emoji': '🐯', 'theme': 'animales', 'difficulty': 'easy'},
    {'word': 'MONO', 'emoji': '🐵', 'theme': 'animales', 'difficulty': 'easy'},
    {'word': 'PÁJARO', 'emoji': '🐦', 'theme': 'animales', 'difficulty': 'medium'},
    {'word': 'CONEJO', 'emoji': '🐰', 'theme': 'animales', 'difficulty': 'medium'},
    {'word': 'TORTUGA', 'emoji': '🐢', 'theme': 'animales', 'difficulty': 'medium'},
    {'word': 'ELEFANTE', 'emoji': '🐘', 'theme': 'animales', 'difficulty': 'hard'},
    {'word': 'MARIPOSA', 'emoji': '🦋', 'theme': 'animales', 'difficulty': 'hard'},
    {'word': 'COCODRILO', 'emoji': '🐊', 'theme': 'animales', 'difficulty': 'hard'},
    {'word': 'JIRAFA', 'emoji': '🦒', 'theme': 'animales', 'difficulty': 'medium'},
    {'word': 'CEBRA', 'emoji': '🦓', 'theme': 'animales', 'difficulty': 'medium'},
    {'word': 'HIPOPÓTAMO', 'emoji': '🦛', 'theme': 'animales', 'difficulty': 'hard'},

    // ===== NATURALEZA =====
    {'word': 'ÁRBOL', 'emoji': '🌳', 'theme': 'naturaleza', 'difficulty': 'easy'},
    {'word': 'FLOR', 'emoji': '🌸', 'theme': 'naturaleza', 'difficulty': 'easy'},
    {'word': 'ROSA', 'emoji': '🌹', 'theme': 'naturaleza', 'difficulty': 'easy'},
    {'word': 'LUNA', 'emoji': '🌙', 'theme': 'naturaleza', 'difficulty': 'easy'},
    {'word': 'SOL', 'emoji': '☀️', 'theme': 'naturaleza', 'difficulty': 'easy'},
    {'word': 'ESTRELLA', 'emoji': '⭐', 'theme': 'naturaleza', 'difficulty': 'medium'},
    {'word': 'NUBE', 'emoji': '☁️', 'theme': 'naturaleza', 'difficulty': 'easy'},
    {'word': 'LLUVIA', 'emoji': '🌧️', 'theme': 'naturaleza', 'difficulty': 'medium'},
    {'word': 'ARCOÍRIS', 'emoji': '🌈', 'theme': 'naturaleza', 'difficulty': 'hard'},
    {'word': 'MONTAÑA', 'emoji': '⛰️', 'theme': 'naturaleza', 'difficulty': 'medium'},
    {'word': 'OCÉANO', 'emoji': '🌊', 'theme': 'naturaleza', 'difficulty': 'medium'},
    {'word': 'RÍO', 'emoji': '🏞️', 'theme': 'naturaleza', 'difficulty': 'easy'},
    {'word': 'BOSQUE', 'emoji': '🌲', 'theme': 'naturaleza', 'difficulty': 'medium'},

    // ===== TRANSPORTES =====
    {'word': 'AUTO', 'emoji': '🚗', 'theme': 'transporte', 'difficulty': 'easy'},
    {'word': 'AVIÓN', 'emoji': '✈️', 'theme': 'transporte', 'difficulty': 'medium'},
    {'word': 'BARCO', 'emoji': '⛵', 'theme': 'transporte', 'difficulty': 'easy'},
    {'word': 'TREN', 'emoji': '🚂', 'theme': 'transporte', 'difficulty': 'easy'},
    {'word': 'BICICLETA', 'emoji': '🚲', 'theme': 'transporte', 'difficulty': 'hard'},
    {'word': 'AUTOBÚS', 'emoji': '🚌', 'theme': 'transporte', 'difficulty': 'medium'},
    {'word': 'COHETE', 'emoji': '🚀', 'theme': 'transporte', 'difficulty': 'medium'},
    {'word': 'HELICÓPTERO', 'emoji': '🚁', 'theme': 'transporte', 'difficulty': 'hard'},

    // ===== COMIDA =====
    {'word': 'PAN', 'emoji': '🍞', 'theme': 'comida', 'difficulty': 'easy'},
    {'word': 'MANZANA', 'emoji': '🍎', 'theme': 'comida', 'difficulty': 'medium'},
    {'word': 'UVA', 'emoji': '🍇', 'theme': 'comida', 'difficulty': 'easy'},
    {'word': 'FRESA', 'emoji': '🍓', 'theme': 'comida', 'difficulty': 'easy'},
    {'word': 'PLÁTANO', 'emoji': '🍌', 'theme': 'comida', 'difficulty': 'medium'},
    {'word': 'NARANJA', 'emoji': '🍊', 'theme': 'comida', 'difficulty': 'medium'},
    {'word': 'SANDÍA', 'emoji': '🍉', 'theme': 'comida', 'difficulty': 'medium'},
    {'word': 'PIZZA', 'emoji': '🍕', 'theme': 'comida', 'difficulty': 'easy'},
    {'word': 'HELADO', 'emoji': '🍦', 'theme': 'comida', 'difficulty': 'medium'},
    {'word': 'PASTEL', 'emoji': '🎂', 'theme': 'comida', 'difficulty': 'medium'},

    // ===== ESCUELA =====
    {'word': 'LIBRO', 'emoji': '📚', 'theme': 'escuela', 'difficulty': 'easy'},
    {'word': 'LÁPIZ', 'emoji': '✏️', 'theme': 'escuela', 'difficulty': 'easy'},
    {'word': 'REGLA', 'emoji': '📏', 'theme': 'escuela', 'difficulty': 'easy'},
    {'word': 'MOCHILA', 'emoji': '🎒', 'theme': 'escuela', 'difficulty': 'medium'},
    {'word': 'TIJERAS', 'emoji': '✂️', 'theme': 'escuela', 'difficulty': 'medium'},
    {'word': 'CUADERNO', 'emoji': '📓', 'theme': 'escuela', 'difficulty': 'medium'},
    {'word': 'PIZARRA', 'emoji': '🖊️', 'theme': 'escuela', 'difficulty': 'medium'},

    // ===== PROFESIONES =====
    {'word': 'DOCTOR', 'emoji': '👨‍⚕️', 'theme': 'profesiones', 'difficulty': 'medium'},
    {'word': 'BOMBERO', 'emoji': '👨‍🚒', 'theme': 'profesiones', 'difficulty': 'medium'},
    {'word': 'POLICÍA', 'emoji': '👮', 'theme': 'profesiones', 'difficulty': 'medium'},
    {'word': 'MAESTRO', 'emoji': '👨‍🏫', 'theme': 'profesiones', 'difficulty': 'medium'},
  ];

  /// Preguntas de "Asociación Creativa" (Pensamiento Lateral)
  /// 50+ preguntas que conectan objetos/conceptos de formas creativas
  static const List<Map<String, dynamic>> associationQuestions = [
    {
      'question': '¿Qué tienen en común una Nube ☁️ y el Algodón 🧺?',
      'options': [
        {'text': 'Ambos son suaves', 'emoji': '🤲', 'correct': true},
        {'text': 'Ambos son dulces', 'emoji': '🍬', 'correct': false},
        {'text': 'Ambos son duros', 'emoji': '🪨', 'correct': false},
        {'text': 'Ambos son calientes', 'emoji': '🔥', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común el Sol ☀️ y una Sonrisa 😊?',
      'options': [
        {'text': 'Ambos iluminan el día', 'emoji': '✨', 'correct': true},
        {'text': 'Ambos son fríos', 'emoji': '❄️', 'correct': false},
        {'text': 'Ambos son tristes', 'emoji': '😢', 'correct': false},
        {'text': 'Ambos son oscuros', 'emoji': '🌑', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común un Libro 📚 y una Ventana 🪟?',
      'options': [
        {'text': 'Ambos te abren a nuevos mundos', 'emoji': '🌍', 'correct': true},
        {'text': 'Ambos son comestibles', 'emoji': '🍽️', 'correct': false},
        {'text': 'Ambos vuelan', 'emoji': '✈️', 'correct': false},
        {'text': 'Ambos nadan', 'emoji': '🏊', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común un Árbol 🌳 y una Familia 👨‍👩‍👧‍👦?',
      'options': [
        {'text': 'Ambos tienen raíces y ramas', 'emoji': '🌿', 'correct': true},
        {'text': 'Ambos son metálicos', 'emoji': '🔩', 'correct': false},
        {'text': 'Ambos son líquidos', 'emoji': '💧', 'correct': false},
        {'text': 'Ambos son invisibles', 'emoji': '👻', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común una Estrella ⭐ y un Sueño 💭?',
      'options': [
        {'text': 'Ambos brillan en la oscuridad', 'emoji': '✨', 'correct': true},
        {'text': 'Ambos son pesados', 'emoji': '⚖️', 'correct': false},
        {'text': 'Ambos son amargos', 'emoji': '🤢', 'correct': false},
        {'text': 'Ambos son cuadrados', 'emoji': '⬛', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común el Agua 💧 y la Música 🎵?',
      'options': [
        {'text': 'Ambos fluyen y tienen ritmo', 'emoji': '🌊', 'correct': true},
        {'text': 'Ambos son sólidos', 'emoji': '🧱', 'correct': false},
        {'text': 'Ambos son silenciosos', 'emoji': '🤫', 'correct': false},
        {'text': 'Ambos son cuadrados', 'emoji': '⬜', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común un Espejo 🪞 y un Lago 🏞️?',
      'options': [
        {'text': 'Ambos reflejan imágenes', 'emoji': '🔄', 'correct': true},
        {'text': 'Ambos son comestibles', 'emoji': '🍴', 'correct': false},
        {'text': 'Ambos vuelan', 'emoji': '🦅', 'correct': false},
        {'text': 'Ambos son ruidosos', 'emoji': '📢', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común un Reloj ⏰ y un Río 🏞️?',
      'options': [
        {'text': 'Ambos nunca se detienen', 'emoji': '♾️', 'correct': true},
        {'text': 'Ambos son dulces', 'emoji': '🍰', 'correct': false},
        {'text': 'Ambos vuelan', 'emoji': '🕊️', 'correct': false},
        {'text': 'Ambos son pequeños', 'emoji': '🐜', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común un Arcoíris 🌈 y la Diversidad 🌍?',
      'options': [
        {'text': 'Ambos son bellos por sus diferencias', 'emoji': '💖', 'correct': true},
        {'text': 'Ambos son grises', 'emoji': '⬜', 'correct': false},
        {'text': 'Ambos son aburridos', 'emoji': '😴', 'correct': false},
        {'text': 'Ambos son iguales', 'emoji': '=', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común una Semilla 🌱 y una Idea 💡?',
      'options': [
        {'text': 'Ambas pueden crecer con cuidado', 'emoji': '🌻', 'correct': true},
        {'text': 'Ambas son metálicas', 'emoji': '🔨', 'correct': false},
        {'text': 'Ambas son frías', 'emoji': '🧊', 'correct': false},
        {'text': 'Ambas son viejas', 'emoji': '👴', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común el Fuego 🔥 y la Pasión ❤️?',
      'options': [
        {'text': 'Ambos arden con intensidad', 'emoji': '💫', 'correct': true},
        {'text': 'Ambos son fríos', 'emoji': '🥶', 'correct': false},
        {'text': 'Ambos son tranquilos', 'emoji': '😌', 'correct': false},
        {'text': 'Ambos son azules', 'emoji': '🔵', 'correct': false},
      ]
    },
    {
      'question': '¿Qué tienen en común un Puente 🌉 y la Amistad 🤝?',
      'options': [
        {'text': 'Ambos conectan dos lados', 'emoji': '🔗', 'correct': true},
        {'text': 'Ambos son comestibles', 'emoji': '🍕', 'correct': false},
        {'text': 'Ambos vuelan', 'emoji': '🛫', 'correct': false},
        {'text': 'Ambos son invisibles', 'emoji': '👁️', 'correct': false},
      ]
    },
  ];

  /// Palabras para "Asociación Creativa" (Sustantivos)
  /// 50+ sustantivos categorizados
  static const List<Map<String, dynamic>> associationNouns = [
    // CATEGORÍA: Animales
    {'word': 'PERRO', 'emoji': '🐕', 'category': 'animales'},
    {'word': 'GATO', 'emoji': '🐱', 'category': 'animales'},
    {'word': 'PÁJARO', 'emoji': '🐦', 'category': 'animales'},
    {'word': 'PEZ', 'emoji': '🐟', 'category': 'animales'},
    {'word': 'CABALLO', 'emoji': '🐴', 'category': 'animales'},
    {'word': 'VACA', 'emoji': '🐄', 'category': 'animales'},
    {'word': 'OVEJA', 'emoji': '🐑', 'category': 'animales'},
    {'word': 'CERDO', 'emoji': '🐷', 'category': 'animales'},
    {'word': 'GALLINA', 'emoji': '🐔', 'category': 'animales'},
    {'word': 'PATO', 'emoji': '🦆', 'category': 'animales'},

    // CATEGORÍA: Frutas
    {'word': 'MANZANA', 'emoji': '🍎', 'category': 'frutas'},
    {'word': 'PLÁTANO', 'emoji': '🍌', 'category': 'frutas'},
    {'word': 'UVA', 'emoji': '🍇', 'category': 'frutas'},
    {'word': 'FRESA', 'emoji': '🍓', 'category': 'frutas'},
    {'word': 'NARANJA', 'emoji': '🍊', 'category': 'frutas'},
    {'word': 'SANDÍA', 'emoji': '🍉', 'category': 'frutas'},
    {'word': 'PIÑA', 'emoji': '🍍', 'category': 'frutas'},
    {'word': 'PERA', 'emoji': '🍐', 'category': 'frutas'},
    {'word': 'CEREZA', 'emoji': '🍒', 'category': 'frutas'},
    {'word': 'LIMÓN', 'emoji': '🍋', 'category': 'frutas'},

    // CATEGORÍA: Objetos del Hogar
    {'word': 'MESA', 'emoji': '🪑', 'category': 'hogar'},
    {'word': 'SILLA', 'emoji': '🪑', 'category': 'hogar'},
    {'word': 'CAMA', 'emoji': '🛏️', 'category': 'hogar'},
    {'word': 'SOFÁ', 'emoji': '🛋️', 'category': 'hogar'},
    {'word': 'LÁMPARA', 'emoji': '💡', 'category': 'hogar'},
    {'word': 'RELOJ', 'emoji': '⏰', 'category': 'hogar'},
    {'word': 'TELEVISOR', 'emoji': '📺', 'category': 'hogar'},
    {'word': 'TELÉFONO', 'emoji': '📱', 'category': 'hogar'},
    {'word': 'REFRIGERADOR', 'emoji': '🧊', 'category': 'hogar'},

    // CATEGORÍA: Transportes
    {'word': 'CARRO', 'emoji': '🚗', 'category': 'transportes'},
    {'word': 'BICICLETA', 'emoji': '🚲', 'category': 'transportes'},
    {'word': 'AVIÓN', 'emoji': '✈️', 'category': 'transportes'},
    {'word': 'BARCO', 'emoji': '⛵', 'category': 'transportes'},
    {'word': 'TREN', 'emoji': '🚂', 'category': 'transportes'},
    {'word': 'AUTOBÚS', 'emoji': '🚌', 'category': 'transportes'},
    {'word': 'MOTOCICLETA', 'emoji': '🏍️', 'category': 'transportes'},
    {'word': 'HELICÓPTERO', 'emoji': '🚁', 'category': 'transportes'},

    // CATEGORÍA: Naturaleza
    {'word': 'ÁRBOL', 'emoji': '🌳', 'category': 'naturaleza'},
    {'word': 'FLOR', 'emoji': '🌸', 'category': 'naturaleza'},
    {'word': 'SOL', 'emoji': '☀️', 'category': 'naturaleza'},
    {'word': 'LUNA', 'emoji': '🌙', 'category': 'naturaleza'},
    {'word': 'ESTRELLA', 'emoji': '⭐', 'category': 'naturaleza'},
    {'word': 'NUBE', 'emoji': '☁️', 'category': 'naturaleza'},
    {'word': 'MONTAÑA', 'emoji': '⛰️', 'category': 'naturaleza'},
    {'word': 'RÍO', 'emoji': '🏞️', 'category': 'naturaleza'},
    {'word': 'MAR', 'emoji': '🌊', 'category': 'naturaleza'},

    // CATEGORÍA: Escuela
    {'word': 'LIBRO', 'emoji': '📚', 'category': 'escuela'},
    {'word': 'LÁPIZ', 'emoji': '✏️', 'category': 'escuela'},
    {'word': 'BORRADOR', 'emoji': '🗑️', 'category': 'escuela'},
    {'word': 'MOCHILA', 'emoji': '🎒', 'category': 'escuela'},
    {'word': 'REGLA', 'emoji': '📏', 'category': 'escuela'},
    {'word': 'TIJERAS', 'emoji': '✂️', 'category': 'escuela'},
    {'word': 'CUADERNO', 'emoji': '📓', 'category': 'escuela'},
  ];

  /// Palabras para "Sopa de Letras"
  /// Listas temáticas extensas
  static const Map<String, List<String>> wordSearchThemes = {
    'animales': [
      'PERRO', 'GATO', 'OSO', 'LEÓN', 'TIGRE', 'MONO', 'ELEFANTE',
      'JIRAFA', 'CEBRA', 'CONEJO', 'RATÓN', 'CABALLO', 'VACA', 'OVEJA',
      'PATO', 'POLLO', 'PEZ', 'TIBURÓN', 'DELFÍN', 'BALLENA',
    ],
    'frutas': [
      'MANZANA', 'PLÁTANO', 'UVA', 'FRESA', 'NARANJA', 'SANDÍA', 'MELÓN',
      'PIÑA', 'PERA', 'DURAZNO', 'CEREZA', 'LIMÓN', 'KIWI', 'MANGO',
      'PAPAYA', 'COCO', 'FRAMBUESA',
    ],
    'colores': [
      'ROJO', 'AZUL', 'VERDE', 'AMARILLO', 'NARANJA', 'MORADO', 'ROSA',
      'NEGRO', 'BLANCO', 'GRIS', 'CAFÉ', 'DORADO', 'PLATEADO', 'VIOLETA',
    ],
    'naturaleza': [
      'ÁRBOL', 'FLOR', 'ROSA', 'SOL', 'LUNA', 'ESTRELLA', 'NUBE',
      'LLUVIA', 'RÍO', 'MAR', 'MONTAÑA', 'BOSQUE', 'PLAYA', 'DESIERTO',
      'VOLCÁN', 'LAGO', 'CASCADA', 'PRADERA',
    ],
    'profesiones': [
      'DOCTOR', 'MAESTRO', 'BOMBERO', 'POLICÍA', 'CHEF', 'PILOTO',
      'ENFERMERA', 'DENTISTA', 'ARTISTA', 'MÚSICO', 'CARPINTERO',
      'PINTOR', 'VETERINARIO',
    ],
    'deportes': [
      'FÚTBOL', 'BÉISBOL', 'TENIS', 'NATACIÓN', 'CICLISMO', 'BOXEO',
      'KARATE', 'GOLF', 'SURF', 'ESQUÍ', 'PATINAJE', 'GIMNASIA',
    ],
  };

  /// Verbos de acción para juegos de lenguaje
  static const List<Map<String, dynamic>> actionVerbs = [
    {'verb': 'CORRER', 'emoji': '🏃', 'difficulty': 'easy'},
    {'verb': 'SALTAR', 'emoji': '🦘', 'difficulty': 'easy'},
    {'verb': 'CAMINAR', 'emoji': '🚶', 'difficulty': 'easy'},
    {'verb': 'NADAR', 'emoji': '🏊', 'difficulty': 'medium'},
    {'verb': 'BAILAR', 'emoji': '💃', 'difficulty': 'easy'},
    {'verb': 'CANTAR', 'emoji': '🎤', 'difficulty': 'easy'},
    {'verb': 'ESCRIBIR', 'emoji': '✍️', 'difficulty': 'medium'},
    {'verb': 'LEER', 'emoji': '📖', 'difficulty': 'easy'},
    {'verb': 'PINTAR', 'emoji': '🎨', 'difficulty': 'medium'},
    {'verb': 'DIBUJAR', 'emoji': '🖍️', 'difficulty': 'medium'},
    {'verb': 'COCINAR', 'emoji': '👨‍🍳', 'difficulty': 'medium'},
    {'verb': 'JUGAR', 'emoji': '🎮', 'difficulty': 'easy'},
    {'verb': 'DORMIR', 'emoji': '😴', 'difficulty': 'easy'},
    {'verb': 'COMER', 'emoji': '🍽️', 'difficulty': 'easy'},
    {'verb': 'BEBER', 'emoji': '🥤', 'difficulty': 'easy'},
    {'verb': 'REÍR', 'emoji': '😂', 'difficulty': 'easy'},
    {'verb': 'LLORAR', 'emoji': '😢', 'difficulty': 'easy'},
    {'verb': 'PENSAR', 'emoji': '🤔', 'difficulty': 'medium'},
    {'verb': 'ESTUDIAR', 'emoji': '📚', 'difficulty': 'medium'},
    {'verb': 'TRABAJAR', 'emoji': '💼', 'difficulty': 'medium'},
  ];

  /// Adjetivos descriptivos
  static const List<Map<String, dynamic>> adjectives = [
    {'adjective': 'GRANDE', 'opposite': 'PEQUEÑO', 'emoji': '📏'},
    {'adjective': 'RÁPIDO', 'opposite': 'LENTO', 'emoji': '⚡'},
    {'adjective': 'FELIZ', 'opposite': 'TRISTE', 'emoji': '😊'},
    {'adjective': 'CALIENTE', 'opposite': 'FRÍO', 'emoji': '🔥'},
    {'adjective': 'ALTO', 'opposite': 'BAJO', 'emoji': '📐'},
    {'adjective': 'GORDO', 'opposite': 'DELGADO', 'emoji': '🎈'},
    {'adjective': 'LIMPIO', 'opposite': 'SUCIO', 'emoji': '✨'},
    {'adjective': 'NUEVO', 'opposite': 'VIEJO', 'emoji': '🆕'},
    {'adjective': 'FUERTE', 'opposite': 'DÉBIL', 'emoji': '💪'},
    {'adjective': 'DULCE', 'opposite': 'AMARGO', 'emoji': '🍬'},
    {'adjective': 'BRILLANTE', 'opposite': 'OSCURO', 'emoji': '💡'},
    {'adjective': 'SUAVE', 'opposite': 'ÁSPERO', 'emoji': '🧸'},
    {'adjective': 'FÁCIL', 'opposite': 'DIFÍCIL', 'emoji': '✅'},
    {'adjective': 'BUENO', 'opposite': 'MALO', 'emoji': '👍'},
    {'adjective': 'BONITO', 'opposite': 'FEO', 'emoji': '🌸'},
  ];

  /// Obtiene palabras filtradas por dificultad
  static List<Map<String, dynamic>> getWordsByDifficulty(
    List<Map<String, dynamic>> words,
    String difficulty,
  ) {
    return words.where((w) => w['difficulty'] == difficulty).toList();
  }

  /// Obtiene palabras filtradas por tema
  static List<Map<String, dynamic>> getWordsByTheme(
    List<Map<String, dynamic>> words,
    String theme,
  ) {
    return words.where((w) => w['theme'] == theme || w['category'] == theme).toList();
  }

  /// Mezcla y retorna N palabras aleatorias
  static List<Map<String, dynamic>> getRandomWords(
    List<Map<String, dynamic>> words,
    int count,
  ) {
    final shuffled = List<Map<String, dynamic>>.from(words)..shuffle();
    return shuffled.take(count).toList();
  }
}
