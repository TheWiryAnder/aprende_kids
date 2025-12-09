library;

/// Números Perdidos - Juego de secuencias numéricas para niños de 7-10 años
///
/// Este juego presenta secuencias numéricas con un número faltante que
/// el niño debe identificar. Ayuda a desarrollar el pensamiento lógico
/// y el reconocimiento de patrones.
///
/// Características:
/// - Secuencias visuales con emojis numerados
/// - Patrones de suma, resta o saltos
/// - Sistema de puntuación con penalizaciones
/// - Dificultad adaptativa
///
/// Autor: [Tu nombre]
/// Fecha: 2025

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/colors.dart';
import '../../widgets/game_video_widget.dart';

class NumerosPerdidosGame extends StatefulWidget {
  const NumerosPerdidosGame({super.key});

  @override
  State<NumerosPerdidosGame> createState() => _NumerosPerdidosGameState();
}

class _NumerosPerdidosGameState extends State<NumerosPerdidosGame> {
  final Random _random = Random();

  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  List<int?> _sequence = []; // Secuencia con null en la posición faltante
  int _missingIndex = 0;
  int _correctAnswer = 0;
  List<int> _options = [];
  String _patternType = '+1'; // Tipo de patrón

  final List<String> _emojis = [
    '🔢', '🎯', '🎪', '🎨', '🎭', '🎬', '🎤', '🎧',
    '🎮', '🎲', '🎰', '🃏', '🎴', '🧩'
  ];

  Timer? _gameTimer;
  int _timeRemaining = 60;

  bool _showFeedback = false;
  bool _isCorrect = false;
  int? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    _generateNewProblem();
    _startTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_timeRemaining > 0) {
          _timeRemaining--;
        } else {
          _endGame();
        }
      });
    });
  }

  void _generateNewProblem() {
    setState(() {
      // Definir patrones según dificultad
      List<String> patterns = ['+1', '+2', '-1'];

      if (_correctAnswers >= 3) patterns.add('+3');
      if (_correctAnswers >= 5) patterns.add('+5');
      if (_correctAnswers >= 8) patterns.add('+10');

      _patternType = patterns[_random.nextInt(patterns.length)];

      // Generar secuencia
      int startNum = _random.nextInt(20) + 1;
      int step = _getStepFromPattern(_patternType);

      _sequence = [];
      for (int i = 0; i < 5; i++) {
        _sequence.add(startNum + (step * i));
      }

      // Elegir posición aleatoria para el número faltante (no el primero)
      _missingIndex = _random.nextInt(4) + 1;
      _correctAnswer = _sequence[_missingIndex]!;
      _sequence[_missingIndex] = null;

      _options = _generateOptions(_correctAnswer);
      _options.shuffle();

      _showFeedback = false;
      _selectedAnswer = null;
    });
  }

  int _getStepFromPattern(String pattern) {
    switch (pattern) {
      case '+1': return 1;
      case '+2': return 2;
      case '+3': return 3;
      case '+5': return 5;
      case '+10': return 10;
      case '-1': return -1;
      default: return 1;
    }
  }

  List<int> _generateOptions(int correct) {
    List<int> options = [correct];

    while (options.length < 4) {
      int offset = _random.nextInt(9) - 4; // -4 a +4
      if (offset == 0) offset = 5;

      int wrongAnswer = correct + offset;
      if (wrongAnswer > 0 && !options.contains(wrongAnswer)) {
        options.add(wrongAnswer);
      }
    }

    return options;
  }

  void _checkAnswer(int selectedAnswer) {
    if (_showFeedback) return;

    setState(() {
      _selectedAnswer = selectedAnswer;
      _isCorrect = selectedAnswer == _correctAnswer;
      _showFeedback = true;
      _questionsAnswered++;

      if (_isCorrect) {
        _correctAnswers++;
        _consecutiveCorrect++;

        int basePoints = 12;
        int timeBonus = (_timeRemaining / 10).floor() * 3;
        int streakBonus = (_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 6 : 0;

        _currentScore += basePoints + timeBonus + streakBonus;
      } else {
        _consecutiveCorrect = 0;
        _currentScore = (_currentScore - 6).clamp(0, double.infinity).toInt();
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _generateNewProblem();
      }
    });
  }

  void _endGame() {
    _gameTimer?.cancel();

    context.push('/game-results', extra: {
      'gameId': 'numeros_perdidos',
      'gameName': 'Números Perdidos',
      'score': _currentScore,
      'questionsAnswered': _questionsAnswered,
      'correctAnswers': _correctAnswers,
      'accuracy': _questionsAnswered > 0
          ? ((_correctAnswers / _questionsAnswered) * 100).round()
          : 0,
    });
  }

  GameVideoType _getCurrentVideoType() {
    if (_showFeedback) {
      return _isCorrect ? GameVideoType.excelente : GameVideoType.intentalo;
    }
    return GameVideoType.pensando;
  }

  Color _getOptionColor(int option) {
    if (!_showFeedback) return Colors.white;
    if (option == _selectedAnswer) {
      return _isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    }
    if (option == _correctAnswer && !_isCorrect) {
      return Colors.green.shade100;
    }
    return Colors.white;
  }

  Color _getOptionBorderColor(int option) {
    if (!_showFeedback) return AppColors.mathColor;
    if (option == _selectedAnswer) {
      return _isCorrect ? Colors.green : Colors.red;
    }
    if (option == _correctAnswer && !_isCorrect) {
      return Colors.green;
    }
    return AppColors.mathColor.withValues(alpha: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showVideo = screenWidth > 600; // Mostrar en tablet y desktop

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade700,
              Colors.purple.shade400,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video en la izquierda (tablet y desktop)
                    if (showVideo)
                      Container(
                        width: 450,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return GameVideoWidget(
                                    videoType: _getCurrentVideoType(),
                                    width: 400,
                                    height: constraints.maxHeight,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Contenido del juego
                    Expanded(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Container(
                            margin: const EdgeInsets.all(16),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 16),
                                  _buildCharacter(),
                                  const SizedBox(height: 20),
                                  _buildProblem(),
                                  const SizedBox(height: 20),
                                  _buildOptions(),
                                  const SizedBox(height: 16),
                                  if (_showFeedback) _buildFeedback(),
                                  const SizedBox(height: 16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(
                    '¿Salir del juego?',
                    style: GoogleFonts.fredoka(fontWeight: FontWeight.w600),
                  ),
                  content: Text(
                    'Perderás tu progreso actual',
                    style: GoogleFonts.fredoka(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('Cancelar', style: GoogleFonts.fredoka()),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        context.pop();
                      },
                      child: Text('Salir', style: GoogleFonts.fredoka()),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _timeRemaining <= 10 ? Colors.red : Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.timer,
                  size: 20,
                  color: _timeRemaining <= 10 ? Colors.white : Colors.purple.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_timeRemaining}s',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _timeRemaining <= 10 ? Colors.white : Colors.purple.shade700,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (_consecutiveCorrect > 1)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.local_fire_department, size: 20, color: Colors.white),
                  const SizedBox(width: 4),
                  Text(
                    '${_consecutiveCorrect}x',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(width: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                const Icon(Icons.star, size: 20, color: Colors.amber),
                const SizedBox(width: 6),
                Text(
                  '$_currentScore',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacter() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 500),
      tween: Tween<double>(begin: 0, end: _showFeedback && _isCorrect ? 1 : 0),
      builder: (context, double value, child) {
        return Transform.scale(
          scale: 1 + (value * 0.2),
          child: Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.purple.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.help_outline,
              size: 60,
              color: Colors.purple.shade700,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProblem() {
    return Column(
      children: [
        Text(
          '¿Qué número falta?',
          style: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 24),

        // Mostrar secuencia
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_sequence.length, (index) {
              final num = _sequence[index];
              final isMissing = num == null;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 105,
                      decoration: BoxDecoration(
                        color: isMissing
                            ? Colors.purple.shade50
                            : Colors.purple.shade100,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isMissing
                              ? Colors.purple.shade400
                              : Colors.purple.shade300,
                          width: isMissing ? 3 : 2,
                        ),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _emojis[index % _emojis.length],
                              style: const TextStyle(fontSize: 30),
                            ),
                            const SizedBox(height: 4),
                            if (isMissing)
                              Text(
                                '?',
                                style: GoogleFonts.fredoka(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                              )
                            else
                              Text(
                                '$num',
                                style: GoogleFonts.fredoka(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.purple.shade700,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (index < _sequence.length - 1)
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.purple.shade300,
                        size: 20,
                      ),
                  ],
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: _options.map((option) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Material(
              color: _getOptionColor(option),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                onTap: _showFeedback ? null : () => _checkAnswer(option),
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 100,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _getOptionBorderColor(option),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '$option',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade700,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildFeedback() {
    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isCorrect ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isCorrect ? Icons.check_circle : Icons.cancel,
                  color: _isCorrect ? Colors.green : Colors.red,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    _isCorrect
                        ? '¡Lo encontraste! +${12 + (_timeRemaining / 10).floor() * 3 + ((_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 6 : 0)} puntos'
                        : '¡Ups! Era $_correctAnswer (-6 puntos)',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isCorrect ? Colors.green.shade900 : Colors.red.shade900,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
