library;

/// Banco de Datos para Juegos de Matemáticas con Generación Procedural
///
/// NO usa preguntas fijas. Genera problemas dinámicamente en tiempo real
/// con variación visual para evitar monotonía.
///
/// Características:
/// - Generación procedural de problemas matemáticos
/// - Variación de assets visuales (cohetes, gatos, monedas, planetas, etc.)
/// - Dificultad progresiva
/// - Sin repetición exacta de problemas
///
/// Autor: APRENDE_KIDS
/// Fecha: 2025

import 'dart:math';

/// Tipos de representaciones visuales para problemas matemáticos
enum MathVisualType {
  rockets('🚀', 'cohetes'),
  cats('🐱', 'gatos'),
  coins('🪙', 'monedas'),
  planets('🪐', 'planetas'),
  stars('⭐', 'estrellas'),
  apples('🍎', 'manzanas'),
  cars('🚗', 'carros'),
  hearts('❤️', 'corazones'),
  flowers('🌸', 'flores'),
  balloons('🎈', 'globos'),
  candies('🍬', 'dulces'),
  balls('⚽', 'pelotas'),
  books('📚', 'libros'),
  butterflies('🦋', 'mariposas'),
  diamonds('💎', 'diamantes');

  final String emoji;
  final String name;

  const MathVisualType(this.emoji, this.name);

  /// Obtiene un tipo visual aleatorio
  static MathVisualType random() {
    final values = MathVisualType.values;
    return values[Random().nextInt(values.length)];
  }
}

/// Operación matemática
enum MathOperation {
  addition('suma', '+'),
  subtraction('resta', '-'),
  multiplication('multiplicación', '×'),
  division('división', '÷');

  final String name;
  final String symbol;

  const MathOperation(this.name, this.symbol);
}

/// Problema matemático generado
class MathProblem {
  final int operand1;
  final int operand2;
  final MathOperation operation;
  final int correctAnswer;
  final MathVisualType visualType;
  final List<int> options; // Opciones múltiples
  final String questionText;

  MathProblem({
    required this.operand1,
    required this.operand2,
    required this.operation,
    required this.correctAnswer,
    required this.visualType,
    required this.options,
    required this.questionText,
  });

  @override
  String toString() => '$operand1 ${operation.symbol} $operand2 = ?';
}

/// Generador procedural de problemas matemáticos
class MathDataBank {
  static final Random _random = Random();

  /// Genera un problema de suma
  static MathProblem generateAddition({required int level}) {
    final visual = MathVisualType.random();

    int operand1, operand2, answer;

    switch (level) {
      case 1: // Fácil: 1-5 + 1-5
        operand1 = _random.nextInt(5) + 1;
        operand2 = _random.nextInt(5) + 1;
        break;
      case 2: // Medio: 1-10 + 1-10
        operand1 = _random.nextInt(10) + 1;
        operand2 = _random.nextInt(10) + 1;
        break;
      case 3: // Difícil: 1-20 + 1-20
        operand1 = _random.nextInt(20) + 1;
        operand2 = _random.nextInt(20) + 1;
        break;
      default:
        operand1 = _random.nextInt(10) + 1;
        operand2 = _random.nextInt(10) + 1;
    }

    answer = operand1 + operand2;

    return MathProblem(
      operand1: operand1,
      operand2: operand2,
      operation: MathOperation.addition,
      correctAnswer: answer,
      visualType: visual,
      options: _generateOptions(answer, level),
      questionText: '¿Cuántos ${visual.name} hay en total?',
    );
  }

  /// Genera un problema de resta
  static MathProblem generateSubtraction({required int level}) {
    final visual = MathVisualType.random();

    int operand1, operand2, answer;

    switch (level) {
      case 1: // Fácil: 5-10 - 1-5
        operand1 = _random.nextInt(6) + 5;
        operand2 = _random.nextInt(operand1) + 1;
        break;
      case 2: // Medio: 10-20 - 1-10
        operand1 = _random.nextInt(11) + 10;
        operand2 = _random.nextInt(10) + 1;
        break;
      case 3: // Difícil: 20-50 - 1-20
        operand1 = _random.nextInt(31) + 20;
        operand2 = _random.nextInt(20) + 1;
        break;
      default:
        operand1 = _random.nextInt(11) + 5;
        operand2 = _random.nextInt(operand1) + 1;
    }

    answer = operand1 - operand2;

    return MathProblem(
      operand1: operand1,
      operand2: operand2,
      operation: MathOperation.subtraction,
      correctAnswer: answer,
      visualType: visual,
      options: _generateOptions(answer, level),
      questionText: 'Si tienes $operand1 ${visual.name} y pierdes $operand2, ¿cuántos quedan?',
    );
  }

  /// Genera un problema de multiplicación
  static MathProblem generateMultiplication({required int level}) {
    final visual = MathVisualType.random();

    int operand1, operand2, answer;

    switch (level) {
      case 1: // Fácil: tablas del 1-3
        operand1 = _random.nextInt(3) + 1;
        operand2 = _random.nextInt(10) + 1;
        break;
      case 2: // Medio: tablas del 1-6
        operand1 = _random.nextInt(6) + 1;
        operand2 = _random.nextInt(10) + 1;
        break;
      case 3: // Difícil: tablas del 1-10
        operand1 = _random.nextInt(10) + 1;
        operand2 = _random.nextInt(10) + 1;
        break;
      default:
        operand1 = _random.nextInt(5) + 1;
        operand2 = _random.nextInt(10) + 1;
    }

    answer = operand1 * operand2;

    return MathProblem(
      operand1: operand1,
      operand2: operand2,
      operation: MathOperation.multiplication,
      correctAnswer: answer,
      visualType: visual,
      options: _generateOptions(answer, level),
      questionText: 'Si tienes $operand1 grupos de $operand2 ${visual.name}, ¿cuántos hay?',
    );
  }

  /// Genera un problema de división simple
  static MathProblem generateDivision({required int level}) {
    final visual = MathVisualType.random();

    int divisor, quotient, dividend, answer;

    switch (level) {
      case 1: // Fácil: divisiones exactas con divisores 2-3
        divisor = _random.nextInt(2) + 2; // 2 o 3
        quotient = _random.nextInt(5) + 1;
        break;
      case 2: // Medio: divisiones exactas con divisores 2-5
        divisor = _random.nextInt(4) + 2; // 2-5
        quotient = _random.nextInt(8) + 1;
        break;
      case 3: // Difícil: divisiones exactas con divisores 2-10
        divisor = _random.nextInt(9) + 2; // 2-10
        quotient = _random.nextInt(10) + 1;
        break;
      default:
        divisor = _random.nextInt(3) + 2;
        quotient = _random.nextInt(5) + 1;
    }

    dividend = divisor * quotient;
    answer = quotient;

    return MathProblem(
      operand1: dividend,
      operand2: divisor,
      operation: MathOperation.division,
      correctAnswer: answer,
      visualType: visual,
      options: _generateOptions(answer, level),
      questionText: 'Si repartes $dividend ${visual.name} entre $divisor niños, ¿cuántos recibe cada uno?',
    );
  }

  /// Genera un problema aleatorio según el nivel
  static MathProblem generateRandom({required int level}) {
    final operationType = _random.nextInt(4);

    switch (operationType) {
      case 0:
        return generateAddition(level: level);
      case 1:
        return generateSubtraction(level: level);
      case 2:
        return generateMultiplication(level: level);
      case 3:
        return generateDivision(level: level);
      default:
        return generateAddition(level: level);
    }
  }

  /// Genera opciones múltiples (4 opciones con 1 correcta)
  static List<int> _generateOptions(int correctAnswer, int level) {
    final options = <int>{correctAnswer};
    final range = level * 3; // Rango de variación según nivel

    while (options.length < 4) {
      final offset = _random.nextInt(range * 2) - range;
      final option = (correctAnswer + offset).clamp(0, correctAnswer + range);

      if (option != correctAnswer && option >= 0) {
        options.add(option);
      }
    }

    final list = options.toList()..shuffle();
    return list;
  }

  /// Genera una secuencia de problemas sin repetición exacta
  static List<MathProblem> generateProblemSet({
    required int count,
    required int level,
    MathOperation? operationType,
  }) {
    final problems = <MathProblem>[];
    final seenProblems = <String>{};

    int attempts = 0;
    const maxAttempts = count * 10;

    while (problems.length < count && attempts < maxAttempts) {
      attempts++;

      final problem = operationType != null
          ? _generateByOperation(operationType, level)
          : generateRandom(level: level);

      final signature = '${problem.operand1}_${problem.operation.symbol}_${problem.operand2}';

      if (!seenProblems.contains(signature)) {
        seenProblems.add(signature);
        problems.add(problem);
      }
    }

    return problems;
  }

  static MathProblem _generateByOperation(MathOperation operation, int level) {
    switch (operation) {
      case MathOperation.addition:
        return generateAddition(level: level);
      case MathOperation.subtraction:
        return generateSubtraction(level: level);
      case MathOperation.multiplication:
        return generateMultiplication(level: level);
      case MathOperation.division:
        return generateDivision(level: level);
    }
  }

  /// Genera problemas de comparación (mayor/menor/igual)
  static Map<String, dynamic> generateComparison({required int level}) {
    final visual1 = MathVisualType.random();
    final visual2 = MathVisualType.random();

    int num1, num2;

    switch (level) {
      case 1:
        num1 = _random.nextInt(10) + 1;
        num2 = _random.nextInt(10) + 1;
        break;
      case 2:
        num1 = _random.nextInt(20) + 1;
        num2 = _random.nextInt(20) + 1;
        break;
      case 3:
        num1 = _random.nextInt(50) + 1;
        num2 = _random.nextInt(50) + 1;
        break;
      default:
        num1 = _random.nextInt(10) + 1;
        num2 = _random.nextInt(10) + 1;
    }

    String correctAnswer;
    if (num1 > num2) {
      correctAnswer = '>';
    } else if (num1 < num2) {
      correctAnswer = '<';
    } else {
      correctAnswer = '=';
    }

    return {
      'num1': num1,
      'num2': num2,
      'visual1': visual1,
      'visual2': visual2,
      'correctAnswer': correctAnswer,
      'question': '¿Cuál grupo tiene más?',
    };
  }

  /// Genera secuencias numéricas (encontrar el número faltante)
  static Map<String, dynamic> generateSequence({required int level}) {
    int start, step, length;

    switch (level) {
      case 1:
        start = _random.nextInt(5) + 1;
        step = 1;
        length = 5;
        break;
      case 2:
        start = _random.nextInt(10) + 1;
        step = _random.nextBool() ? 2 : 1;
        length = 6;
        break;
      case 3:
        start = _random.nextInt(10) + 1;
        final possibleSteps = [1, 2, 5];
        step = possibleSteps[_random.nextInt(3)];
        length = 7;
        break;
      default:
        start = 1;
        step = 1;
        length = 5;
    }

    final sequence = <int>[];
    for (int i = 0; i < length; i++) {
      sequence.add(start + (i * step));
    }

    // Ocultar un número aleatorio (no el primero ni el último)
    final missingIndex = _random.nextInt(length - 2) + 1;
    final correctAnswer = sequence[missingIndex];
    sequence[missingIndex] = -1; // Marcador de "faltante"

    return {
      'sequence': sequence,
      'missingIndex': missingIndex,
      'correctAnswer': correctAnswer,
      'step': step,
    };
  }
}
