library;

/// Pantalla de Resultados del Juego
///
/// Muestra los resultados finales después de completar un juego.
/// Guarda la puntuación en Firebase y permite ver el ranking.
///
/// Características:
/// - Visualización de puntuación y estadísticas
/// - Sistema de estrellas según rendimiento
/// - Guardado automático en Firebase
/// - Navegación al ranking global
/// - Opción de jugar de nuevo
///
/// Autor: [Tu nombre]
/// Fecha: 2025

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import '../../../app/theme/colors.dart';
import '../../../app/config/game_config.dart';

class GameResultsScreen extends StatefulWidget {
  final Map<String, dynamic> gameData;

  const GameResultsScreen({
    super.key,
    required this.gameData,
  });

  @override
  State<GameResultsScreen> createState() => _GameResultsScreenState();
}

class _GameResultsScreenState extends State<GameResultsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late ConfettiController _confettiController;
  bool _isSaving = true;
  bool _saveSuccess = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _animationController.forward();
    _saveScore();

    // Mostrar confetti si la puntuación es buena
    if (_calculateStars() >= 2) {
      Future.delayed(const Duration(milliseconds: 500), () {
        _confettiController.play();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  int _calculateStars() {
    final accuracy = widget.gameData['accuracy'] as int;
    if (accuracy >= 80) return 3;
    if (accuracy >= 60) return 2;
    if (accuracy >= 40) return 1;
    return 0;
  }

  Future<void> _saveScore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _isSaving = false;
          _errorMessage = 'Usuario no autenticado';
        });
        return;
      }

      final firestore = FirebaseFirestore.instance;
      final gameId = widget.gameData['gameId'] as String;
      final score = widget.gameData['score'] as int;
      final accuracy = widget.gameData['accuracy'] as int;
      final stars = _calculateStars();

      // Obtener las monedas de recompensa según la dificultad del juego
      final coinsReward = GameConfig.getCoinsReward(gameId);

      // Obtener datos del usuario
      final userDoc = await firestore.collection('users').doc(user.uid).get();
      final username = userDoc.data()?['username'] ?? 'Jugador';

      // Guardar en la colección de scores
      await firestore.collection('scores').add({
        'userId': user.uid,
        'username': username,
        'gameId': gameId,
        'gameName': widget.gameData['gameName'],
        'score': score,
        'accuracy': accuracy,
        'stars': stars,
        'questionsAnswered': widget.gameData['questionsAnswered'],
        'correctAnswers': widget.gameData['correctAnswers'],
        'coinsEarned': coinsReward,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Actualizar el documento del usuario con el total acumulado
      // IMPORTANTE: Los puntos SIEMPRE suben, nunca bajan (solo increment)
      // Las monedas también se acumulan al completar juegos
      await firestore.collection('users').doc(user.uid).update({
        'totalScore': FieldValue.increment(score),
        'coins': FieldValue.increment(coinsReward),
        'gamesPlayed': FieldValue.increment(1),
        'lastPlayed': FieldValue.serverTimestamp(),
      });

      // Guardar el mejor score del juego si es mayor
      final gameScoreDoc = await firestore
          .collection('users')
          .doc(user.uid)
          .collection('gameScores')
          .doc(gameId)
          .get();

      final bestScore = gameScoreDoc.data()?['bestScore'] as int?;
      if (!gameScoreDoc.exists || (bestScore ?? 0) < score) {
        await firestore
            .collection('users')
            .doc(user.uid)
            .collection('gameScores')
            .doc(gameId)
            .set({
          'bestScore': score,
          'bestAccuracy': accuracy,
          'bestStars': stars,
          'timesPlayed': FieldValue.increment(1),
          'lastPlayed': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      setState(() {
        _isSaving = false;
        _saveSuccess = true;
      });
    } catch (e) {
      setState(() {
        _isSaving = false;
        _errorMessage = 'Error al guardar: $e';
      });
    }
  }

  Color _getCategoryColor() {
    final gameId = widget.gameData['gameId'] as String;
    if (gameId.contains('suma') ||
        gameId.contains('resta') ||
        gameId.contains('multiplicacion') ||
        gameId.contains('division')) {
      return AppColors.mathColor;
    }
    return AppColors.mathColor; // Default
  }

  @override
  Widget build(BuildContext context) {
    final stars = _calculateStars();
    final categoryColor = _getCategoryColor();
    final gameId = widget.gameData['gameId'] as String;
    final coinsReward = GameConfig.getCoinsReward(gameId);

    return Scaffold(
      body: Stack(
        children: [
          // Fondo con gradiente
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  categoryColor,
                  categoryColor.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              particleDrag: 0.05,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              gravity: 0.1,
              colors: const [
                Colors.red,
                Colors.blue,
                Colors.green,
                Colors.yellow,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),

          // Contenido
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 600),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                    // Título
                    FadeTransition(
                      opacity: _animationController,
                      child: Text(
                        '¡Juego Completado!',
                        style: GoogleFonts.fredoka(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Nombre del juego
                    FadeTransition(
                      opacity: _animationController,
                      child: Text(
                        widget.gameData['gameName'] as String,
                        style: GoogleFonts.fredoka(
                          fontSize: 20,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Tarjeta de resultados
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.3),
                        end: Offset.zero,
                      ).animate(CurvedAnimation(
                        parent: _animationController,
                        curve: Curves.easeOut,
                      )),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Estrellas
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: ScaleTransition(
                                    scale: Tween<double>(begin: 0, end: 1).animate(
                                      CurvedAnimation(
                                        parent: _animationController,
                                        curve: Interval(
                                          0.3 + (index * 0.1),
                                          0.6 + (index * 0.1),
                                          curve: Curves.elasticOut,
                                        ),
                                      ),
                                    ),
                                    child: Icon(
                                      index < stars ? Icons.star : Icons.star_border,
                                      size: 60,
                                      color: index < stars
                                          ? Colors.amber
                                          : Colors.grey.shade300,
                                    ),
                                  ),
                                );
                              }),
                            ),

                            const SizedBox(height: 32),

                            // Puntuación
                            Column(
                              children: [
                                Text(
                                  'Puntuación',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${widget.gameData['score']}',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 56,
                                    fontWeight: FontWeight.bold,
                                    color: categoryColor,
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20),

                            // Monedas ganadas
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.amber.shade100, Colors.orange.shade100],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.orange.shade300, width: 2),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.monetization_on,
                                    color: Colors.orange,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '+$coinsReward',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange.shade800,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'monedas',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.orange.shade700,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Estadísticas
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStat(
                                  'Preguntas',
                                  '${widget.gameData['questionsAnswered']}',
                                  Icons.quiz,
                                  categoryColor,
                                ),
                                _buildStat(
                                  'Correctas',
                                  '${widget.gameData['correctAnswers']}',
                                  Icons.check_circle,
                                  Colors.green,
                                ),
                                _buildStat(
                                  'Precisión',
                                  '${widget.gameData['accuracy']}%',
                                  Icons.percent,
                                  Colors.blue,
                                ),
                              ],
                            ),

                            const SizedBox(height: 24),

                            // Estado de guardado
                            if (_isSaving)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Guardando puntuación...',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 14,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              )
                            else if (_saveSuccess)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle,
                                      color: Colors.green, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    '¡Puntuación guardada!',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 14,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                            else if (_errorMessage != null)
                              Text(
                                _errorMessage!,
                                style: GoogleFonts.fredoka(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                                textAlign: TextAlign.center,
                              ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Botones de acción
                    Column(
                      children: [
                        // Ver ranking
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _saveSuccess
                                ? () => context.push('/ranking')
                                : null,
                            icon: const Icon(Icons.leaderboard, size: 24),
                            label: Text(
                              'Ver Ranking',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: categoryColor,
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Jugar de nuevo
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              final gameId = widget.gameData['gameId'] as String;
                              context.push('/play/$gameId');
                            },
                            icon: const Icon(Icons.refresh, size: 24),
                            label: Text(
                              'Jugar de Nuevo',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Volver al inicio (HOME)
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => context.go('/home'),
                            icon: const Icon(Icons.home, size: 24),
                            label: Text(
                              'Volver al Inicio',
                              style: GoogleFonts.fredoka(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: categoryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}
