library;

/// Juego: Aventura de Comprensión
///
/// Los niños deben leer textos cortos y responder preguntas de comprensión.
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

class AventuraComprensionGame extends StatefulWidget {
  const AventuraComprensionGame({super.key});

  @override
  State<AventuraComprensionGame> createState() => _AventuraComprensionGameState();
}

class _AventuraComprensionGameState extends State<AventuraComprensionGame> {
  final Random _random = Random();

  // Textos con preguntas de comprensión
  final List<Map<String, dynamic>> _stories = [
    {
      'text':
          'María tiene un perro llamado Max. Todos los días, después de la escuela, María lleva a Max al parque. A Max le encanta correr y jugar con otros perros. Su juguete favorito es una pelota roja.',
      'emoji': '🐕',
      'question': '¿Cuál es el juguete favorito de Max?',
      'options': [
        {'text': 'Una pelota roja', 'isCorrect': true},
        {'text': 'Un hueso', 'isCorrect': false},
        {'text': 'Una cuerda', 'isCorrect': false},
      ],
    },
    {
      'text':
          'Pedro es un niño muy curioso. Le gusta leer libros sobre el espacio. Su planeta favorito es Saturno porque tiene hermosos anillos. Sueña con ser astronauta cuando sea grande.',
      'emoji': '🚀',
      'question': '¿Cuál es el planeta favorito de Pedro?',
      'options': [
        {'text': 'Saturno', 'isCorrect': true},
        {'text': 'Marte', 'isCorrect': false},
        {'text': 'Júpiter', 'isCorrect': false},
      ],
    },
    {
      'text':
          'En el jardín de la abuela hay muchas flores. Las rosas son rojas, los girasoles son amarillos y las margaritas son blancas. A la abuela le gusta regar las flores todas las mañanas.',
      'emoji': '🌺',
      'question': '¿De qué color son las margaritas?',
      'options': [
        {'text': 'Blancas', 'isCorrect': true},
        {'text': 'Rojas', 'isCorrect': false},
        {'text': 'Amarillas', 'isCorrect': false},
      ],
    },
    {
      'text':
          'Lucas va a la playa con su familia. Le gusta construir castillos de arena con su hermana Ana. Usan cubetas y palas. También buscan caracoles en la orilla del mar.',
      'emoji': '🏖️',
      'question': '¿Con quién construye Lucas castillos de arena?',
      'options': [
        {'text': 'Con su hermana Ana', 'isCorrect': true},
        {'text': 'Con su mamá', 'isCorrect': false},
        {'text': 'Con su amigo', 'isCorrect': false},
      ],
    },
    {
      'text':
          'La maestra Elena enseña música. Todos los niños aprenden a tocar instrumentos. A Sofía le gusta el piano, a Miguel la guitarra y a Carla la flauta. Practican todos los martes.',
      'emoji': '🎵',
      'question': '¿Qué día practican los niños?',
      'options': [
        {'text': 'Los martes', 'isCorrect': true},
        {'text': 'Los lunes', 'isCorrect': false},
        {'text': 'Los viernes', 'isCorrect': false},
      ],
    },
    {
      'text':
          'El gato Michi es muy dormilón. Duerme en el sofá por la tarde y en la cama de Tomás por la noche. Su comida favorita es el atún. Cuando está feliz, ronronea muy fuerte.',
      'emoji': '🐱',
      'question': '¿Cuál es la comida favorita de Michi?',
      'options': [
        {'text': 'Atún', 'isCorrect': true},
        {'text': 'Pescado', 'isCorrect': false},
        {'text': 'Leche', 'isCorrect': false},
      ],
    },
    {
      'text':
          'En la granja del señor José hay muchos animales. Las gallinas ponen huevos, las vacas dan leche y los caballos ayudan a trabajar. Todos los animales viven felices en la granja.',
      'emoji': '🐓',
      'question': '¿Qué dan las vacas?',
      'options': [
        {'text': 'Leche', 'isCorrect': true},
        {'text': 'Huevos', 'isCorrect': false},
        {'text': 'Lana', 'isCorrect': false},
      ],
    },
    {
      'text':
          'Laura tiene una bicicleta nueva. Es de color azul con rueditas blancas. Todos los sábados va al parque a andar en bicicleta con sus amigos. Lleva siempre su casco para estar segura.',
      'emoji': '🚲',
      'question': '¿De qué color es la bicicleta de Laura?',
      'options': [
        {'text': 'Azul', 'isCorrect': true},
        {'text': 'Roja', 'isCorrect': false},
        {'text': 'Verde', 'isCorrect': false},
      ],
    },
    {
      'text':
          'El papá de Carlos es panadero. Todas las mañanas se levanta muy temprano para hacer pan fresco. Carlos ama el olor del pan recién horneado. Su favorito es el pan con chocolate.',
      'emoji': '🥖',
      'question': '¿Cuál es el pan favorito de Carlos?',
      'options': [
        {'text': 'Pan con chocolate', 'isCorrect': true},
        {'text': 'Pan francés', 'isCorrect': false},
        {'text': 'Pan integral', 'isCorrect': false},
      ],
    },
    {
      'text':
          'En el cumpleaños de Andrea había muchos globos de colores. Su mamá hizo un pastel de fresa con velas. Andrea sopló las velas y pidió un deseo. Después jugaron y comieron helado.',
      'emoji': '🎂',
      'question': '¿De qué sabor era el pastel?',
      'options': [
        {'text': 'Fresa', 'isCorrect': true},
        {'text': 'Chocolate', 'isCorrect': false},
        {'text': 'Vainilla', 'isCorrect': false},
      ],
    },
  ];

  String _currentText = '';
  String _currentEmoji = '';
  String _currentQuestion = '';
  List<Map<String, dynamic>> _options = [];
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
    final storyData = _stories[_random.nextInt(_stories.length)];
    final options = List<Map<String, dynamic>>.from(storyData['options'] as List);
    options.shuffle(_random);

    setState(() {
      _currentText = storyData['text'] as String;
      _currentEmoji = storyData['emoji'] as String;
      _currentQuestion = storyData['question'] as String;
      _options = options;
      _correctOptionIndex = options.indexWhere((opt) => opt['isCorrect'] == true);
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
        _currentScore = max(0, _currentScore - 10);
        _feedbackMessage = 'Intenta de nuevo. -10 puntos';
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
      'gameId': 'aventura_comprension',
      'gameName': 'Aventura de Comprensión',
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
                                  _buildStory(),
                                  const SizedBox(height: 20),
                                  _buildQuestion(),
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
                '📖',
                style: TextStyle(fontSize: 60),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStory() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.purple.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.purple.shade300,
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            _currentEmoji,
            style: const TextStyle(fontSize: 50),
          ),
          const SizedBox(height: 16),
          Text(
            _currentText,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              height: 1.6,
              color: Colors.grey.shade800,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestion() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red.shade300,
          width: 2,
        ),
      ),
      child: Text(
        _currentQuestion,
        style: GoogleFonts.fredoka(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.red.shade700,
        ),
        textAlign: TextAlign.center,
      ),
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
                        option['text'] as String,
                        style: GoogleFonts.fredoka(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: _showFeedback && isCorrect
                              ? Colors.green.shade700
                              : Colors.grey.shade700,
                        ),
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
    );
  }
}
