import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../widgets/game_video_widget.dart';

/// Pantalla de victoria unificada para todos los juegos
class GameWonScreen extends StatelessWidget {
  final String gameTitle;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int timeRemaining;
  final int timeLimit;
  final int coins;
  final VoidCallback? onPlayAgain;
  final Color primaryColor;
  final Color accentColor;

  const GameWonScreen({
    super.key,
    required this.gameTitle,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timeRemaining,
    required this.timeLimit,
    required this.coins,
    this.onPlayAgain,
    this.primaryColor = const Color(0xFF7C4DFF),
    this.accentColor = const Color(0xFF9575CD),
  });

  /// Calcula el número de estrellas según el porcentaje de aciertos
  int get stars {
    final accuracy = (correctAnswers / totalQuestions) * 100;
    if (accuracy == 100) return 3;
    if (accuracy >= 70) return 2;
    if (accuracy >= 40) return 1;
    return 0;
  }

  /// Mensaje motivacional según las estrellas
  String get motivationalMessage {
    switch (stars) {
      case 3:
        return '¡FELICIDADES! ¡Eres un maestro!';
      case 2:
        return '¡MUY BIEN! Sigue así';
      case 1:
        return '¡BIEN HECHO! Puedes mejorar';
      default:
        return '¡Buen intento! Inténtalo de nuevo';
    }
  }

  @override
  Widget build(BuildContext context) {
    final accuracy = ((correctAnswers / totalQuestions) * 100).round();

    return PopScope(
      canPop: false, // Prevenir back button
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [primaryColor, accentColor],
            ),
          ),
          child: SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // GIF de celebración grande
                    const GameVideoWidget(
                      videoType: GameVideoType.excelente,
                      width: 240,
                      height: 240,
                    ),
                    const SizedBox(height: 24),

                    // Título
                    Text(
                      '¡Juego Completado!',
                      style: GoogleFonts.fredoka(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gameTitle,
                      style: GoogleFonts.fredoka(
                        fontSize: 22,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Card con resultados
                    Container(
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
                          // Mensaje motivacional
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              motivationalMessage,
                              style: GoogleFonts.fredoka(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.amber.shade900,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Estrellas
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              3,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Icon(
                                  index < stars ? Icons.star : Icons.star_border,
                                  size: 64,
                                  color: index < stars
                                      ? Colors.amber.shade600
                                      : Colors.grey.shade300,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Puntuación
                          Text(
                            'Puntuación',
                            style: GoogleFonts.fredoka(
                              fontSize: 18,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            score.toString(),
                            style: GoogleFonts.fredoka(
                              fontSize: 56,
                              fontWeight: FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          const SizedBox(height: 24),

                          // Monedas ganadas
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.amber.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.amber.shade200,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('💰', style: TextStyle(fontSize: 32)),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '+$coins monedas',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.amber.shade900,
                                      ),
                                    ),
                                    Text(
                                      'Tiempo: ${_formatTime(timeRemaining)}',
                                      style: GoogleFonts.fredoka(
                                        fontSize: 14,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                  ],
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
                                icon: Icons.quiz,
                                label: 'Preguntas',
                                value: totalQuestions.toString(),
                                color: Colors.blue,
                              ),
                              _buildStat(
                                icon: Icons.check_circle,
                                label: 'Correctas',
                                value: correctAnswers.toString(),
                                color: Colors.green,
                              ),
                              _buildStat(
                                icon: Icons.percent,
                                label: 'Precisión',
                                value: '$accuracy%',
                                color: Colors.purple,
                              ),
                            ],
                          ),

                          // Mensaje de guardado
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '¡Puntuación guardada!',
                                style: GoogleFonts.fredoka(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Botones
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Column(
                        children: [
                          // Botón Ver Ranking (opcional, se puede agregar después)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                // TODO: Implementar navegación a ranking
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Ranking próximamente'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              icon: const Icon(Icons.leaderboard, size: 24),
                              label: Text(
                                'Ver Ranking',
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: primaryColor,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 4,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Botón Jugar de Nuevo
                          if (onPlayAgain != null)
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.pop(context);
                                  onPlayAgain!();
                                },
                                icon: const Icon(Icons.refresh, size: 24),
                                label: Text(
                                  'Jugar de Nuevo',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.shade600,
                                  foregroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                    horizontal: 24,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 4,
                                ),
                              ),
                            ),
                          const SizedBox(height: 16),

                          // Botón Volver al Inicio
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // Navegar al home (2 pops: dialog + game)
                                Navigator.pop(context);
                                context.pop();
                              },
                              icon: const Icon(Icons.home, size: 24),
                              label: Text(
                                'Volver al Inicio',
                                style: GoogleFonts.fredoka(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white,
                                side: const BorderSide(
                                  color: Colors.white,
                                  width: 2,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
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
          ),
        ),
      ),
    );
  }

  Widget _buildStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
