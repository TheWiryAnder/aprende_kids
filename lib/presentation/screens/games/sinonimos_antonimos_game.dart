library;

/// Juego: Sinónimos y Antónimos
///
/// Los niños deben identificar sinónimos o antónimos de palabras dadas.
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

class SinonimosAntonimosGame extends StatefulWidget {
  const SinonimosAntonimosGame({super.key});

  @override
  State<SinonimosAntonimosGame> createState() => _SinonimosAntonimosGameState();
}

class _SinonimosAntonimosGameState extends State<SinonimosAntonimosGame> {
  final Random _random = Random();

  // Palabras con sus sinónimos y antónimos
  final List<Map<String, dynamic>> _words = [
    {
      'word': 'FELIZ',
      'emoji': '😊',
      'synonym': 'ALEGRE',
      'antonym': 'TRISTE',
    },
    {
      'word': 'GRANDE',
      'emoji': '🐘',
      'synonym': 'ENORME',
      'antonym': 'PEQUEÑO',
    },
    {
      'word': 'RÁPIDO',
      'emoji': '🏃',
      'synonym': 'VELOZ',
      'antonym': 'LENTO',
    },
    {
      'word': 'BONITO',
      'emoji': '🌺',
      'synonym': 'HERMOSO',
      'antonym': 'FEO',
    },
    {
      'word': 'CALIENTE',
      'emoji': '🔥',
      'synonym': 'ARDIENTE',
      'antonym': 'FRÍO',
    },
    {
      'word': 'FUERTE',
      'emoji': '💪',
      'synonym': 'PODEROSO',
      'antonym': 'DÉBIL',
    },
    {
      'word': 'ALTO',
      'emoji': '🦒',
      'synonym': 'ELEVADO',
      'antonym': 'BAJO',
    },
    {
      'word': 'NUEVO',
      'emoji': '✨',
      'synonym': 'RECIENTE',
      'antonym': 'VIEJO',
    },
    {
      'word': 'CLARO',
      'emoji': '💡',
      'synonym': 'BRILLANTE',
      'antonym': 'OSCURO',
    },
    {
      'word': 'FÁCIL',
      'emoji': '😌',
      'synonym': 'SENCILLO',
      'antonym': 'DIFÍCIL',
    },
    {
      'word': 'LIMPIO',
      'emoji': '✨',
      'synonym': 'PULCRO',
      'antonym': 'SUCIO',
    },
    {
      'word': 'LLENO',
      'emoji': '🥛',
      'synonym': 'COMPLETO',
      'antonym': 'VACÍO',
    },
    {
      'word': 'DULCE',
      'emoji': '🍭',
      'synonym': 'AZUCARADO',
      'antonym': 'AMARGO',
    },
    {
      'word': 'RICO',
      'emoji': '💰',
      'synonym': 'ADINERADO',
      'antonym': 'POBRE',
    },
    {
      'word': 'VALIENTE',
      'emoji': '🦁',
      'synonym': 'CORAJUDO',
      'antonym': 'COBARDE',
    },
  ];

  String _currentWord = '';
  String _currentEmoji = '';
  String _correctAnswer = '';
  String _questionType = ''; // 'synonym' or 'antonym'
  List<Map<String, String>> _options = [];
  int _correctOptionIndex = -1;

  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  bool _showFeedback = false;
  bool _isCorrect = false;
  String _feedbackMessage = '';

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
    final wordData = _words[_random.nextInt(_words.length)];
    final isSynonym = _random.nextBool();

    // Create options
    final correctAnswer = isSynonym
        ? wordData['synonym'] as String
        : wordData['antonym'] as String;

    // Get other random words as distractors
    final allWords = _words.where((w) => w['word'] != wordData['word']).toList();
    allWords.shuffle(_random);

    final options = <Map<String, String>>[
      {'word': correctAnswer, 'isCorrect': 'true'},
    ];

    // Add two distractors
    for (int i = 0; i < 2 && i < allWords.length; i++) {
      final distractor = isSynonym
          ? allWords[i]['synonym'] as String
          : allWords[i]['antonym'] as String;
      options.add({'word': distractor, 'isCorrect': 'false'});
    }

    options.shuffle(_random);

    setState(() {
      _currentWord = wordData['word'] as String;
      _currentEmoji = wordData['emoji'] as String;
      _correctAnswer = correctAnswer;
      _questionType = isSynonym ? 'synonym' : 'antonym';
      _options = options;
      _correctOptionIndex = options.indexWhere((opt) => opt['isCorrect'] == 'true');
      _showFeedback = false;
    });
  }

  void _selectOption(int index) {
    if (_showFeedback) return;

    final isCorrect = index == _correctOptionIndex;

    setState(() {
      _showFeedback = true;
      _isCorrect = isCorrect;
      _questionsAnswered++;

      if (isCorrect) {
        _correctAnswers++;
        _consecutiveCorrect++;
        final bonusMultiplier = (_consecutiveCorrect / 3).floor() + 1;
        _currentScore += 10 * bonusMultiplier;
        _feedbackMessage = _consecutiveCorrect >= 3
            ? '¡Increíble! Racha de $_consecutiveCorrect 🔥'
            : '¡Excelente! +${10 * bonusMultiplier} puntos';
      } else {
        _consecutiveCorrect = 0;
        _currentScore = max(0, _currentScore - 8);
        _feedbackMessage = 'Intenta de nuevo. -8 puntos';
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
      'gameId': 'sinonimos_antonimos',
      'gameName': 'Sinónimos y Antónimos',
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
              Colors.red.shade400,
              Colors.red.shade600,
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
                  color: _timeRemaining <= 10 ? Colors.white : Colors.red.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_timeRemaining}s',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _timeRemaining <= 10 ? Colors.white : Colors.red.shade700,
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
                    color: Colors.red.shade700,
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
              color: Colors.red.shade100,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                '📚',
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
          _questionType == 'synonym'
              ? 'Encuentra el SINÓNIMO de:'
              : 'Encuentra el ANTÓNIMO de:',
          style: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _questionType == 'synonym'
                ? Colors.blue.shade50
                : Colors.orange.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _questionType == 'synonym'
                  ? Colors.blue.shade300
                  : Colors.orange.shade300,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Text(
                _currentEmoji,
                style: const TextStyle(fontSize: 60),
              ),
              const SizedBox(height: 12),
              Text(
                _currentWord,
                style: GoogleFonts.fredoka(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: _questionType == 'synonym'
                      ? Colors.blue.shade700
                      : Colors.orange.shade700,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      children: List.generate(
        _options.length,
        (index) {
          final option = _options[index];
          final isCorrect = index == _correctOptionIndex;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () => _selectOption(index),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _showFeedback
                      ? (isCorrect ? Colors.green.shade100 : Colors.white)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: _showFeedback
                        ? (isCorrect ? Colors.green : Colors.grey.shade300)
                        : Colors.grey.shade300,
                    width: _showFeedback && isCorrect ? 3 : 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        option['word'] ?? '',
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: _showFeedback && isCorrect
                              ? Colors.green.shade700
                              : Colors.grey.shade700,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (_showFeedback && isCorrect)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 32,
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
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
      child: Column(
        children: [
          Row(
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
                  _feedbackMessage,
                  style: GoogleFonts.fredoka(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: _isCorrect ? Colors.green.shade700 : Colors.red.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          if (!_isCorrect) ...[
            const SizedBox(height: 8),
            Text(
              'Respuesta correcta: $_correctAnswer',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
