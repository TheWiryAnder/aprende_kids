library;

/// Geometría Constructora - Juego de figuras geométricas para niños de 8-12 años
///
/// Este juego enseña a contar lados, vértices y ángulos de figuras geométricas.
/// Los niños aprenden a identificar propiedades de diferentes formas.
///
/// Características:
/// - Identificación de figuras geométricas con emojis
/// - Contar lados, vértices o ángulos
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

class GeometriaConstructoraGame extends StatefulWidget {
  const GeometriaConstructoraGame({super.key});

  @override
  State<GeometriaConstructoraGame> createState() => _GeometriaConstructoraGameState();
}

class _GeometriaConstructoraGameState extends State<GeometriaConstructoraGame> {
  final Random _random = Random();

  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  String _currentShape = '';
  String _question = '';
  int _correctAnswer = 0;
  List<int> _options = [];

  // Definición de figuras geométricas
  final Map<String, Map<String, dynamic>> _shapes = {
    'Triángulo': {
      'emoji': '🔺',
      'lados': 3,
      'vertices': 3,
      'angulos': 3,
      'color': Colors.red,
    },
    'Cuadrado': {
      'emoji': '🟥',
      'lados': 4,
      'vertices': 4,
      'angulos': 4,
      'color': Colors.blue,
    },
    'Rectángulo': {
      'emoji': '▭',
      'lados': 4,
      'vertices': 4,
      'angulos': 4,
      'color': Colors.green,
    },
    'Pentágono': {
      'emoji': '⬟',
      'lados': 5,
      'vertices': 5,
      'angulos': 5,
      'color': Colors.purple,
    },
    'Hexágono': {
      'emoji': '⬢',
      'lados': 6,
      'vertices': 6,
      'angulos': 6,
      'color': Colors.orange,
    },
    'Círculo': {
      'emoji': '🟢',
      'lados': 0,
      'vertices': 0,
      'angulos': 0,
      'color': Colors.teal,
    },
  };

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
      // Seleccionar figura aleatoria
      List<String> availableShapes = _shapes.keys.toList();

      // Al principio, solo figuras simples
      if (_correctAnswers < 3) {
        availableShapes = ['Triángulo', 'Cuadrado', 'Círculo'];
      } else if (_correctAnswers < 6) {
        availableShapes = ['Triángulo', 'Cuadrado', 'Rectángulo', 'Círculo'];
      }

      _currentShape = availableShapes[_random.nextInt(availableShapes.length)];

      // Seleccionar tipo de pregunta
      List<String> questionTypes = ['lados', 'vertices'];
      if (_correctAnswers >= 4) questionTypes.add('angulos');

      String questionType = questionTypes[_random.nextInt(questionTypes.length)];

      // Generar pregunta y respuesta
      switch (questionType) {
        case 'lados':
          _question = '¿Cuántos lados tiene?';
          _correctAnswer = _shapes[_currentShape]!['lados'] as int;
          break;
        case 'vertices':
          _question = '¿Cuántos vértices tiene?';
          _correctAnswer = _shapes[_currentShape]!['vertices'] as int;
          break;
        case 'angulos':
          _question = '¿Cuántos ángulos tiene?';
          _correctAnswer = _shapes[_currentShape]!['angulos'] as int;
          break;
      }

      _options = _generateOptions(_correctAnswer);
      _options.shuffle();

      _showFeedback = false;
      _selectedAnswer = null;
    });
  }

  List<int> _generateOptions(int correct) {
    List<int> options = [correct];

    // Generar opciones cercanas pero diferentes
    List<int> possibleWrong = [0, 3, 4, 5, 6, 8];
    possibleWrong.remove(correct);

    while (options.length < 4 && possibleWrong.isNotEmpty) {
      int wrongAnswer = possibleWrong[_random.nextInt(possibleWrong.length)];
      possibleWrong.remove(wrongAnswer);
      options.add(wrongAnswer);
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

        int basePoints = 15;
        int timeBonus = (_timeRemaining / 10).floor() * 3;
        int streakBonus = (_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 7 : 0;

        _currentScore += basePoints + timeBonus + streakBonus;
      } else {
        _consecutiveCorrect = 0;
        _currentScore = (_currentScore - 7).clamp(0, double.infinity).toInt();
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
      'gameId': 'geometria_constructora',
      'gameName': 'Geometría Constructora',
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

    final shapeData = _shapes[_currentShape]!;
    final shapeColor = shapeData['color'] as Color;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.cyan.shade700,
              Colors.blue.shade500,
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCharacter(),
                                _buildProblem(shapeData, shapeColor),
                                _buildOptions(),
                                if (_showFeedback) _buildFeedback(),
                              ],
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
                  color: _timeRemaining <= 10 ? Colors.white : Colors.cyan.shade700,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_timeRemaining}s',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _timeRemaining <= 10 ? Colors.white : Colors.cyan.shade700,
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
                    color: Colors.cyan.shade700,
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
              color: Colors.cyan.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.change_history,
              size: 60,
              color: Colors.cyan.shade700,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProblem(Map<String, dynamic> shapeData, Color shapeColor) {
    return Column(
      children: [
        Text(
          _currentShape,
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: shapeColor,
          ),
        ),
        const SizedBox(height: 16),

        // Mostrar la figura grande
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: shapeColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: shapeColor.withValues(alpha: 0.3),
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              shapeData['emoji'] as String,
              style: const TextStyle(fontSize: 100),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Pregunta
        Text(
          _question,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
          textAlign: TextAlign.center,
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
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan.shade700,
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
                        ? '¡Perfecto! +${15 + (_timeRemaining / 10).floor() * 3 + ((_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 7 : 0)} puntos'
                        : '¡Ups! Era $_correctAnswer (-7 puntos)',
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
