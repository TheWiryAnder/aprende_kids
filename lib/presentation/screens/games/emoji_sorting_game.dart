import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/emoji_sorting_model.dart';
import '../../../domain/services/emoji_sorting_generator.dart';
import '../../widgets/game_video_widget.dart';

class EmojiSortingGame extends StatefulWidget {
  final EmojiSortingLevel level;

  const EmojiSortingGame({
    super.key,
    required this.level,
  });

  @override
  State<EmojiSortingGame> createState() => _EmojiSortingGameState();
}

class _EmojiSortingGameState extends State<EmojiSortingGame> with SingleTickerProviderStateMixin {
  late EmojiSortingModel _game;
  late List<EmojiCategory> _categories;
  late List<String> _availableEmojis;
  late AnimationController _celebrationController;

  // Sistema de temporizador y monedas
  late int _timeRemaining;
  late int _timeLimit;
  Timer? _gameTimer;
  bool _gameEnded = false;

  @override
  void initState() {
    super.initState();
    _initializeTimer();
    _generateNewGame();
    _celebrationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
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
    _celebrationController.dispose();
    super.dispose();
  }

  void _generateNewGame() {
    final generator = EmojiSortingGenerator();
    setState(() {
      _game = generator.generate(widget.level);
      _categories = _game.categories.map((c) => c.copyWith()).toList();
      _availableEmojis = List.from(_game.shuffledEmojis);
    });
  }

  void _onEmojiDrop(String emoji, int categoryIndex) {
    if (_gameEnded) return; // No permitir interacción si el juego terminó

    final category = _categories[categoryIndex];

    // Verificar si el emoji es correcto para esta categoría
    if (category.isCorrectEmoji(emoji)) {
      setState(() {
        // Remover emoji del banco
        _availableEmojis.remove(emoji);

        // Agregar a la categoría
        _categories[categoryIndex] = category.copyWith(
          placedEmojis: [...category.placedEmojis, emoji],
        );
      });

      // Feedback positivo
      _showCorrectFeedback();

      // Verificar si ganó
      if (_checkVictory() && !_gameEnded) {
        setState(() => _gameEnded = true);
        _gameTimer?.cancel();
        Future.delayed(const Duration(milliseconds: 500), _showVictoryDialog);
      }
    } else {
      // Feedback negativo
      _showIncorrectFeedback();
    }
  }

  bool _checkVictory() {
    return _categories.every((category) => category.isComplete()) &&
        _availableEmojis.isEmpty;
  }

  void _showCorrectFeedback() {
    _celebrationController.forward(from: 0);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('¡Correcto! ✨', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showIncorrectFeedback() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Intenta de nuevo 🤔', style: TextStyle(fontSize: 18)),
        backgroundColor: Colors.orange,
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showVictoryDialog() {
    // Calcular monedas ganadas
    final coins = LevelConfig.calculateCoins(_timeRemaining, _timeLimit);

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
              colors: [Colors.teal.shade300, Colors.teal.shade500],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // GIF de celebración
              const GameVideoWidget(
                videoType: GameVideoType.excelente,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 16),
              Text(
                '¡Felicitaciones! 🎉',
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                '¡Clasificaste todos los emojis correctamente!',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Monedas ganadas
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('💰', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 12),
                        Text(
                          '$coins Monedas',
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tiempo: ${_formatTime(_timeRemaining)}',
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
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
                        _generateNewGame();
                        _initializeTimer();
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.teal.shade700,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      'Jugar de Nuevo',
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
                'Clasificaste ${_categories.fold<int>(0, (sum, cat) => sum + cat.placedEmojis.length)} de ${_categories.fold<int>(0, (sum, cat) => sum + cat.correctEmojis.length)} emojis',
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
                        _generateNewGame();
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.teal.shade400,
              Colors.teal.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Columnas de categorías
                          _buildCategoryColumns(),
                          const SizedBox(height: 32),
                          // Banco de emojis
                          _buildEmojiBank(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              // GIF de pensando - lado izquierdo, grande y visible (solo si el juego está activo)
              if (!_gameEnded)
                Positioned(
                  bottom: 24,
                  left: 24,
                  child: const GameVideoWidget(
                    videoType: GameVideoType.pensando,
                    width: 200,
                    height: 200,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final totalEmojis = _categories.fold<int>(
      0,
      (sum, category) => sum + category.correctEmojis.length,
    );
    final placedEmojis = _categories.fold<int>(
      0,
      (sum, category) => sum + category.placedEmojis.length,
    );

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
            : Colors.teal.shade700;

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Clasifica y Gana',
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Arrastra cada emoji a su categoría',
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
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
          // Progreso de emojis
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$placedEmojis/$totalEmojis',
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.teal.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryColumns() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;

        if (isWide) {
          // Desktop: fila de columnas
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _categories.asMap().entries.map((entry) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: _buildCategoryColumn(entry.key, entry.value),
                ),
              );
            }).toList(),
          );
        } else {
          // Móvil: columnas apiladas
          return Column(
            children: _categories.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCategoryColumn(entry.key, entry.value),
              );
            }).toList(),
          );
        }
      },
    );
  }

  Widget _buildCategoryColumn(int index, EmojiCategory category) {
    return DragTarget<String>(
      onWillAcceptWithDetails: (details) => category.isCorrectEmoji(details.data),
      onAcceptWithDetails: (details) => _onEmojiDrop(details.data, index),
      builder: (context, candidateData, rejectedData) {
        final isHovering = candidateData.isNotEmpty;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isHovering
                ? Colors.green.shade100
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isHovering ? Colors.green : Colors.white,
              width: 3,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // Título de la categoría
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    category.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      category.name,
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Barra de progreso
              LinearProgressIndicator(
                value: category.progress,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.teal.shade400),
                minHeight: 8,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(height: 8),
              Text(
                '${category.placedEmojis.length}/${category.correctEmojis.length}',
                style: GoogleFonts.fredoka(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 16),

              // Emojis colocados
              if (category.placedEmojis.isEmpty)
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: 2,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Arrastra aquí',
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ),
                )
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: category.placedEmojis.map((emoji) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.teal.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.teal.shade300,
                          width: 2,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                    );
                  }).toList(),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmojiBank() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.touch_app, color: Colors.teal, size: 28),
              const SizedBox(width: 8),
              Text(
                'Emojis para Clasificar',
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          if (_availableEmojis.isEmpty)
            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text(
                    '¡Todos los emojis clasificados!',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade700,
                    ),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: _availableEmojis.map((emoji) {
                return Draggable<String>(
                  data: emoji,
                  feedback: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 48),
                        ),
                      ),
                    ),
                  ),
                  childWhenDragging: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: TextStyle(
                          fontSize: 42,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                  ),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.teal.shade300,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        emoji,
                        style: const TextStyle(fontSize: 42),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}
