library;

/// Juego: Completa el Patrón
///
/// Los niños identifican y completan patrones visuales con formas y colores.
/// Sistema de puntuación con penalizaciones por errores.
///
/// Autor: Sistema Educativo
/// Fecha: 2025

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/game_video_widget.dart';

class CompletaPatronGame extends StatefulWidget {
  const CompletaPatronGame({super.key});

  @override
  State<CompletaPatronGame> createState() => _CompletaPatronGameState();
}

class _CompletaPatronGameState extends State<CompletaPatronGame> {
  final Random _random = Random();

  // Patrones diferentes
  final List<Map<String, dynamic>> _patterns = [
    {'pattern': ['🔴', '🔵', '🔴', '🔵', '🔴'], 'answer': '🔵', 'options': ['🔵', '🔴', '🟡', '🟢']},
    {'pattern': ['⭐', '🌙', '⭐', '🌙', '⭐'], 'answer': '🌙', 'options': ['🌙', '⭐', '☀️', '🌟']},
    {'pattern': ['🟢', '🟡', '🔴', '🟢', '🟡'], 'answer': '🔴', 'options': ['🔴', '🟢', '🟡', '🔵']},
    {'pattern': ['🔺', '🔵', '🔺', '🔵', '🔺'], 'answer': '🔵', 'options': ['🔵', '🔺', '🟢', '🔴']},
    {'pattern': ['🐶', '🐱', '🐶', '🐱', '🐶'], 'answer': '🐱', 'options': ['🐱', '🐶', '🐭', '🐰']},
    {'pattern': ['🍎', '🍊', '🍎', '🍊', '🍎'], 'answer': '🍊', 'options': ['🍊', '🍎', '🍌', '🍇']},
    {'pattern': ['❤️', '💙', '💚', '❤️', '💙'], 'answer': '💚', 'options': ['💚', '❤️', '💙', '💛']},
    {'pattern': ['🌸', '🌺', '🌸', '🌺', '🌸'], 'answer': '🌺', 'options': ['🌺', '🌸', '🌻', '🌷']},
    {'pattern': ['⚽', '🏀', '⚾', '⚽', '🏀'], 'answer': '⚾', 'options': ['⚾', '⚽', '🏀', '🎾']},
    {'pattern': ['🎈', '🎁', '🎈', '🎁', '🎈'], 'answer': '🎁', 'options': ['🎁', '🎈', '🎀', '🎊']},
    {'pattern': ['🦋', '🐝', '🦋', '🐝', '🦋'], 'answer': '🐝', 'options': ['🐝', '🦋', '🐞', '🦗']},
    {'pattern': ['🚗', '🚙', '🚗', '🚙', '🚗'], 'answer': '🚙', 'options': ['🚙', '🚗', '🚕', '🚌']},
  ];

  Map<String, dynamic> _currentPattern = {};
  String _correctAnswer = '';
  List<String> _options = [];

  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  bool _showFeedback = false;
  bool _isCorrect = false;
  String? _selectedAnswer;

  Timer? _gameTimer;
  int _timeRemaining = 60;

  final int _totalQuestions = 10;

  @override
  void initState() {
    super.initState();
    _generateProblem();
    _startTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_timeRemaining > 0) {
            _timeRemaining--;
          } else {
            _endGame();
          }
        });
      }
    });
  }

  void _generateProblem() {
    final pattern = _patterns[_random.nextInt(_patterns.length)];
    setState(() {
      _currentPattern = pattern;
      _correctAnswer = pattern['answer'] as String;
      _options = List<String>.from(pattern['options'] as List);
      _options.shuffle();
      _showFeedback = false;
      _selectedAnswer = null;
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (_showFeedback) return;

    final isCorrect = selectedAnswer == _correctAnswer;

    setState(() {
      _selectedAnswer = selectedAnswer;
      _showFeedback = true;
      _isCorrect = isCorrect;
      _questionsAnswered++;

      if (isCorrect) {
        _correctAnswers++;
        _consecutiveCorrect++;
        final bonusMultiplier = (_consecutiveCorrect / 3).floor() + 1;
        _currentScore += 10 * bonusMultiplier;
      } else {
        _consecutiveCorrect = 0;
        _currentScore = max(0, _currentScore - 6);
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        if (_questionsAnswered >= _totalQuestions) {
          _endGame();
        } else {
          _generateProblem();
        }
      }
    });
  }

  void _endGame() {
    _gameTimer?.cancel();

    final accuracy = _questionsAnswered > 0
        ? ((_correctAnswers / _questionsAnswered) * 100).round()
        : 0;

    context.push('/game-results', extra: {
      'gameId': 'completa_patron',
      'gameName': 'Completa el Patrón',
      'score': _currentScore,
      'questionsAnswered': _questionsAnswered,
      'correctAnswers': _correctAnswers,
      'accuracy': accuracy,
    });
  }

  GameVideoType _getCurrentVideoType() {
    if (_showFeedback) {
      return _isCorrect ? GameVideoType.excelente : GameVideoType.intentalo;
    }
    return GameVideoType.pensando;
  }

  Color _getOptionColor(String option) {
    if (!_showFeedback) {
      return Colors.white;
    }

    if (option == _selectedAnswer) {
      return _isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    }

    if (option == _correctAnswer && !_isCorrect) {
      return Colors.green.shade100;
    }

    return Colors.white;
  }

  Color _getOptionBorderColor(String option) {
    if (!_showFeedback) {
      return Colors.orange.shade400;
    }

    if (option == _selectedAnswer) {
      return _isCorrect ? Colors.green : Colors.red;
    }

    if (option == _correctAnswer && !_isCorrect) {
      return Colors.green;
    }

    return Colors.orange.shade400.withValues(alpha: 0.3);
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
              Colors.orange.shade400,
              Colors.orange.shade600,
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
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () {
              showDialog<void>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Salir del juego', style: GoogleFonts.fredoka()),
                  content: Text(
                    '¿Estás seguro de que quieres salir? Perderás tu progreso.',
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
                  color: _timeRemaining <= 10 ? Colors.white : Colors.orange.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_timeRemaining}s',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _timeRemaining <= 10 ? Colors.white : Colors.orange.shade700,
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
                    color: Colors.orange.shade700,
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
              color: Colors.orange.shade100,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🧩',
                style: TextStyle(fontSize: 60),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProblem() {
    final pattern = _currentPattern['pattern'] as List<dynamic>? ?? [];

    return Column(
      children: [
        Text(
          '¿Qué sigue en el patrón?',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.orange.shade200,
              width: 2,
            ),
          ),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              ...pattern.map((emoji) => Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.shade300,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    emoji as String,
                    style: const TextStyle(fontSize: 36),
                  ),
                ),
              )),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.orange.shade400,
                    width: 3,
                  ),
                ),
                child: Center(
                  child: Text(
                    '?',
                    style: GoogleFonts.fredoka(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: 12,
      runSpacing: 12,
      children: _options.map((option) {
        return Material(
          color: _getOptionColor(option),
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: _showFeedback ? null : () => _checkAnswer(option),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _getOptionBorderColor(option),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(
                  option,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFeedback() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(16),
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
            size: 32,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              _isCorrect
                  ? (_consecutiveCorrect >= 3
                      ? '¡Increíble! Racha de $_consecutiveCorrect 🔥'
                      : '¡Excelente! +${10 * ((_consecutiveCorrect / 3).floor() + 1)} puntos')
                  : 'Intenta de nuevo. La respuesta era $_correctAnswer. -6 puntos',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: _isCorrect ? Colors.green.shade700 : Colors.red.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
