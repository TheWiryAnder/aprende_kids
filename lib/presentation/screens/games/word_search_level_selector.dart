import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../domain/models/word_search_model.dart';
import 'word_search_game.dart';

class WordSearchLevelSelector extends StatelessWidget {
  const WordSearchLevelSelector({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.purple.shade400,
              Colors.purple.shade700,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: _buildLevelCards(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sopa de Letras',
                  style: GoogleFonts.fredoka(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'Elige tu nivel de dificultad',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCards(BuildContext context) {
    final levelCards = [
      _buildLevelCard(
        context: context,
        level: WordSearchLevel.basico,
        title: 'Básico',
        description: '3-5 palabras\nCuadrícula 8x8',
        icon: Icons.grade,
        color: Colors.green,
        stars: 1,
      ),
      _buildLevelCard(
        context: context,
        level: WordSearchLevel.intermedio,
        title: 'Intermedio',
        description: '6-8 palabras\nCuadrícula 10x10',
        icon: Icons.stars,
        color: Colors.orange,
        stars: 2,
      ),
      _buildLevelCard(
        context: context,
        level: WordSearchLevel.avanzado,
        title: 'Avanzado',
        description: '10-12 palabras\nCuadrícula 12x12',
        icon: Icons.emoji_events,
        color: Colors.red,
        stars: 3,
      ),
    ];

    // Siempre mostrar verticalmente, centrado
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        levelCards[0],
        const SizedBox(height: 20),
        levelCards[1],
        const SizedBox(height: 20),
        levelCards[2],
      ],
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required WordSearchLevel level,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required int stars,
  }) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: InkWell(
        onTap: () {
          Navigator.push<void>(
            context,
            MaterialPageRoute<void>(
              builder: (context) => WordSearchGame(level: level),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
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
          child: Row(
            children: [
              // Icono
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  icon,
                  size: 48,
                  color: color,
                ),
              ),
              const SizedBox(width: 20),

              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        ...List.generate(
                          stars,
                          (index) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      description,
                      style: GoogleFonts.fredoka(
                        fontSize: 14,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Flecha
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey.shade400,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
