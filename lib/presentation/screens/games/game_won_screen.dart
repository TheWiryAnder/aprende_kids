import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../widgets/game_video_widget.dart';
import '../../../domain/services/user_stats_service.dart';

/// Pantalla de victoria unificada para todos los juegos
class GameWonScreen extends StatefulWidget {
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

  @override
  State<GameWonScreen> createState() => _GameWonScreenState();
}

class _GameWonScreenState extends State<GameWonScreen> {
  final UserStatsService _userStatsService = UserStatsService();
  bool _statsUpdated = false;

  @override
  void initState() {
    super.initState();
    _updateUserStats();
  }

  /// Actualiza las estadísticas del usuario en Firebase
  Future<void> _updateUserStats() async {
    if (_statsUpdated) return; // Prevenir actualizaciones duplicadas

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print('⚠️ Usuario no autenticado, no se pueden actualizar estadísticas');
      return;
    }

    try {
      await _userStatsService.updateUserStatsAfterGame(
        userId: user.uid,
        coinsEarned: widget.coins,
        scoreEarned: widget.score,
      );

      setState(() {
        _statsUpdated = true;
      });
    } catch (e) {
      print('❌ Error al actualizar estadísticas: $e');
    }
  }

  /// Calcula el número de estrellas según el porcentaje de aciertos
  int get stars {
    final accuracy = (widget.correctAnswers / widget.totalQuestions) * 100;
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
    final accuracy = ((widget.correctAnswers / widget.totalQuestions) * 100).round();
    final isMobile = MediaQuery.of(context).size.width < 800;

    return PopScope(
      canPop: false, // Prevenir back button
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.primaryColor, widget.accentColor],
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // GIF de celebración MÁS GRANDE
              const GameVideoWidget(
                videoType: GameVideoType.excelente,
                width: 320,
                height: 320,
              ),
              const SizedBox(height: 16),

              // Tarjeta de resultados
              _buildResultsCard(accuracy, isMobile: true),

              const SizedBox(height: 16),

              // Botones
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  /// Layout desktop: Horizontal (GIF izquierda 40%, Card derecha 60%)
  /// Patrón "Contenedor de Referencia": Diseño fijo que escala proporcionalmente
  Widget _buildDesktopLayout(int accuracy) {
    return Builder(
      builder: (context) {
        return Container(
          width: double.infinity,
          height: double.infinity,
          alignment: Alignment.center, // Centrado crítico
          child: FittedBox(
            fit: BoxFit.scaleDown, // Solo reduce si no cabe, no estira
            alignment: Alignment.center, // Centrado explícito
            child: SizedBox(
              width: 1200, // Incrementado para más espacio
              height: 750,  // Incrementado para mejor proporción vertical
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // COLUMNA IZQUIERDA (40%): Avatar de Celebración - EXTRA GRANDE
                  Expanded(
                    flex: 40,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: GameVideoWidget(
                          videoType: GameVideoType.excelente,
                          width: 450,
                          height: 450,
                        ),
                      ),
                    ),
                  ),

                  // COLUMNA DERECHA (60%): Tarjeta de Resultados + Botones
                  Expanded(
                    flex: 60,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 600),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _buildResultsCard(accuracy, isMobile: false),
                                const SizedBox(height: 28),
                                _buildActionButtons(context),
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
          ),
        );
      },
    );
  }

  /// Tarjeta blanca con todos los resultados
  Widget _buildResultsCard(int accuracy, {bool isMobile = false}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 18 : 22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Título principal
          Text(
            '¡Juego Completado!',
            style: GoogleFonts.fredoka(
              fontSize: isMobile ? 24 : 26,
              fontWeight: FontWeight.bold,
              color: widget.primaryColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Subtítulo (nombre del juego)
          Text(
            widget.gameTitle,
            style: GoogleFonts.fredoka(
              fontSize: isMobile ? 15 : 16,
              color: Colors.grey.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),

          // Mensaje motivacional
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16 : 18,
              vertical: isMobile ? 8 : 9,
            ),
            decoration: BoxDecoration(
              color: Colors.amber.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              motivationalMessage,
              style: GoogleFonts.fredoka(
                fontSize: isMobile ? 15 : 16,
                fontWeight: FontWeight.bold,
                color: Colors.amber.shade900,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: isMobile ? 14 : 16),

          // Estrellas
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: isMobile ? 5 : 6),
                child: Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  size: isMobile ? 44 : 48,
                  color: index < stars
                      ? Colors.amber.shade600
                      : Colors.grey.shade300,
                ),
              ),
            ),
          ),
          SizedBox(height: isMobile ? 16 : 18),

          // Puntuación grande
          Column(
            children: [
              Text(
                'Puntuación',
                style: GoogleFonts.fredoka(
                  fontSize: isMobile ? 13 : 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.score.toString(),
                style: GoogleFonts.fredoka(
                  fontSize: isMobile ? 44 : 48,
                  fontWeight: FontWeight.bold,
                  color: widget.primaryColor,
                  height: 1.0,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 14 : 16),

          // Monedas ganadas (Botón amarillo)
          Container(
            padding: EdgeInsets.all(isMobile ? 12 : 13),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.amber.shade400,
                width: 2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('💰', style: TextStyle(fontSize: isMobile ? 26 : 28)),
                SizedBox(width: isMobile ? 8 : 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '+${widget.coins} monedas',
                      style: GoogleFonts.fredoka(
                        fontSize: isMobile ? 18 : 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber.shade900,
                      ),
                    ),
                    Text(
                      'Tiempo: ${_formatTime(widget.timeRemaining)}',
                      style: GoogleFonts.fredoka(
                        fontSize: isMobile ? 11 : 12,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: isMobile ? 16 : 18),

          // Estadísticas (Preguntas/Aciertos/Precisión)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildStat(
                icon: Icons.quiz,
                label: 'Preguntas',
                value: widget.totalQuestions.toString(),
                color: Colors.blue,
              ),
              _buildStat(
                icon: Icons.check_circle,
                label: 'Correctas',
                value: widget.correctAnswers.toString(),
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
          SizedBox(height: isMobile ? 14 : 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.green.shade600,
                size: isMobile ? 15 : 16,
              ),
              SizedBox(width: isMobile ? 5 : 6),
              Text(
                '¡Puntuación guardada!',
                style: GoogleFonts.fredoka(
                  fontSize: isMobile ? 12 : 13,
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
    final isMobile = MediaQuery.of(context).size.width < 800;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: isMobile ? 450 : 550),
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
              icon: Icon(Icons.leaderboard, size: isMobile ? 20 : 22),
              label: Text(
                'Ver Ranking',
                style: GoogleFonts.fredoka(
                  fontSize: isMobile ? 16 : 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: widget.primaryColor,
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 14 : 15,
                  horizontal: isMobile ? 20 : 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 3,
              ),
            ),
          ),
          SizedBox(height: isMobile ? 12 : 14),

          // Botón Jugar de Nuevo
          if (widget.onPlayAgain != null)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onPlayAgain!();
                },
                icon: Icon(Icons.refresh, size: isMobile ? 20 : 22),
                label: Text(
                  'Jugar de Nuevo',
                  style: GoogleFonts.fredoka(
                    fontSize: isMobile ? 16 : 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 14 : 15,
                    horizontal: isMobile ? 20 : 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 3,
                ),
              ),
            ),
          SizedBox(height: isMobile ? 12 : 14),

          // Botón Volver al Inicio
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // Navegar al home (2 pops: dialog + game)
                Navigator.pop(context);
                context.pop();
              },
              icon: Icon(Icons.home, size: isMobile ? 20 : 22),
              label: Text(
                'Volver al Inicio',
                style: GoogleFonts.fredoka(
                  fontSize: isMobile ? 16 : 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(
                  color: Colors.white,
                  width: 2,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: isMobile ? 14 : 15,
                  horizontal: isMobile ? 20 : 24,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
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
        Icon(icon, color: color, size: 24), // Reducido de 32
        const SizedBox(height: 6), // Reducido de 8
        Text(
          value,
          style: GoogleFonts.fredoka(
            fontSize: 18, // Reducido de 24
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.fredoka(
            fontSize: 11, // Reducido de 14
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
