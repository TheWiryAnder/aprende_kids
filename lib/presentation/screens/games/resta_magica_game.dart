library;

/// Resta Mágica - Juego de restas para niños de 6-8 años
///
/// Este juego presenta problemas de resta simples con representación visual
/// usando emojis. Los niños aprenden a restar contando objetos.
///
/// Características:
/// - Problemas de resta con emojis visuales
/// - Sistema de puntuación con bonos y penalizaciones
/// - Dificultad adaptativa
/// - Feedback visual inmediato
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

class RestaMagicaGame extends StatefulWidget {
  const RestaMagicaGame({super.key});

  @override
  State<RestaMagicaGame> createState() => _RestaMagicaGameState();
}

class _RestaMagicaGameState extends State<RestaMagicaGame> {
  final Random _random = Random();

  // Estado del juego
  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  // Problema actual
  int _num1 = 0; // Número mayor
  int _num2 = 0; // Número menor
  int _correctAnswer = 0;
  List<int> _options = [];
  String _currentEmoji = '🌟';

  // Lista de emojis mágicos
  final List<String> _emojis = [
    '🌟', '✨', '💫', '🔮', '🪄', '🎩', '🎭', '🎪',
    '🎨', '🎯', '🎲', '🧩', '🎴', '🃏', '🎰'
  ];

  // Control de tiempo
  Timer? _gameTimer;
  int _timeRemaining = 60;

  // Control de feedback
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
      int maxNum = 5 + (_correctAnswers ~/ 3).clamp(0, 10);

      // Generar número mayor primero
      _num1 = _random.nextInt(maxNum) + 2; // Mínimo 2

      // Número menor debe ser menor que num1
      _num2 = _random.nextInt(_num1);

      // Asegurar que num2 no sea 0 al inicio
      if (_correctAnswers < 3 && _num2 == 0) {
        _num2 = 1;
      }

      _correctAnswer = _num1 - _num2;

      _currentEmoji = _emojis[_random.nextInt(_emojis.length)];
      _options = _generateOptions(_correctAnswer);
      _options.shuffle();

      _showFeedback = false;
      _selectedAnswer = null;
    });
  }

  List<int> _generateOptions(int correct) {
    List<int> options = [correct];

    while (options.length < 4) {
      int offset = _random.nextInt(5) - 2;
      if (offset == 0) offset = _random.nextBool() ? 3 : -3;

      int wrongAnswer = correct + offset;
      if (wrongAnswer >= 0 && !options.contains(wrongAnswer)) {
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

        int basePoints = 10;
        int timeBonus = (_timeRemaining / 10).floor() * 2;
        int streakBonus = (_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 5 : 0;

        _currentScore += basePoints + timeBonus + streakBonus;
      } else {
        _consecutiveCorrect = 0;
        _currentScore = (_currentScore - 5).clamp(0, double.infinity).toInt();
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
      'gameId': 'resta_magica',
      'gameName': 'Resta Mágica',
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
              AppColors.mathColor,
              AppColors.mathColor.withValues(alpha: 0.7),
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
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildCharacter(),
                                _buildProblem(),
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
                  color: _timeRemaining <= 10 ? Colors.white : AppColors.mathColor,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_timeRemaining}s',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _timeRemaining <= 10 ? Colors.white : AppColors.mathColor,
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
                    color: AppColors.mathColor,
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
              color: AppColors.mathColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_fix_high,
              size: 60,
              color: AppColors.mathColor,
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
          '¿Cuántos quedan?',
          style: GoogleFonts.fredoka(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildEmojiGroup(_num1, showAll: true),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.mathColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Text(
                '-',
                style: GoogleFonts.fredoka(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: AppColors.mathColor,
                ),
              ),
            ),
            const SizedBox(width: 20),
            _buildEmojiGroup(_num2, showCrossed: true),
          ],
        ),
      ],
    );
  }

  Widget _buildEmojiGroup(int count, {bool showAll = false, bool showCrossed = false}) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 180),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.mathColor.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: showCrossed
              ? Colors.red.withValues(alpha: 0.3)
              : AppColors.mathColor.withValues(alpha: 0.2),
          width: 2,
        ),
      ),
      child: Wrap(
        spacing: 6,
        runSpacing: 6,
        alignment: WrapAlignment.center,
        children: List.generate(
          count,
          (index) => Stack(
            alignment: Alignment.center,
            children: [
              Text(
                _currentEmoji,
                style: TextStyle(
                  fontSize: 32,
                  color: showCrossed ? Colors.grey.shade400 : null,
                ),
              ),
              if (showCrossed)
                const Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 32,
                ),
            ],
          ),
        ),
      ),
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
                  width: 140,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _getOptionBorderColor(option),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          option.clamp(0, 15),
                          (index) => Text(
                            _currentEmoji,
                            style: const TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$option',
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.mathColor,
                        ),
                      ),
                    ],
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
                        ? '¡Correcto! +${10 + (_timeRemaining / 10).floor() * 2 + ((_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 5 : 0)} puntos'
                        : '¡Ups! La respuesta era $_correctAnswer (-5 puntos)',
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
