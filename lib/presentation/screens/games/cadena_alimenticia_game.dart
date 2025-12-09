library;

/// Cadena Alimenticia - Juego educativo sobre cadenas alimenticias
///
/// Los niños aprenden a ordenar elementos de una cadena alimenticia correctamente.
///
/// Características:
/// - 12 cadenas alimenticias diferentes
/// - Sistema de arrastre y ordenamiento
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

class CadenaAlimenticiaGame extends StatefulWidget {
  const CadenaAlimenticiaGame({super.key});

  @override
  State<CadenaAlimenticiaGame> createState() => _CadenaAlimenticiaGameState();
}

class _CadenaAlimenticiaGameState extends State<CadenaAlimenticiaGame> {
  final Random _random = Random();

  // Banco de cadenas alimenticias
  final List<Map<String, dynamic>> _foodChains = [
    {
      'chain': ['Sol ☀️', 'Planta 🌱', 'Conejo 🐰', 'Zorro 🦊'],
    },
    {
      'chain': ['Sol ☀️', 'Hierba 🌾', 'Saltamontes 🦗', 'Rana 🐸', 'Serpiente 🐍'],
    },
    {
      'chain': ['Sol ☀️', 'Algas 🌿', 'Pez pequeño 🐟', 'Pez grande 🐠'],
    },
    {
      'chain': ['Sol ☀️', 'Planta 🌿', 'Ratón 🐭', 'Búho 🦉'],
    },
    {
      'chain': ['Sol ☀️', 'Flores 🌺', 'Abeja 🐝', 'Pájaro 🐦'],
    },
    {
      'chain': ['Sol ☀️', 'Hierba 🌱', 'Vaca 🐄', 'Humano 🧑'],
    },
    {
      'chain': ['Sol ☀️', 'Plancton 🦠', 'Camarón 🦐', 'Ballena 🐋'],
    },
    {
      'chain': ['Sol ☀️', 'Arbusto 🌳', 'Oruga 🐛', 'Pájaro 🐦', 'Gato 🐱'],
    },
    {
      'chain': ['Sol ☀️', 'Pasto 🌾', 'Cebra 🦓', 'León 🦁'],
    },
    {
      'chain': ['Sol ☀️', 'Plantas 🌿', 'Insectos 🐞', 'Araña 🕷️', 'Lagartija 🦎'],
    },
    {
      'chain': ['Sol ☀️', 'Algas 🌿', 'Krill 🦐', 'Pingüino 🐧', 'Foca 🦭'],
    },
    {
      'chain': ['Sol ☀️', 'Hojas 🍃', 'Lombriz 🪱', 'Pájaro 🐦', 'Halcón 🦅'],
    },
  ];

  List<Map<String, dynamic>> _gameChains = [];
  int _currentChainIndex = 0;
  List<String> _correctOrder = [];
  List<String> _userOrder = [];
  List<String> _availableItems = [];

  int _currentScore = 0;
  int _questionsAnswered = 0;
  int _correctAnswers = 0;
  int _consecutiveCorrect = 0;

  bool _showFeedback = false;
  bool _isCorrect = false;

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
    _gameChains = List.from(_foodChains)..shuffle(_random);
    _gameChains = _gameChains.take(_totalQuestions).toList();
    _loadChain();
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

  void _loadChain() {
    if (_currentChainIndex < _gameChains.length) {
      setState(() {
        _correctOrder = List<String>.from(_gameChains[_currentChainIndex]['chain'] as List);
        _availableItems = List<String>.from(_correctOrder)..shuffle(_random);
        _userOrder = [];
        _showFeedback = false;
      });
    } else {
      _endGame();
    }
  }

  void _addToChain(String item) {
    if (_showFeedback) return;

    setState(() {
      _userOrder.add(item);
      _availableItems.remove(item);
    });
  }

  void _removeFromChain(int index) {
    if (_showFeedback) return;

    setState(() {
      final item = _userOrder[index];
      _userOrder.removeAt(index);
      _availableItems.add(item);
    });
  }

  void _checkAnswer() {
    if (_showFeedback || _userOrder.length != _correctOrder.length) return;

    setState(() {
      _isCorrect = _userOrder.join() == _correctOrder.join();
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

    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) {
        _currentChainIndex++;
        _loadChain();
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
      'gameId': 'cadena_alimenticia',
      'gameName': 'Cadena Alimenticia',
      'score': _currentScore,
      'questionsAnswered': _questionsAnswered,
      'correctAnswers': _correctAnswers,
      'accuracy': accuracy,
    });
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
                                  _buildAvailableItems(),
                                  const SizedBox(height: 20),
                                  _buildUserChain(),
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
                '🌿',
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
          'Pregunta ${_currentChainIndex + 1} de $_totalQuestions',
          style: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Ordena la cadena alimenticia',
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Arrastra los elementos en el orden correcto',
          style: GoogleFonts.fredoka(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildAvailableItems() {
    if (_availableItems.isEmpty) return const SizedBox.shrink();

    return Column(
      children: [
        Text(
          'Elementos disponibles:',
          style: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          alignment: WrapAlignment.center,
          children: _availableItems.map((item) {
            return GestureDetector(
              onTap: () => _addToChain(item),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.green.shade400,
                    width: 2,
                  ),
                ),
                child: Text(
                  item,
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildUserChain() {
    return Column(
      children: [
        Text(
          'Tu cadena alimenticia:',
          style: GoogleFonts.fredoka(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          constraints: const BoxConstraints(minHeight: 120),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: _showFeedback
                  ? (_isCorrect ? Colors.green : Colors.red)
                  : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: _userOrder.isEmpty
              ? Center(
                  child: Text(
                    'Toca los elementos para agregarlos',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: List.generate(_userOrder.length, (index) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () => _removeFromChain(index),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _showFeedback
                                  ? (_userOrder[index] == _correctOrder[index]
                                      ? Colors.green.shade100
                                      : Colors.red.shade100)
                                  : Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _showFeedback
                                    ? (_userOrder[index] == _correctOrder[index]
                                        ? Colors.green
                                        : Colors.red)
                                    : Colors.blue.shade400,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              _userOrder[index],
                              style: GoogleFonts.fredoka(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                              ),
                            ),
                          ),
                        ),
                        if (index < _userOrder.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.grey.shade600,
                              size: 20,
                            ),
                          ),
                      ],
                    );
                  }),
                ),
        ),
      ],
    );
  }

  Widget _buildCheckButton() {
    if (_showFeedback) return const SizedBox.shrink();

    return ElevatedButton(
      onPressed: _userOrder.length == _correctOrder.length ? _checkAnswer : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        disabledBackgroundColor: Colors.grey.shade300,
      ),
      child: Text(
        'Verificar Cadena',
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
                  _isCorrect
                      ? '¡Excelente! +${10 + (_timeRemaining / 10).floor() * 2 + ((_consecutiveCorrect > 1) ? (_consecutiveCorrect - 1) * 5 : 0)} puntos'
                      : 'Orden incorrecto. -6 puntos',
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
          if (!_isCorrect) ...[
            const SizedBox(height: 12),
            Text(
              'Orden correcto: ${_correctOrder.join(" → ")}',
              style: GoogleFonts.fredoka(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}
