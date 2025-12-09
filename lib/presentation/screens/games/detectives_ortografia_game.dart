library;

/// Juego: Detectives de Ortografía
///
/// Los niños deben encontrar y corregir errores ortográficos en oraciones.
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

class DetectivesOrtografiaGame extends StatefulWidget {
  const DetectivesOrtografiaGame({super.key});

  @override
  State<DetectivesOrtografiaGame> createState() => _DetectivesOrtografiaGameState();
}

class _DetectivesOrtografiaGameState extends State<DetectivesOrtografiaGame> {
  final Random _random = Random();

  // Oraciones con errores ortográficos
  final List<Map<String, dynamic>> _sentences = [
    {
      'words': ['El', 'niño', 'juega', 'con', 'su', 'balón', 'en', 'el', 'parqe'],
      'emoji': '⚽',
      'errorIndex': 8,
      'correct': 'parque'
    },
    {
      'words': ['La', 'niña', 'lee', 'un', 'lbro', 'en', 'la', 'biblioteca'],
      'emoji': '📚',
      'errorIndex': 4,
      'correct': 'libro'
    },
    {
      'words': ['Mi', 'perro', 'es', 'mui', 'juguetón', 'y', 'alegre'],
      'emoji': '🐕',
      'errorIndex': 3,
      'correct': 'muy'
    },
    {
      'words': ['El', 'gato', 'duerme', 'en', 'el', 'sofa', 'grande'],
      'emoji': '🐱',
      'errorIndex': 5,
      'correct': 'sofá'
    },
    {
      'words': ['Voy', 'a', 'la', 'escuela', 'todos', 'los', 'dias'],
      'emoji': '🏫',
      'errorIndex': 6,
      'correct': 'días'
    },
    {
      'words': ['Me', 'gusta', 'comer', 'manzanas', 'rojas', 'y', 'jugosas'],
      'emoji': '🍎',
      'errorIndex': -1,
      'correct': ''
    },
    {
      'words': ['El', 'sol', 'brilla', 'en', 'el', 'zielo', 'azul'],
      'emoji': '☀️',
      'errorIndex': 5,
      'correct': 'cielo'
    },
    {
      'words': ['La', 'mariposa', 'buela', 'sobre', 'las', 'flores'],
      'emoji': '🦋',
      'errorIndex': 2,
      'correct': 'vuela'
    },
    {
      'words': ['Tengo', 'un', 'lapiz', 'para', 'escribir'],
      'emoji': '✏️',
      'errorIndex': 2,
      'correct': 'lápiz'
    },
    {
      'words': ['El', 'pajaro', 'canta', 'en', 'el', 'árbol'],
      'emoji': '🐦',
      'errorIndex': 1,
      'correct': 'pájaro'
    },
    {
      'words': ['Mi', 'mamá', 'cocina', 'rico', 'en', 'la', 'cosina'],
      'emoji': '👩‍🍳',
      'errorIndex': 6,
      'correct': 'cocina'
    },
    {
      'words': ['El', 'arbol', 'tiene', 'muchas', 'hojas', 'verdes'],
      'emoji': '🌳',
      'errorIndex': 1,
      'correct': 'árbol'
    },
    {
      'words': ['Juego', 'con', 'mis', 'amigos', 'en', 'el', 'jardin'],
      'emoji': '🌺',
      'errorIndex': 6,
      'correct': 'jardín'
    },
    {
      'words': ['El', 'cajon', 'está', 'lleno', 'de', 'juguetes'],
      'emoji': '📦',
      'errorIndex': 1,
      'correct': 'cajón'
    },
    {
      'words': ['Voy', 'a', 'visitar', 'a', 'mi', 'abuela', 'el', 'sabado'],
      'emoji': '👵',
      'errorIndex': 7,
      'correct': 'sábado'
    },
  ];

  List<String> _currentWords = [];
  String _currentEmoji = '';
  int _errorIndex = -1;
  String _correctWord = '';
  int? _selectedIndex;

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
    final sentenceData = _sentences[_random.nextInt(_sentences.length)];

    setState(() {
      _currentWords = List<String>.from(sentenceData['words'] as List);
      _currentEmoji = sentenceData['emoji'] as String;
      _errorIndex = sentenceData['errorIndex'] as int;
      _correctWord = sentenceData['correct'] as String;
      _selectedIndex = null;
      _showFeedback = false;
    });
  }

  void _selectWord(int index) {
    if (_showFeedback) return;

    setState(() {
      _selectedIndex = index;
    });
  }

  void _checkAnswer() {
    if (_showFeedback || _selectedIndex == null) return;

    final isCorrect = _selectedIndex == _errorIndex;

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
        _currentScore = max(0, _currentScore - 7);
        _feedbackMessage = 'Intenta de nuevo. -7 puntos';
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
      'gameId': 'detectives_ortografia',
      'gameName': 'Detectives de Ortografía',
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
                                  _buildCheckButton(),
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
                '🕵️',
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
          'Encuentra el error ortográfico',
          style: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _currentEmoji,
          style: const TextStyle(fontSize: 60),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 8,
          runSpacing: 12,
          children: List.generate(
            _currentWords.length,
            (index) {
              final word = _currentWords[index];
              final isSelected = _selectedIndex == index;
              final isError = index == _errorIndex;

              return GestureDetector(
                onTap: () => _selectWord(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _showFeedback
                        ? (isError ? Colors.green.shade100 : Colors.grey.shade50)
                        : (isSelected ? Colors.red.shade100 : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _showFeedback
                          ? (isError ? Colors.green : Colors.grey.shade300)
                          : (isSelected ? Colors.red.shade400 : Colors.grey.shade300),
                      width: isSelected || (_showFeedback && isError) ? 3 : 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        word,
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: _showFeedback
                              ? (isError ? Colors.green.shade700 : Colors.grey.shade700)
                              : (isSelected ? Colors.red.shade700 : Colors.grey.shade700),
                        ),
                      ),
                      if (_showFeedback && isError && _correctWord.isNotEmpty)
                        Text(
                          _correctWord,
                          style: GoogleFonts.fredoka(
                            fontSize: 12,
                            color: Colors.green.shade600,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCheckButton() {
    if (_showFeedback) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: _selectedIndex != null ? _checkAnswer : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        disabledBackgroundColor: Colors.grey.shade300,
      ),
      child: Text(
        'Verificar',
        style: GoogleFonts.fredoka(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
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
          if (!_isCorrect && _errorIndex >= 0) ...[
            const SizedBox(height: 8),
            Text(
              'Palabra correcta: $_correctWord',
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
