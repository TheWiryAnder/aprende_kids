import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/word_search_model.dart';
import '../../../domain/services/word_search_generator.dart';
import '../../widgets/game_video_widget.dart';
import 'game_won_screen.dart';

class WordSearchGame extends StatefulWidget {
  final WordSearchLevel level;

  const WordSearchGame({
    super.key,
    required this.level,
  });

  @override
  State<WordSearchGame> createState() => _WordSearchGameState();
}

class _WordSearchGameState extends State<WordSearchGame> {
  late WordSearchModel _wordSearch;
  final List<CellPosition> _selectedCells = [];
  final Set<String> _foundWords = {};
  final Map<String, Color> _wordColors = {};
  bool _isSelecting = false;

  // Sistema de temporizador y monedas
  late int _timeRemaining;
  late int _timeLimit;
  Timer? _gameTimer;
  bool _gameEnded = false;

  // Sistema de estados del personaje para feedback visual
  GameVideoType _characterMood = GameVideoType.pensando;
  Timer? _moodTimer;

  // Sistema de selección basado en celdas (solo horizontal y vertical)
  final Set<int> _selectedCellIndices = {}; // Temporal (azul claro mientras arrastra)
  final Set<int> _foundCellIndices = {}; // Permanente (verde cuando encuentra palabra)
  int? _selectionStartRow;
  int? _selectionStartCol;
  String? _selectionDirection; // 'horizontal' o 'vertical'

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _generateNewPuzzle();

    // CRÍTICO: Agregar listener global para evitar selección "pegada"
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Este listener asegura que al soltar el mouse se detenga la selección
      // incluso si el mouseup ocurre fuera del widget
    });
  }

  void _initializeTimer() {
    final config = LevelConfig.configs[widget.level]!;
    _timeLimit = config.timeLimit;
    _timeRemaining = _timeLimit;

    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_gameEnded) {
        timer.cancel();
        return;
      }

      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _gameEnded = true;
          timer.cancel();
          _showTimeoutDialog();
        }
      });
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _moodTimer?.cancel();
    super.dispose();
  }

  /// Cambia el estado del personaje temporalmente y luego vuelve a "pensando"
  void _changeCharacterMood(GameVideoType mood, {int durationSeconds = 2}) {
    // Cancelar timer anterior si existe
    _moodTimer?.cancel();

    setState(() {
      _characterMood = mood;
    });

    // Volver al estado "pensando" después del tiempo especificado
    _moodTimer = Timer(Duration(seconds: durationSeconds), () {
      if (mounted) {
        setState(() {
          _characterMood = GameVideoType.pensando;
        });
      }
    });
  }

  void _generateNewPuzzle() {
    final generator = WordSearchGenerator();

    setState(() {
      // Generar con palabras aleatorias del banco maestro (sin pasar palabras)
      _wordSearch = generator.generate(widget.level);
      _selectedCells.clear();
      _foundWords.clear();
      _wordColors.clear();

      // Asignar colores a cada palabra
      for (var i = 0; i < _wordSearch.words.length; i++) {
        _wordColors[_wordSearch.words[i]] = _getColorForIndex(i);
      }
    });
  }

  Color _getColorForIndex(int index) {
    final colors = [
      Colors.blue.shade300,
      Colors.green.shade300,
      Colors.orange.shade300,
      Colors.purple.shade300,
      Colors.pink.shade300,
      Colors.teal.shade300,
      Colors.amber.shade300,
      Colors.indigo.shade300,
      Colors.red.shade300,
      Colors.cyan.shade300,
    ];
    return colors[index % colors.length];
  }

  /// Convierte índice de celda (row, col) a índice lineal único
  int _cellToIndex(int row, int col) {
    final gridSize = _wordSearch.grid.length;
    return row * gridSize + col;
  }

  /// Maneja el tap inicial en una celda (inicio de selección)
  void _onCellTapDown(int row, int col) {
    setState(() {
      _isSelecting = true;
      _selectionStartRow = row;
      _selectionStartCol = col;
      _selectionDirection = null; // Aún no se determina

      _selectedCells.clear();
      _selectedCellIndices.clear();

      // Agregar celda inicial
      _selectedCells.add(CellPosition(row, col));
      _selectedCellIndices.add(_cellToIndex(row, col));
    });
  }

  /// Maneja el arrastre sobre celdas (solo horizontal o vertical)
  void _onCellDragUpdate(int row, int col) {
    if (!_isSelecting || _selectionStartRow == null || _selectionStartCol == null) return;

    // Determinar dirección en el primer movimiento
    if (_selectionDirection == null) {
      if (row != _selectionStartRow && col == _selectionStartCol) {
        _selectionDirection = 'vertical';
      } else if (col != _selectionStartCol && row == _selectionStartRow) {
        _selectionDirection = 'horizontal';
      } else if (row == _selectionStartRow && col == _selectionStartCol) {
        return; // Misma celda, no hacer nada
      } else {
        return; // Movimiento diagonal, ignorar
      }
    }

    // Validar que el movimiento sigue la dirección establecida
    if (_selectionDirection == 'vertical' && col != _selectionStartCol) return;
    if (_selectionDirection == 'horizontal' && row != _selectionStartRow) return;

    // Calcular todas las celdas entre inicio y actual
    final cells = <CellPosition>[];
    final indices = <int>{};

    if (_selectionDirection == 'vertical') {
      final startRow = _selectionStartRow!;
      final minRow = row < startRow ? row : startRow;
      final maxRow = row > startRow ? row : startRow;

      for (int r = minRow; r <= maxRow; r++) {
        cells.add(CellPosition(r, col));
        indices.add(_cellToIndex(r, col));
      }
    } else if (_selectionDirection == 'horizontal') {
      final startCol = _selectionStartCol!;
      final minCol = col < startCol ? col : startCol;
      final maxCol = col > startCol ? col : startCol;

      for (int c = minCol; c <= maxCol; c++) {
        cells.add(CellPosition(row, c));
        indices.add(_cellToIndex(row, c));
      }
    }

    setState(() {
      _selectedCells.clear();
      _selectedCells.addAll(cells);
      _selectedCellIndices.clear();
      _selectedCellIndices.addAll(indices);
    });
  }

  /// Maneja el final de la selección
  void _onCellTapUp() {
    if (!_isSelecting) return;

    setState(() {
      _isSelecting = false;
      _checkSelectedWord();
      _selectionDirection = null;
    });
  }

  void _checkSelectedWord() {
    if (_selectedCells.isEmpty) return;

    // Verificar si coincide con alguna palabra del puzzle
    bool foundValidWord = false;
    for (final entry in _wordSearch.wordPositions.entries) {
      final word = entry.key;
      final position = entry.value;

      if (_foundWords.contains(word)) continue;

      // Verificar si las celdas seleccionadas coinciden con la palabra
      if (_cellsMatchWord(position.cells)) {
        setState(() {
          _foundWords.add(word);

          // Guardar los índices de las celdas como permanentes (VERDE)
          for (final cell in position.cells) {
            _foundCellIndices.add(_cellToIndex(cell.row, cell.col));
          }
        });

        // Mostrar feedback visual: Personaje feliz (Estado A: Éxito)
        _showWordFoundFeedback(word);
        foundValidWord = true;
        return;
      }
    }

    // No se encontró palabra válida, mostrar feedback de error (Estado B: Error)
    if (!foundValidWord && _selectedCells.length >= 2) {
      _changeCharacterMood(GameVideoType.intentalo, durationSeconds: 2);
    }

    setState(() {
      _selectedCells.clear();
      _selectedCellIndices.clear(); // Limpiar celdas temporales (azul desaparece)
    });
  }

  bool _cellsMatchWord(List<CellPosition> wordCells) {
    if (_selectedCells.length != wordCells.length) return false;

    // Verificar si las celdas seleccionadas forman una línea continua
    if (!_areSequentialCells(_selectedCells)) return false;

    // Verificar coincidencia directa (en orden)
    bool matchesForward = true;
    for (int i = 0; i < wordCells.length; i++) {
      final hasCell = _selectedCells.any(
        (cell) => cell.row == wordCells[i].row && cell.col == wordCells[i].col
      );
      if (!hasCell) {
        matchesForward = false;
        break;
      }
    }
    if (matchesForward) return true;

    // Verificar coincidencia inversa
    final reversedCells = wordCells.reversed.toList();
    bool matchesBackward = true;
    for (int i = 0; i < reversedCells.length; i++) {
      final hasCell = _selectedCells.any(
        (cell) => cell.row == reversedCells[i].row && cell.col == reversedCells[i].col
      );
      if (!hasCell) {
        matchesBackward = false;
        break;
      }
    }

    return matchesBackward;
  }

  bool _areSequentialCells(List<CellPosition> cells) {
    if (cells.length <= 1) return true;

    // Verificar que las celdas formen una línea continua
    for (int i = 0; i < cells.length - 1; i++) {
      final current = cells[i];
      final next = cells[i + 1];

      final rowDiff = (next.row - current.row).abs();
      final colDiff = (next.col - current.col).abs();

      // Las celdas deben ser adyacentes (horizontal, vertical o diagonal)
      if ((rowDiff == 0 && colDiff == 1) || // Horizontal
          (rowDiff == 1 && colDiff == 0) || // Vertical
          (rowDiff == 1 && colDiff == 1)) {  // Diagonal
        continue;
      } else {
        return false; // No son adyacentes
      }
    }

    return true;
  }

  void _showWordFoundFeedback(String word) {
    // Cambiar el personaje a estado "excelente" por 3 segundos
    _changeCharacterMood(GameVideoType.excelente, durationSeconds: 3);

    // Verificar si ganó
    if (_foundWords.length == _wordSearch.words.length && !_gameEnded) {
      setState(() => _gameEnded = true);
      _gameTimer?.cancel();
      Future.delayed(const Duration(milliseconds: 500), _showVictoryDialog);
    }
  }

  void _showVictoryDialog() {
    // Calcular monedas ganadas
    final coins = LevelConfig.calculateCoins(_timeRemaining, _timeLimit);

    // Navegar a la pantalla unificada de victoria
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (context) => GameWonScreen(
          gameTitle: 'Sopa de Letras',
          score: (_foundWords.length * 100 ~/ _wordSearch.words.length),
          totalQuestions: _wordSearch.words.length,
          correctAnswers: _foundWords.length,
          timeRemaining: _timeRemaining,
          timeLimit: _timeLimit,
          coins: coins,
          primaryColor: Colors.purple.shade400,
          accentColor: Colors.purple.shade700,
          onPlayAgain: () {
            setState(() {
              _gameEnded = false;
              _generateNewPuzzle();
              _initializeTimer();
            });
          },
        ),
      ),
    );
  }

  void _showTimeoutDialog() {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.orange.shade300, Colors.orange.shade500],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // GIF de ánimo
              const GameVideoWidget(
                videoType: GameVideoType.intentalo,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 16),
              Text(
                '¡Se acabó el tiempo!',
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'Encontraste ${_foundWords.length} de ${_wordSearch.words.length} palabras',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '¡Inténtalo de nuevo! 💪',
                  style: GoogleFonts.fredoka(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      context.pop();
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.white.withValues(alpha: 0.3),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Salir',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _gameEnded = false;
                        _generateNewPuzzle();
                        _initializeTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.orange.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Reintentar',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade400,
              Colors.purple.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: isMobile ? _buildMobileLayout() : _buildDesktopLayout(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Layout para móvil (vertical, personaje abajo)
  Widget _buildMobileLayout() {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 16),
                // Cuadrícula amplia y centrada
                _buildGrid(),
                const SizedBox(height: 24),
                // Lista de palabras
                _buildWordList(),
                const SizedBox(height: 240), // Espacio para el personaje
              ],
            ),
          ),
        ),
        // Personaje en la esquina inferior izquierda
        // El GIF cambia según el estado: pensando (neutro), excelente (éxito), intentalo (error)
        if (!_gameEnded)
          Positioned(
            bottom: 24,
            left: 24,
            child: GameVideoWidget(
              videoType: _characterMood, // ← Usa el estado del personaje
              width: 180,
              height: 180,
            ),
          ),
      ],
    );
  }

  // Layout para desktop (horizontal: 3 columnas - 30% / 50% / 20%)
  // Patrón "Scale to Fit": Se adapta a cualquier resolución sin scroll
  Widget _buildDesktopLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: 1400,
                maxHeight: 900,
              ),
              child: SizedBox(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Columna Izquierda (30%): Personaje - SOLO GIF, SIN TEXTO, SIN FONDO
                    // El GIF cambia según el estado: pensando (neutro), excelente (éxito), intentalo (error)
                    Expanded(
                      flex: 3,
                      child: !_gameEnded
                          ? Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    // GIF grande: 90% del ancho disponible de la columna
                                    final gifSize = constraints.maxWidth * 0.90;
                                    return GameVideoWidget(
                                      videoType: _characterMood, // ← Usa el estado del personaje
                                      width: gifSize,
                                      height: gifSize,
                                    );
                                  },
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),

                    // Columna Centro (50%): Cuadrícula de la Sopa de Letras
                    Expanded(
                      flex: 5,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                          child: _buildGrid(),
                        ),
                      ),
                    ),

                    // Columna Derecha (20%): Lista de Palabras a encontrar
                    Expanded(
                      flex: 2,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          child: _buildWordList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    // Color del timer según el tiempo restante
    final timeColor = _timeRemaining <= 30
        ? Colors.red.shade100
        : _timeRemaining <= 60
            ? Colors.orange.shade100
            : Colors.white;

    final textColor = _timeRemaining <= 30
        ? Colors.red.shade700
        : _timeRemaining <= 60
            ? Colors.orange.shade700
            : Colors.purple.shade700;

    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sopa de Letras',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Timer
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: timeColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer,
                  color: textColor,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  _formatTime(_timeRemaining),
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Progreso de palabras
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_foundWords.length}/${_wordSearch.words.length}',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.purple.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid() {
    final gridSize = _wordSearch.grid.length;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Calcular el tamaño máximo disponible (el menor entre ancho y alto)
        final maxSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth
            : constraints.maxHeight;

        // Márgenes y padding adaptivos según el tamaño de la cuadrícula
        final margin = gridSize >= 12 ? 8.0 : (gridSize >= 10 ? 12.0 : 16.0);
        final padding = gridSize >= 12 ? 4.0 : (gridSize >= 10 ? 6.0 : 8.0);
        final spacing = gridSize >= 12 ? 1.5 : 2.0;

        // Tamaño del contenedor de la cuadrícula (cuadrado perfecto)
        final gridContainerSize = maxSize - (margin * 2);

        // Tamaño de cada celda (dinámico según el nivel)
        final totalSpacing = spacing * (gridSize - 1);
        final cellSize = (gridContainerSize - (padding * 2) - totalSpacing) / gridSize;

        return Center(
          child: Container(
            width: gridContainerSize,
            height: gridContainerSize,
            margin: EdgeInsets.all(margin),
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(gridSize >= 12 ? 12 : 16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: GestureDetector(
              // Capturar eventos de arrastre continuo
              onPanStart: (details) {
                final localPos = details.localPosition;
                final row = (localPos.dy / (cellSize + spacing)).floor();
                final col = (localPos.dx / (cellSize + spacing)).floor();

                if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
                  _onCellTapDown(row, col);
                }
              },
              onPanUpdate: (details) {
                final localPos = details.localPosition;
                final row = (localPos.dy / (cellSize + spacing)).floor();
                final col = (localPos.dx / (cellSize + spacing)).floor();

                if (row >= 0 && row < gridSize && col >= 0 && col < gridSize) {
                  _onCellDragUpdate(row, col);
                }
              },
              onPanEnd: (_) {
                _onCellTapUp();
              },
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: gridSize, // Dinámico: 8, 10 o 12
                  mainAxisSpacing: spacing,
                  crossAxisSpacing: spacing,
                  childAspectRatio: 1.0, // Celdas cuadradas
                ),
                itemCount: gridSize * gridSize,
                itemBuilder: (context, index) {
                  final row = index ~/ gridSize;
                  final col = index % gridSize;
                  return _buildCell(row, col, cellSize);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCell(int row, int col, double size) {
    final cellIndex = _cellToIndex(row, col);

    // Determinar el estado de la celda
    final isFound = _foundCellIndices.contains(cellIndex);
    final isSelected = _selectedCellIndices.contains(cellIndex);

    // Obtener el color de la palabra encontrada
    Color? foundWordColor;
    if (isFound) {
      for (final word in _foundWords) {
        final position = _wordSearch.wordPositions[word];
        if (position != null) {
          final isInWord = position.cells.any(
            (cell) => cell.row == row && cell.col == col,
          );
          if (isInWord) {
            foundWordColor = _wordColors[word];
            break;
          }
        }
      }
    }

    // Determinar color de fondo según estado
    Color backgroundColor;
    if (isFound) {
      // Palabras encontradas: verde/color de palabra (permanente)
      backgroundColor = foundWordColor?.withValues(alpha: 0.4) ?? Colors.green.withValues(alpha: 0.3);
    } else if (isSelected) {
      // Selección actual: azul claro (temporal)
      backgroundColor = Colors.blue.withValues(alpha: 0.2);
    } else {
      // Sin selección: blanco
      backgroundColor = Colors.white;
    }

    // Calcular border radius y width dinámicamente (más pequeños en niveles difíciles)
    final borderRadius = size > 40 ? 8.0 : size > 30 ? 6.0 : 4.0;
    final borderWidth = size > 35 ? 2.0 : (size > 25 ? 1.5 : 1.0);

    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(
          color: isSelected
              ? Colors.blue.shade400
              : isFound
                  ? (foundWordColor ?? Colors.green.shade400)
                  : Colors.grey.shade300,
          width: (isSelected || isFound) ? borderWidth : (borderWidth * 0.7),
        ),
      ),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(size * 0.08), // Padding proporcional reducido
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              _wordSearch.grid[row][col],
              style: GoogleFonts.fredoka(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordList() {
    final numWords = _wordSearch.words.length;
    final numRows = (numWords / 2).ceil(); // 2 columnas

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Palabras:',
            style: GoogleFonts.fredoka(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.purple.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          // Layout en 2 columnas usando GridView
          Expanded(
            child: GridView.builder(
              shrinkWrap: true,
              physics: numRows > 6
                  ? const BouncingScrollPhysics()
                  : const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columnas
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3.5, // Celdas más anchas y bajas
              ),
              itemCount: _wordSearch.words.length,
              itemBuilder: (context, index) {
                final word = _wordSearch.words[index];
                final isFound = _foundWords.contains(word);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isFound
                        ? _wordColors[word]!.withValues(alpha: 0.4)
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isFound ? _wordColors[word]! : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        isFound ? Icons.check_circle : Icons.circle_outlined,
                        color: isFound ? Colors.green.shade700 : Colors.grey.shade400,
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          word,
                          style: GoogleFonts.fredoka(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            decoration: isFound ? TextDecoration.lineThrough : null,
                            decorationThickness: 2.5,
                            decorationColor: Colors.green.shade700,
                            color: isFound ? Colors.black45 : Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
