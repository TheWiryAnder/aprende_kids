library;

/// Juego: Inventor de Palabras
///
/// Los niños combinan sílabas o palabras para crear nuevas palabras inventadas.
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

class InventorPalabrasGame extends StatefulWidget {
  const InventorPalabrasGame({super.key});

  @override
  State<InventorPalabrasGame> createState() => _InventorPalabrasGameState();
}

class _InventorPalabrasGameState extends State<InventorPalabrasGame> {
  final Random _random = Random();

  // Fusiones de palabras con opciones creativas
  final List<Map<String, dynamic>> _wordFusions = [
    {
      'word1': 'Gato 🐱',
      'word2': 'Pez 🐟',
      'question': 'Gato 🐱 + Pez 🐟 = ?',
      'options': ['Gatopez', 'Pezgato', 'Gatún', 'Pezito'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Dragón 🐉',
      'word2': 'Mariposa 🦋',
      'question': 'Dragón 🐉 + Mariposa 🦋 = ?',
      'options': ['Dragoposa', 'Maridragón', 'Driposa', 'Maridrago'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Robot 🤖',
      'word2': 'Conejo 🐰',
      'question': 'Robot 🤖 + Conejo 🐰 = ?',
      'options': ['Robonejo', 'Conebot', 'Robito', 'Conejbot'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Estrella ⭐',
      'word2': 'Flor 🌸',
      'question': 'Estrella ⭐ + Flor 🌸 = ?',
      'options': ['Estreflor', 'Florella', 'Estrella', 'Florestrel'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Luna 🌙',
      'word2': 'Árbol 🌳',
      'question': 'Luna 🌙 + Árbol 🌳 = ?',
      'options': ['Lunárbol', 'Arboluna', 'Lunabol', 'Arbolún'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Cohete 🚀',
      'word2': 'Ballena 🐋',
      'question': 'Cohete 🚀 + Ballena 🐋 = ?',
      'options': ['Cohellena', 'Ballhete', 'Cohetena', 'Ballecoh'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Nube ☁️',
      'word2': 'Elefante 🐘',
      'question': 'Nube ☁️ + Elefante 🐘 = ?',
      'options': ['Nubelefante', 'Elefanube', 'Nubefante', 'Elenubo'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Arcoíris 🌈',
      'word2': 'Pulpo 🐙',
      'question': 'Arcoíris 🌈 + Pulpo 🐙 = ?',
      'options': ['Arcopulpo', 'Pulcoíris', 'Arcopu', 'Pulporis'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Diamante 💎',
      'word2': 'Tortuga 🐢',
      'question': 'Diamante 💎 + Tortuga 🐢 = ?',
      'options': ['Diamantuga', 'Tortumante', 'Diamatuga', 'Tortudiam'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Volcán 🌋',
      'word2': 'Pingüino 🐧',
      'question': 'Volcán 🌋 + Pingüino 🐧 = ?',
      'options': ['Volpingüino', 'Pingüicán', 'Volcagüino', 'Pinguolcán'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Unicornio 🦄',
      'word2': 'Cactus 🌵',
      'question': 'Unicornio 🦄 + Cactus 🌵 = ?',
      'options': ['Unicactus', 'Cactunio', 'Unicatus', 'Cactunicor'],
      'answer': 'cualquiera',
    },
    {
      'word1': 'Fantasma 👻',
      'word2': 'Abeja 🐝',
      'question': 'Fantasma 👻 + Abeja 🐝 = ?',
      'options': ['Fantabeja', 'Abejasma', 'Fantabeja', 'Abejantas'],
      'answer': 'cualquiera',
    },
  ];

  Map<String, dynamic> _currentFusion = {};
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
    final fusion = _wordFusions[_random.nextInt(_wordFusions.length)];
    setState(() {
      _currentFusion = fusion;
      _options = List<String>.from(fusion['options'] as List);
      _options.shuffle();
      _showFeedback = false;
      _selectedAnswer = null;
    });
  }

  void _checkAnswer(String selectedAnswer) {
    if (_showFeedback) return;

    // En este juego, todas las respuestas creativas son válidas
    setState(() {
      _selectedAnswer = selectedAnswer;
      _showFeedback = true;
      _questionsAnswered++;
      _correctAnswers++; // Todas las respuestas son correctas
      _consecutiveCorrect++;
      final bonusMultiplier = (_consecutiveCorrect / 3).floor() + 1;
      _currentScore += 10 * bonusMultiplier;
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
      'gameId': 'inventor_palabras',
      'gameName': 'Inventor de Palabras',
      'score': _currentScore,
      'questionsAnswered': _questionsAnswered,
      'correctAnswers': _correctAnswers,
      'accuracy': accuracy,
    });
  }

  GameVideoType _getCurrentVideoType() {
    if (_showFeedback) {
      return GameVideoType.excelente; // Todas las respuestas son correctas
    }
    return GameVideoType.pensando;
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
                '💡',
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
          'Inventa una nueva palabra fusionando',
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
          child: Column(
            children: [
              Text(
                (_currentFusion['word1'] as String? ?? ''),
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '+',
                style: GoogleFonts.fredoka(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                (_currentFusion['word2'] as String? ?? ''),
                style: GoogleFonts.fredoka(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '=',
                style: GoogleFonts.fredoka(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '?',
                style: GoogleFonts.fredoka(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade600,
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
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
              decoration: BoxDecoration(
                border: Border.all(
                  color: _getOptionBorderColor(option),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                option,
                style: GoogleFonts.fredoka(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
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
      child: Column(
        children: [
          Row(
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
                      ? '¡Inventor increíble! Racha de $_consecutiveCorrect 🔥'
                      : '¡Palabra genial! +${10 * ((_consecutiveCorrect / 3).floor() + 1)} puntos',
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '¡Tu nueva palabra inventada es: $_selectedAnswer! 💡',
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.orange.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
