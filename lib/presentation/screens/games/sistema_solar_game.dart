library;

/// Sistema Solar - Juego educativo sobre el sistema solar
///
/// Los niños aprenden sobre planetas, sus características y el sistema solar.
///
/// Características:
/// - 12 preguntas sobre el sistema solar
/// - Opción múltiple con emojis visuales
/// - Feedback visual inmediato
/// - Sistema de puntuación con penalizaciones (-10 puntos, juego más difícil)
///
/// Autor: Sistema Educativo
/// Fecha: 2025

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/game_video_widget.dart';

class SistemaSolarGame extends StatefulWidget {
  const SistemaSolarGame({super.key});

  @override
  State<SistemaSolarGame> createState() => _SistemaSolarGameState();
}

class _SistemaSolarGameState extends State<SistemaSolarGame> {
  final Random _random = Random();

  // Banco de preguntas sobre el sistema solar
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuál es el planeta más grande del sistema solar?',
      'options': ['Júpiter 🪐', 'Saturno 🪐', 'Tierra 🌍', 'Marte 🔴'],
      'correct': 0,
    },
    {
      'question': '¿Cuál es el planeta más cercano al Sol?',
      'options': ['Venus 🌕', 'Mercurio ☿️', 'Tierra 🌍', 'Marte 🔴'],
      'correct': 1,
    },
    {
      'question': '¿Qué planeta es conocido como el "planeta rojo"?',
      'options': ['Venus 🌕', 'Júpiter 🪐', 'Marte 🔴', 'Saturno 🪐'],
      'correct': 2,
    },
    {
      'question': '¿Cuál es la estrella más cercana a la Tierra?',
      'options': ['La Luna 🌙', 'El Sol ☀️', 'Marte 🔴', 'Venus 🌕'],
      'correct': 1,
    },
    {
      'question': '¿Qué planeta tiene anillos visibles?',
      'options': ['Tierra 🌍', 'Marte 🔴', 'Saturno 🪐', 'Venus 🌕'],
      'correct': 2,
    },
    {
      'question': '¿Cuántos planetas hay en el sistema solar?',
      'options': ['Siete 7️⃣', 'Ocho 8️⃣', 'Nueve 9️⃣', 'Diez 🔟'],
      'correct': 1,
    },
    {
      'question': '¿Qué planeta está más lejos del Sol?',
      'options': ['Urano 🔵', 'Saturno 🪐', 'Neptuno 🔵', 'Júpiter 🪐'],
      'correct': 2,
    },
    {
      'question': '¿Qué es la Luna?',
      'options': [
        'Un planeta 🌍',
        'Una estrella ⭐',
        'Un satélite natural 🌙',
        'Un cometa ☄️'
      ],
      'correct': 2,
    },
    {
      'question': '¿Cuánto tarda la Tierra en dar la vuelta al Sol?',
      'options': [
        'Un mes 📅',
        'Un año 📆',
        'Una semana 🗓️',
        'Un día ☀️'
      ],
      'correct': 1,
    },
    {
      'question': '¿Qué planeta es el más pequeño del sistema solar?',
      'options': ['Marte 🔴', 'Mercurio ☿️', 'Venus 🌕', 'Tierra 🌍'],
      'correct': 1,
    },
    {
      'question': '¿Qué planeta tiene la Gran Mancha Roja?',
      'options': ['Júpiter 🪐', 'Saturno 🪐', 'Marte 🔴', 'Neptuno 🔵'],
      'correct': 0,
    },
    {
      'question': '¿Cuál es el único planeta donde existe vida conocida?',
      'options': ['Marte 🔴', 'Venus 🌕', 'Tierra 🌍', 'Júpiter 🪐'],
      'correct': 2,
    },
  ];

  List<Map<String, dynamic>> _gameQuestions = [];
  int _currentQuestionIndex = 0;
  Map<String, dynamic> _currentQuestion = {};

  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  bool _showFeedback = false;
  bool _isCorrect = false;
  int? _selectedAnswer;

  Timer? _gameTimer;
  int _timeRemaining = 60;

  final int _totalQuestions = 10;

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _startTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }

  void _initializeGame() {
    _gameQuestions = List.from(_questions)..shuffle(_random);
    _gameQuestions = _gameQuestions.take(_totalQuestions).toList();
    _loadQuestion();
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

  void _loadQuestion() {
    if (_currentQuestionIndex < _gameQuestions.length) {
      setState(() {
        _currentQuestion = _gameQuestions[_currentQuestionIndex];
        _showFeedback = false;
        _selectedAnswer = null;
      });
    } else {
      _endGame();
    }
  }

  void _checkAnswer(int selectedIndex) {
    if (_showFeedback) return;

    setState(() {
      _selectedAnswer = selectedIndex;
      _isCorrect = selectedIndex == (_currentQuestion['correct'] as int);
      _showFeedback = true;
      _questionsAnswered++;

      if (_isCorrect) {
        _correctAnswers++;
        _consecutiveCorrect++;

        int basePoints = 10;
        int timeBonus = (_timeRemaining / 10).floor() * 2;
        int streakBonus = (_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 5 : 0;

        _currentScore += basePoints + timeBonus + streakBonus;
      } else {
        _consecutiveCorrect = 0;
        // Penalización más alta porque es el juego más difícil
        _currentScore = (_currentScore - 10).clamp(0, double.infinity).toInt();
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _currentQuestionIndex++;
        _loadQuestion();
      }
    });
  }

  void _endGame() {
    _gameTimer?.cancel();

    final accuracy = _questionsAnswered > 0
        ? ((_correctAnswers / _questionsAnswered) * 100).round()
        : 0;

    context.push('/game-results', extra: {
      'gameId': 'sistema_solar',
      'gameName': 'Sistema Solar',
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

  Color _getOptionColor(int index) {
    if (!_showFeedback) {
      return Colors.white;
    }

    if (index == _selectedAnswer) {
      return _isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    }

    if (index == (_currentQuestion['correct'] as int) && !_isCorrect) {
      return Colors.green.shade100;
    }

    return Colors.white;
  }

  Color _getOptionBorderColor(int index) {
    if (!_showFeedback) {
      return Colors.green.shade400;
    }

    if (index == _selectedAnswer) {
      return _isCorrect ? Colors.green : Colors.red;
    }

    if (index == (_currentQuestion['correct'] as int) && !_isCorrect) {
      return Colors.green;
    }

    return Colors.green.shade400.withValues(alpha: 0.3);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showVideo = screenWidth > 600;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green.shade400,
              Colors.green.shade600,
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
                  color: _timeRemaining <= 10 ? Colors.white : Colors.green.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_timeRemaining}s',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _timeRemaining <= 10 ? Colors.white : Colors.green.shade700,
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
                    color: Colors.green.shade700,
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
              color: Colors.green.shade100,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '🚀',
                style: TextStyle(fontSize: 60),
              ),
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
          'Pregunta ${_currentQuestionIndex + 1} de $_totalQuestions',
          style: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.orange.shade300,
              width: 1,
            ),
          ),
          child: Text(
            '🌟 Nivel Avanzado',
            style: GoogleFonts.fredoka(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.orange.shade900,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _currentQuestion['question'] as String? ?? '',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildOptions() {
    final options = _currentQuestion['options'] as List<dynamic>? ?? [];

    return Column(
      children: List.generate(options.length, (index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Material(
            color: _getOptionColor(index),
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: _showFeedback ? null : () => _checkAnswer(index),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: _getOptionBorderColor(index),
                    width: 3,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  options[index] as String,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        );
      }),
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
                  ? '¡Excelente! +${10 + (_timeRemaining / 10).floor() * 2 + ((_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 5 : 0)} puntos'
                  : 'Respuesta incorrecta. -10 puntos',
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
