library;

/// Juego: Diseñador de Monstruos
///
/// Los niños crean monstruos únicos seleccionando diferentes características.
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

class DisenadorMonstruosGame extends StatefulWidget {
  const DisenadorMonstruosGame({super.key});

  @override
  State<DisenadorMonstruosGame> createState() => _DisenadorMonstruosGameState();
}

class _DisenadorMonstruosGameState extends State<DisenadorMonstruosGame> {
  final Random _random = Random();

  // Preguntas sobre características del monstruo
  final List<Map<String, dynamic>> _questions = [
    {
      'question': '¿Cuántos ojos tiene tu monstruo?',
      'options': ['1 👁️', '2 👀', '3 👁️👁️👁️', '5 👁️👁️👁️👁️👁️'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿De qué color es tu monstruo?',
      'options': ['Verde 🟢', 'Morado 🟣', 'Azul 🔵', 'Multicolor 🌈'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Cuántas patas tiene?',
      'options': ['2 patas 🦵🦵', '4 patas', '6 patas', '8 patas 🐙'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Qué come tu monstruo?',
      'options': ['Galletas 🍪', 'Estrellas ⭐', 'Flores 🌸', 'Pizza 🍕'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Cómo es su voz?',
      'options': ['Chillona 🎵', 'Grave 🔊', 'Musical 🎶', 'Silenciosa 🤫'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Qué tamaño tiene?',
      'options': ['Pequeño 🐜', 'Mediano 🐕', 'Grande 🐘', 'Gigante 🏔️'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Qué le gusta hacer?',
      'options': ['Bailar 💃', 'Cantar 🎤', 'Dormir 😴', 'Saltar 🦘'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Tiene cola?',
      'options': ['Larga 🦎', 'Corta', 'Esponjosa 🦊', 'No tiene'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Qué tipo de piel tiene?',
      'options': ['Peluda 🐻', 'Escamosa 🐍', 'Suave 🐰', 'Brillante ✨'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Cuántos brazos tiene?',
      'options': ['2 brazos', '4 brazos', '6 brazos', '10 brazos 🦑'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Qué poder especial tiene?',
      'options': ['Volar 🦅', 'Brillar 💫', 'Invisible 👻', 'Fuego 🔥'],
      'answer': 'cualquiera',
    },
    {
      'question': '¿Dónde vive tu monstruo?',
      'options': ['Cueva 🏔️', 'Nube ☁️', 'Océano 🌊', 'Bosque 🌲'],
      'answer': 'cualquiera',
    },
  ];

  Map<String, dynamic> _currentQuestion = {};
  List<String> _options = [];
  String? _selectedAnswer;

  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  bool _showFeedback = false;

  Timer? _gameTimer;
  int _timeRemaining = 60;

  final int _totalQuestions = 10;

  List<String> _monsterFeatures = [];

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
    final question = _questions[_random.nextInt(_questions.length)];
    setState(() {
      _currentQuestion = question;
      _options = List<String>.from(question['options'] as List);
      _options.shuffle();
      _showFeedback = false;
      _selectedAnswer = null;
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (_showFeedback) return;

    // En este juego, todas las respuestas son creativas y válidas
    setState(() {
      _selectedAnswer = selectedAnswer;
      _showFeedback = true;
      _questionsAnswered++;
      _correctAnswers++; // Todas las respuestas son correctas
      _consecutiveCorrect++;
      final bonusMultiplier = (_consecutiveCorrect / 3).floor() + 1;
      _currentScore += 10 * bonusMultiplier;

      // Guardar característica del monstruo
      _monsterFeatures.add(selectedAnswer);
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

  GameVideoType _getCurrentVideoType() {
    if (_showFeedback) {
      return GameVideoType.excelente;
    }
    return GameVideoType.pensando;
  }

  void _endGame() {
    _gameTimer?.cancel();

    final accuracy = _questionsAnswered > 0
        ? ((_correctAnswers / _questionsAnswered) * 100).round()
        : 0;

    context.push('/game-results', extra: {
      'gameId': 'disenador_monstruos',
      'gameName': 'Diseñador de Monstruos',
      'score': _currentScore,
      'questionsAnswered': _questionsAnswered,
      'correctAnswers': _correctAnswers,
      'accuracy': accuracy,
    });
  }

  Color _getOptionColor(String option) {
    if (!_showFeedback) {
      return Colors.white;
    }

    if (option == _selectedAnswer) {
      return Colors.green.shade100;
    }

    return Colors.white;
  }

  Color _getOptionBorderColor(String option) {
    if (!_showFeedback) {
      return Colors.orange.shade400;
    }

    if (option == _selectedAnswer) {
      return Colors.green;
    }

    return Colors.orange.shade400.withValues(alpha: 0.3);
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
      tween: Tween<double>(begin: 0, end: _showFeedback ? 1 : 0),
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
                '👾',
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
          'Diseña tu monstruo único',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
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
          child: Column(
            children: [
              Text(
                (_currentQuestion['question'] as String? ?? ''),
                style: GoogleFonts.fredoka(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              if (_monsterFeatures.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Tu monstruo hasta ahora:',
                        style: GoogleFonts.fredoka(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _monsterFeatures.join(' • '),
                        style: GoogleFonts.fredoka(
                          fontSize: 12,
                          color: Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
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
              width: 160,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
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
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                  textAlign: TextAlign.center,
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
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.green,
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 32,
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              _consecutiveCorrect >= 3
                  ? '¡Fantástico! Racha de $_consecutiveCorrect 🔥'
                  : '¡Genial elección! +${10 * ((_consecutiveCorrect / 3).floor() + 1)} puntos',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
