import 'dart:math';
import '../models/word_search_model.dart';
import 'shuffle_bag_service.dart';

/// Generador de Sopas de Letras
class WordSearchGenerator {
  final Random _random = Random();

  // ✅ SHUFFLE BAG: Evita repetición de palabras entre partidas
  static ShuffleBag<String>? _wordBag;

  /// Banco de palabras maestro - Palabras variadas por categorías
  static const Map<String, List<String>> wordBank = {
    'animales': [
      'GATO', 'PERRO', 'LEON', 'TIGRE', 'OSO', 'LOBO', 'ZORRO', 'PATO',
      'PAVO', 'CABRA', 'VACA', 'BURRO', 'MONO', 'LORO', 'AGUILA', 'COCODRILO',
      'JIRAFA', 'ELEFANTE', 'CEBRA', 'HIPOPOTAMO', 'RINOCERONTE', 'PINGUINO',
      'FOCA', 'DELFIN', 'BALLENA', 'TIBURON', 'PULPO', 'MEDUSA', 'CORAL',
      'CANGREJO', 'LANGOSTA', 'CARACOL', 'MARIPOSA', 'ABEJA', 'HORMIGA',
    ],
    'colores': [
      'ROJO', 'AZUL', 'VERDE', 'AMARILLO', 'ROSA', 'MORADO', 'NARANJA', 'BLANCO',
      'NEGRO', 'GRIS', 'CAFE', 'CELESTE', 'VIOLETA', 'TURQUESA', 'DORADO',
      'PLATEADO', 'BEIGE', 'SALMON', 'CORAL', 'INDIGO',
    ],
    'frutas': [
      'MANZANA', 'PERA', 'UVA', 'FRESA', 'SANDIA', 'MELON', 'PIÑA', 'MANGO',
      'PAPAYA', 'KIWI', 'CEREZA', 'DURAZNO', 'CIRUELA', 'BANANA', 'NARANJA',
      'LIMON', 'MANDARINA', 'TORONJA', 'COCO', 'FRAMBUESA',
    ],
    'objetos': [
      'MESA', 'SILLA', 'PUERTA', 'VENTANA', 'LAMPARA', 'RELOJ', 'TELEFONO',
      'LIBRO', 'LAPIZ', 'CUADERNO', 'MOCHILA', 'ZAPATO', 'GORRA', 'CAMA',
      'ALMOHADA', 'CUCHARA', 'TENEDOR', 'PLATO', 'VASO', 'TAZA',
    ],
    'naturaleza': [
      'SOL', 'LUNA', 'ESTRELLA', 'NUBE', 'LLUVIA', 'NIEVE', 'VIENTO', 'RAYO',
      'ARBOL', 'FLOR', 'HOJA', 'RAMA', 'RAIZ', 'SEMILLA', 'PASTO', 'PIEDRA',
      'RIO', 'LAGO', 'MAR', 'PLAYA', 'MONTAÑA', 'VALLE', 'BOSQUE', 'SELVA',
    ],
  };

  /// Genera una sopa de letras según el nivel con palabras aleatorias
  WordSearchModel generate(WordSearchLevel level, [List<String>? customWords]) {
    final config = LevelConfig.configs[level]!;

    // Si no se proveen palabras personalizadas, usar el banco aleatorio
    List<String> wordsToUse;
    if (customWords != null && customWords.isNotEmpty) {
      wordsToUse = customWords;
    } else {
      // Seleccionar palabras aleatorias del banco maestro
      wordsToUse = _selectRandomWords(config.maxWords);
    }

    // Limitar palabras según configuración
    final selectedWords = wordsToUse.take(config.maxWords).toList();

    // Crear cuadrícula vacía
    final grid = List.generate(
      config.gridSize,
      (_) => List.generate(config.gridSize, (_) => ''),
    );

    final wordPositions = <String, WordPosition>{};

    // Intentar colocar cada palabra
    for (final word in selectedWords) {
      final position = _placeWord(grid, word, config);
      if (position != null) {
        wordPositions[word] = position;
      }
    }

    // Rellenar espacios vacíos con letras aleatorias
    _fillEmptySpaces(grid);

    return WordSearchModel(
      level: level,
      words: wordPositions.keys.toList(),
      grid: grid,
      wordPositions: wordPositions,
    );
  }

  /// Intenta colocar una palabra en la cuadrícula
  WordPosition? _placeWord(
    List<List<String>> grid,
    String word,
    LevelConfig config,
  ) {
    final wordUpper = word.toUpperCase();
    final maxAttempts = 100;

    for (var attempt = 0; attempt < maxAttempts; attempt++) {
      // Elegir dirección aleatoria
      final direction = config.allowedDirections[
        _random.nextInt(config.allowedDirections.length)
      ];

      // Elegir posición inicial aleatoria
      final startRow = _random.nextInt(config.gridSize);
      final startCol = _random.nextInt(config.gridSize);

      // Verificar si la palabra cabe en esa posición y dirección
      final cells = _getCells(startRow, startCol, wordUpper.length, direction);

      if (_canPlaceWord(grid, wordUpper, cells, config.gridSize)) {
        // Colocar la palabra
        for (var i = 0; i < wordUpper.length; i++) {
          grid[cells[i].row][cells[i].col] = wordUpper[i];
        }

        return WordPosition(
          word: word,
          startRow: startRow,
          startCol: startCol,
          direction: direction,
          cells: cells,
        );
      }
    }

    return null; // No se pudo colocar la palabra
  }

  /// Obtiene las celdas que ocupa una palabra en una dirección
  List<CellPosition> _getCells(
    int startRow,
    int startCol,
    int length,
    WordDirection direction,
  ) {
    final cells = <CellPosition>[];

    for (var i = 0; i < length; i++) {
      int row = startRow;
      int col = startCol;

      switch (direction) {
        case WordDirection.horizontal:
          col += i;
          break;
        case WordDirection.vertical:
          row += i;
          break;
        case WordDirection.diagonal:
          row += i;
          col += i;
          break;
        case WordDirection.horizontalRev:
          col -= i;
          break;
        case WordDirection.verticalRev:
          row -= i;
          break;
        case WordDirection.diagonalRev:
          row -= i;
          col -= i;
          break;
      }

      cells.add(CellPosition(row, col));
    }

    return cells;
  }

  /// Verifica si se puede colocar una palabra
  bool _canPlaceWord(
    List<List<String>> grid,
    String word,
    List<CellPosition> cells,
    int gridSize,
  ) {
    // Verificar que todas las celdas estén dentro de la cuadrícula
    for (final cell in cells) {
      if (cell.row < 0 || cell.row >= gridSize ||
          cell.col < 0 || cell.col >= gridSize) {
        return false;
      }
    }

    // Verificar que las celdas estén vacías o contengan la letra correcta
    for (var i = 0; i < cells.length; i++) {
      final cell = cells[i];
      final currentLetter = grid[cell.row][cell.col];
      final newLetter = word[i];

      if (currentLetter.isNotEmpty && currentLetter != newLetter) {
        return false;
      }
    }

    return true;
  }

  /// Selecciona palabras aleatorias del banco maestro usando ShuffleBag
  /// para evitar repetición entre partidas
  List<String> _selectRandomWords(int count) {
    // ✅ SHUFFLE BAG: Inicializar bolsa si no existe
    if (_wordBag == null) {
      // Combinar todas las categorías en una lista
      final allWords = <String>[];
      for (final category in wordBank.values) {
        allWords.addAll(category);
      }
      _wordBag = ShuffleBag<String>(
        storageKey: 'word_search_words',
        items: allWords,
      );
    }

    // ✅ SHUFFLE BAG: Obtener palabras sin repetir hasta agotar todas
    final selectedWords = <String>[];
    for (var i = 0; i < count && i < _wordBag!.totalItems; i++) {
      selectedWords.add(_wordBag!.next());
    }

    return selectedWords;
  }

  /// Rellena los espacios vacíos con letras aleatorias
  void _fillEmptySpaces(List<List<String>> grid) {
    const letters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';

    for (var row = 0; row < grid.length; row++) {
      for (var col = 0; col < grid[row].length; col++) {
        if (grid[row][col].isEmpty) {
          grid[row][col] = letters[_random.nextInt(letters.length)];
        }
      }
    }
  }
}
