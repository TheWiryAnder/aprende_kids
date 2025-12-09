library;

/// Estados de la Materia - Juego educativo sobre estados de la materia
///
/// Los niños aprenden a clasificar objetos y sustancias por su estado.
///
/// Características:
/// - 15 sustancias/objetos diferentes
/// - Clasificación en sólido, líquido y gaseoso
/// - Feedback visual inmediato
/// - Emoji visual para cada elemento
///
/// Autor: Sistema Educativo
/// Fecha: 2025

import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/game_video_widget.dart';

class EstadosMateriaGame extends StatefulWidget {
  const EstadosMateriaGame({super.key});

  @override
  State<EstadosMateriaGame> createState() => _EstadosMateriaGameState();
}

class _EstadosMateriaGameState extends State<EstadosMateriaGame> {
  final Random _random = Random();

  // Banco de sustancias y objetos con sus estados
  final List<Map<String, dynamic>> _substances = [
    {'name': 'Agua del océano 🌊', 'state': 'Líquido', 'emoji': '🌊'},
    {'name': 'Vapor de agua 💨', 'state': 'Gaseoso', 'emoji': '💨'},
    {'name': 'Hielo 🧊', 'state': 'Sólido', 'emoji': '🧊'},
    {'name': 'Piedra 🪨', 'state': 'Sólido', 'emoji': '🪨'},
    {'name': 'Leche 🥛', 'state': 'Líquido', 'emoji': '🥛'},
    {'name': 'Oxígeno del aire 💨', 'state': 'Gaseoso', 'emoji': '💨'},
    {'name': 'Jugo 🧃', 'state': 'Líquido', 'emoji': '🧃'},
    {'name': 'Madera 🪵', 'state': 'Sólido', 'emoji': '🪵'},
    {'name': 'Aceite 🛢️', 'state': 'Líquido', 'emoji': '🛢️'},
    {'name': 'Humo 💨', 'state': 'Gaseoso', 'emoji': '💨'},
    {'name': 'Arena 🏖️', 'state': 'Sólido', 'emoji': '🏖️'},
    {'name': 'Miel 🍯', 'state': 'Líquido', 'emoji': '🍯'},
    {'name': 'Dióxido de carbono 🫧', 'state': 'Gaseoso', 'emoji': '🫧'},
    {'name': 'Azúcar 🧂', 'state': 'Sólido', 'emoji': '🧂'},
    {'name': 'Perfume en el aire 💨', 'state': 'Gaseoso', 'emoji': '💨'},
  ];

  List<Map<String, dynamic>> _gameSubstances = [];
  int _currentSubstanceIndex = 0;
  Map<String, dynamic> _currentSubstance = {};

  final List<String> _states = ['Sólido', 'Líquido', 'Gaseoso'];
  final List<String> _stateEmojis = ['🧊', '💧', '💨'];

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
    _gameSubstances = List.from(_substances)..shuffle(_random);
    _gameSubstances = _gameSubstances.take(_totalQuestions).toList();
    _loadSubstance();
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

  void _loadSubstance() {
    if (_currentSubstanceIndex < _gameSubstances.length) {
      setState(() {
        _currentSubstance = _gameSubstances[_currentSubstanceIndex];
        _showFeedback = false;
        _selectedAnswer = null;
      });
    } else {
      _endGame();
    }
  }

  void _checkAnswer(int selectedIndex) {
    if (_showFeedback) return;

    final correctState = _currentSubstance['state'] as String;
    final selectedState = _states[selectedIndex];

    setState(() {
      _selectedAnswer = selectedIndex;
      _isCorrect = selectedState == correctState;
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
        _currentScore = (_currentScore - 6).clamp(0, double.infinity).toInt();
      }
    });

    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _currentSubstanceIndex++;
        _loadSubstance();
      }
    });
  }

  GameVideoType _getCurrentVideoType() {
    if (_showFeedback) {
      return _isCorrect ? GameVideoType.excelente : GameVideoType.intentalo;
    }
    return GameVideoType.pensando;
  }

  void _endGame() {
    _gameTimer?.cancel();

    final accuracy = _questionsAnswered > 0
        ? ((_correctAnswers / _questionsAnswered) * 100).round()
        : 0;

    context.push('/game-results', extra: {
      'gameId': 'estados_materia',
      'gameName': 'Estados de la Materia',
      'score': _currentScore,
      'questionsAnswered': _questionsAnswered,
      'correctAnswers': _correctAnswers,
      'accuracy': accuracy,
    });
  }

  Color _getOptionColor(int index) {
    if (!_showFeedback) {
      return Colors.white;
    }

    final correctState = _currentSubstance['state'] as String;
    final correctIndex = _states.indexOf(correctState);

    if (index == _selectedAnswer) {
      return _isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    }

    if (index == correctIndex && !_isCorrect) {
      return Colors.green.shade100;
    }

    return Colors.white;
  }

  Color _getOptionBorderColor(int index) {
    if (!_showFeedback) {
      return Colors.green.shade400;
    }

    final correctState = _currentSubstance['state'] as String;
    final correctIndex = _states.indexOf(correctState);

    if (index == _selectedAnswer) {
      return _isCorrect ? Colors.green : Colors.red;
    }

    if (index == correctIndex && !_isCorrect) {
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
                '⚗️',
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
          'Pregunta ${_currentSubstanceIndex + 1} de $_totalQuestions',
          style: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          '¿En qué estado se encuentra?',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.green.shade50,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.green.shade200,
              width: 2,
            ),
          ),
          child: Text(
            _currentSubstance['name'] as String? ?? '',
            style: GoogleFonts.fredoka(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    return Column(
      children: List.generate(_states.length, (index) {
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _stateEmojis[index],
                      style: const TextStyle(fontSize: 32),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _states[index],
                      style: GoogleFonts.fredoka(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                      ),
                    ),
                  ],
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
                  : 'Respuesta incorrecta. La respuesta es ${_currentSubstance['state']}. -6 puntos',
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
