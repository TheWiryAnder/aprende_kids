library;

/// División Detective - Juego de división para niños de 9-12 años
///
/// Este juego presenta problemas de división simple con representación visual
/// distribuyendo objetos en grupos iguales.
///
/// Características:
/// - División mostrada como distribución en grupos
/// - Emojis de detective y misterio
/// - Sistema de puntuación con penalizaciones
/// - Dificultad para niños mayores
///
/// Autor: [Tu nombre]
/// Fecha: 2025

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/colors.dart';
import '../../../data/math_data_bank.dart';
import '../../widgets/game_video_widget.dart';

class DivisionDetectiveGame extends StatefulWidget {
  const DivisionDetectiveGame({super.key});

  @override
  State<DivisionDetectiveGame> createState() => _DivisionDetectiveGameState();
}

class _DivisionDetectiveGameState extends State<DivisionDetectiveGame> {
  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  // ✅ GENERACIÓN PROCEDURAL: Problema actual generado dinámicamente
  MathProblem? _currentProblem;

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
      // ✅ GENERACIÓN PROCEDURAL: Determinar nivel de dificultad dinámicamente
      int level = 1;
      if (_correctAnswers >= 8) {
        level = 3;
      } else if (_correctAnswers >= 3) {
        level = 2;
      }

      // ✅ GENERACIÓN PROCEDURAL: Usar MathDataBank para divisiones
      _currentProblem = MathDataBank.generateDivision(level: level);

      _showFeedback = false;
      _selectedAnswer = null;
    });
  }

  void _checkAnswer(int selectedAnswer) {
    if (_showFeedback || _currentProblem == null) return;

    setState(() {
      _selectedAnswer = selectedAnswer;
      _isCorrect = selectedAnswer == _currentProblem!.correctAnswer;
      _showFeedback = true;
      _questionsAnswered++;

      if (_isCorrect) {
        _correctAnswers++;
        _consecutiveCorrect++;

        int basePoints = 20; // Más difícil, más puntos
        int timeBonus = (_timeRemaining / 10).floor() * 4;
        int streakBonus = (_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 8 : 0;

        _currentScore += basePoints + timeBonus + streakBonus;
      } else {
        _consecutiveCorrect = 0;
        _currentScore = (_currentScore - 10).clamp(0, double.infinity).toInt();
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
      'gameId': 'division_detective',
      'gameName': 'División Detective',
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
    if (!_showFeedback || _currentProblem == null) return Colors.white;
    if (option == _selectedAnswer) {
      return _isCorrect ? Colors.green.shade100 : Colors.red.shade100;
    }
    if (option == _currentProblem!.correctAnswer && !_isCorrect) {
      return Colors.green.shade100;
    }
    return Colors.white;
  }

  Color _getOptionBorderColor(int option) {
    if (!_showFeedback || _currentProblem == null) return AppColors.mathColor;
    if (option == _selectedAnswer) {
      return _isCorrect ? Colors.green : Colors.red;
    }
    if (option == _currentProblem!.correctAnswer && !_isCorrect) {
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
              Colors.brown.shade800,
              Colors.brown.shade600,
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
                            margin: EdgeInsets.all(screenWidth > 600 ? 16 : 8),
                            padding: EdgeInsets.all(screenWidth > 600 ? 24 : 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(screenWidth > 600 ? 20 : 12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                if (screenWidth > 600) _buildCharacter(),
                                _buildProblem(),
                                const SizedBox(height: 8),
                                _buildOptions(),
                                if (_showFeedback) ...[
                                  const SizedBox(height: 8),
                                  _buildFeedback(),
                                ],
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
                  color: _timeRemaining <= 10 ? Colors.white : Colors.brown.shade800,
                ),
                const SizedBox(width: 6),
                Text(
                  '${_timeRemaining}s',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _timeRemaining <= 10 ? Colors.white : Colors.brown.shade800,
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
                    color: Colors.brown.shade800,
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
              color: Colors.brown.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 60,
              color: Colors.brown.shade800,
            ),
          ),
        );
      },
    );
  }

  Widget _buildProblem() {
    if (_currentProblem == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return Column(
      children: [
        Text(
          _currentProblem!.questionText,
          style: GoogleFonts.fredoka(
            fontSize: isMobile ? 14 : 18,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: isMobile ? 4 : 8),
        Text(
          '${_currentProblem!.operand1} ÷ ${_currentProblem!.operand2}',
          style: GoogleFonts.fredoka(
            fontSize: isMobile ? 20 : 28,
            fontWeight: FontWeight.bold,
            color: Colors.brown.shade800,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 16),
        Text(
          'Distribuye ${_currentProblem!.operand1} objetos en ${_currentProblem!.operand2} grupos',
          style: GoogleFonts.fredoka(
            fontSize: isMobile ? 13 : 16,
            color: Colors.grey.shade600,
          ),
        ),
        SizedBox(height: isMobile ? 8 : 20),

        // Mostrar todos los objetos
        Container(
          padding: EdgeInsets.all(isMobile ? 4 : 8),
          decoration: BoxDecoration(
            color: Colors.brown.shade50,
            borderRadius: BorderRadius.circular(isMobile ? 6 : 12),
            border: Border.all(
              color: Colors.brown.shade300,
              width: 2,
            ),
          ),
          child: Wrap(
            spacing: isMobile ? 3 : 6,
            runSpacing: isMobile ? 3 : 6,
            alignment: WrapAlignment.center,
            children: List.generate(
              _currentProblem!.operand1.clamp(0, 30), // Limitar para no saturar
              (index) => Text(
                _currentProblem!.visualType.emoji,
                style: TextStyle(fontSize: isMobile ? 16 : 24),
              ),
            ),
          ),
        ),

        SizedBox(height: isMobile ? 8 : 16),

        // Flecha hacia abajo
        Icon(Icons.arrow_downward, size: isMobile ? 20 : 32, color: Colors.brown.shade600),

        SizedBox(height: isMobile ? 4 : 8),

        // Mostrar grupos vacíos
        Text(
          'Dividir en ${_currentProblem!.operand2} grupos iguales:',
          style: GoogleFonts.fredoka(
            fontSize: isMobile ? 13 : 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        SizedBox(height: isMobile ? 6 : 12),

        Wrap(
          spacing: isMobile ? 4 : 8,
          runSpacing: isMobile ? 4 : 8,
          alignment: WrapAlignment.center,
          children: List.generate(_currentProblem!.operand2, (index) {
            return Container(
              width: isMobile ? 60 : 80,
              height: isMobile ? 45 : 60,
              decoration: BoxDecoration(
                color: Colors.brown.shade50,
                borderRadius: BorderRadius.circular(isMobile ? 6 : 8),
                border: Border.all(
                  color: Colors.brown.shade400,
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Center(
                child: Text(
                  '?',
                  style: GoogleFonts.fredoka(
                    fontSize: isMobile ? 18 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown.shade600,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildOptions() {
    if (_currentProblem == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    if (isMobile) {
      // Vista móvil: Grid 2x2 con emojis + número
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        alignment: WrapAlignment.center,
        children: _currentProblem!.options.map((option) {
          return SizedBox(
            width: (screenWidth - 48) / 2, // 2 columnas con spacing
            child: Material(
              color: _getOptionColor(option),
              borderRadius: BorderRadius.circular(12),
              child: InkWell(
                onTap: _showFeedback ? null : () => _checkAnswer(option),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: _getOptionBorderColor(option),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Mostrar emojis en móvil
                      Wrap(
                        spacing: 2,
                        runSpacing: 2,
                        alignment: WrapAlignment.center,
                        children: List.generate(
                          option.clamp(0, 8), // Máximo 8 emojis para que quepa
                          (index) => Text(
                            _currentProblem!.visualType.emoji,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Número grande
                      Text(
                        '$option',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fredoka(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF1a1a2e),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else {
      // Vista desktop: horizontal con scroll (mantener original)
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _currentProblem!.options.map((option) {
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
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1a1a2e),
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
  }

  Widget _buildFeedback() {
    if (_currentProblem == null) return const SizedBox.shrink();

    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth <= 600;

    return TweenAnimationBuilder(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0, end: 1),
      builder: (context, double value, child) {
        return Opacity(
          opacity: value,
          child: Container(
            padding: EdgeInsets.all(isMobile ? 8 : 16),
            decoration: BoxDecoration(
              color: _isCorrect ? Colors.green.shade50 : Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _isCorrect ? Colors.green : Colors.red,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _isCorrect ? Icons.check_circle : Icons.cancel,
                  color: _isCorrect ? Colors.green : Colors.red,
                  size: isMobile ? 20 : 28,
                ),
                SizedBox(width: isMobile ? 6 : 12),
                Flexible(
                  child: Text(
                    _isCorrect
                        ? '¡Caso resuelto! +${20 + (_timeRemaining / 10).floor() * 4 + ((_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 8 : 0)} puntos'
                        : '¡Error! Eran ${_currentProblem!.correctAnswer} por grupo (-10 puntos)',
                    style: GoogleFonts.fredoka(
                      fontSize: isMobile ? 12 : 16,
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
