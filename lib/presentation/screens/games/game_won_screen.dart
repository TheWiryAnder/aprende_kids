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
    final isMobile = MediaQuery.of(context).size.width < 800;

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
            child: isMobile ? _buildMobileLayout(accuracy) : _buildDesktopLayout(accuracy),
          ),
        ),
      ),
    );
  }

  /// Layout móvil: Vertical (GIF arriba, Card abajo)
  Widget _buildMobileLayout(int accuracy) {
    return Builder(
      builder: (context) => Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // GIF de celebración
              const GameVideoWidget(
                videoType: GameVideoType.excelente,
                width: 200,
                height: 200,
              ),
              const SizedBox(height: 24),

              // Tarjeta de resultados
              _buildResultsCard(accuracy),

              const SizedBox(height: 24),

              // Botones
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Layout desktop: Horizontal (GIF izquierda 35%, Card derecha 65%)
  Widget _buildDesktopLayout(int accuracy) {
    return Builder(
      builder: (context) => Row(
        children: [
          // COLUMNA IZQUIERDA (35%): Avatar de Celebración
          Expanded(
            flex: 35,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    // GIF grande y festivo, sin tarjeta
                    final gifSize = constraints.maxWidth * 0.8;
                    return GameVideoWidget(
                      videoType: GameVideoType.excelente,
                      width: gifSize.clamp(200, 400),
                      height: gifSize.clamp(200, 400),
                    );
                  },
                ),
              ),
            ),
          ),

          // COLUMNA DERECHA (65%): Tarjeta de Resultados
          Expanded(
            flex: 65,
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildResultsCard(accuracy),
                      const SizedBox(height: 32),
                      _buildActionButtons(context),
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

  /// Tarjeta blanca con todos los resultados
  Widget _buildResultsCard(int accuracy) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título principal
          Text(
            '¡Juego Completado!',
            style: GoogleFonts.fredoka(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // Subtítulo (nombre del juego)
          Text(
            gameTitle,
            style: GoogleFonts.fredoka(
              fontSize: 20,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),

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

          // Puntuación grande
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
                score.toString(),
                style: GoogleFonts.fredoka(
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  height: 1.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Monedas ganadas (Botón amarillo)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.amber.shade400,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💰', style: TextStyle(fontSize: 36)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '+$coins monedas',
                      style: GoogleFonts.fredoka(
                        fontSize: 26,
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
          const SizedBox(height: 32),

          // Estadísticas (Preguntas/Aciertos/Precisión)
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
    );
  }

  /// Botones de acción (Ranking, Jugar de Nuevo, Inicio)
  Widget _buildActionButtons(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        children: [
          // Botón Ver Ranking
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementar navegación a ranking
                // ScaffoldMessenger no disponible aquí, ignorar por ahora
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
