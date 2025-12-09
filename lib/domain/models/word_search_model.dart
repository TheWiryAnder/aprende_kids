/// Modelo para el juego de Sopa de Letras
class WordSearchModel {
  final WordSearchLevel level;
  final List<String> words;
  final List<List<String>> grid;
  final Map<String, WordPosition> wordPositions;

  WordSearchModel({
    required this.level,
    required this.words,
    required this.grid,
    required this.wordPositions,
  });
}

/// Niveles de dificultad
enum WordSearchLevel {
  basico,    // 6-8 años
  intermedio, // 8-10 años
  avanzado,   // 10-12 años
}

/// Dirección de una palabra en la cuadrícula
enum WordDirection {
  horizontal,      // →
  vertical,        // ↓
  diagonal,        // ↘
  horizontalRev,   // ←
  verticalRev,     // ↑
  diagonalRev,     // ↖
}

/// Posición de una palabra en la cuadrícula
class WordPosition {
  final String word;
  final int startRow;
  final int startCol;
  final WordDirection direction;
  final List<CellPosition> cells;

  WordPosition({
    required this.word,
    required this.startRow,
    required this.startCol,
    required this.direction,
    required this.cells,
  });
}

/// Posición de una celda individual
class CellPosition {
  final int row;
  final int col;

  CellPosition(this.row, this.col);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CellPosition && other.row == row && other.col == col;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode;
}

/// Configuración de niveles
class LevelConfig {
  final int gridSize;
  final List<WordDirection> allowedDirections;
  final int minWords;
  final int maxWords;
  final int timeLimit; // Tiempo en segundos

  const LevelConfig({
    required this.gridSize,
    required this.allowedDirections,
    required this.minWords,
    required this.maxWords,
    required this.timeLimit,
  });

  static const Map<WordSearchLevel, LevelConfig> configs = {
    WordSearchLevel.basico: LevelConfig(
      gridSize: 8,
      allowedDirections: [
        WordDirection.horizontal,
        WordDirection.vertical,
      ],
      minWords: 3,
      maxWords: 5,
      timeLimit: 120, // 2 minutos
    ),
    WordSearchLevel.intermedio: LevelConfig(
      gridSize: 10,
      allowedDirections: [
        WordDirection.horizontal,
        WordDirection.vertical,
        WordDirection.diagonal,
      ],
      minWords: 6,
      maxWords: 8,
      timeLimit: 240, // 4 minutos
    ),
    WordSearchLevel.avanzado: LevelConfig(
      gridSize: 12,
      allowedDirections: [
        WordDirection.horizontal,
        WordDirection.vertical,
        WordDirection.diagonal,
        WordDirection.horizontalRev,
        WordDirection.verticalRev,
        WordDirection.diagonalRev,
      ],
      minWords: 10,
      maxWords: 12,
      timeLimit: 300, // 5 minutos
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
