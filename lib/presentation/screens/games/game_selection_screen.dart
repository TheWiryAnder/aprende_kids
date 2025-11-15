library;

/// Pantalla de selección de juegos por categoría
///
/// Muestra todos los juegos disponibles de una categoría específica
///
/// Autor: [Tu nombre]
/// Fecha: 2025

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/colors.dart';
import '../../../app/utils/responsive_utils.dart';

class GameSelectionScreen extends StatelessWidget {
  final String categoryId;

  const GameSelectionScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    // Datos de los juegos según categoría
    final games = _getGamesByCategory(categoryId);
    final categoryInfo = _getCategoryInfo(categoryId);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: categoryInfo['gradient'] as List<Color>,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header con botón de regreso
              _buildHeader(context, categoryInfo),

              // Grid de juegos
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 1000),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            // Grid responsive según ancho
                            final crossAxisCount = getGridCrossAxisCount(
                              constraints.maxWidth,
                              minItemWidth: 180,
                            );

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                childAspectRatio: context.responsive(
                                  mobile: 0.65,
                                  tablet: 0.75,
                                  desktop: 0.80,
                                ),
                                crossAxisSpacing: context.responsive(
                                  mobile: 12.0,
                                  tablet: 16.0,
                                  desktop: 20.0,
                                ),
                                mainAxisSpacing: context.responsive(
                                  mobile: 12.0,
                                  tablet: 16.0,
                                  desktop: 20.0,
                                ),
                              ),
                              itemCount: games.length,
                              itemBuilder: (context, index) {
                                final game = games[index];
                                return _buildGameBlock(context, game, categoryInfo);
                              },
                            );
                          },
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
  }

  Widget _buildHeader(BuildContext context, Map<String, dynamic> categoryInfo) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Botón de regreso
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 12),

          // Icono de categoría
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              categoryInfo['icon'] as IconData,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),

          // Título
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  categoryInfo['title'] as String,
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${(categoryInfo['games'] as List).length} juegos disponibles',
                  style: GoogleFonts.fredoka(
                    fontSize: 14,
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

  Widget _buildGameBlock(
    BuildContext context,
    Map<String, dynamic> game,
    Map<String, dynamic> categoryInfo,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Navegar al juego específico
            context.push('/play/${game['id']}');
          },
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: EdgeInsets.all(
              context.responsive(mobile: 12.0, tablet: 16.0, desktop: 20.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icono del juego con gradiente - Responsive
                Container(
                  width: context.responsive(mobile: 70.0, tablet: 85.0, desktop: 100.0),
                  height: context.responsive(mobile: 70.0, tablet: 85.0, desktop: 100.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: categoryInfo['gradient'] as List<Color>,
                    ),
                    borderRadius: BorderRadius.circular(
                      context.responsive(mobile: 16.0, tablet: 20.0, desktop: 24.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (categoryInfo['gradient'] as List<Color>)[0]
                            .withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    game['icon'] as IconData,
                    color: Colors.white,
                    size: context.responsive(mobile: 35.0, tablet: 42.0, desktop: 50.0),
                  ),
                ),

                SizedBox(height: context.responsive(mobile: 8.0, tablet: 12.0, desktop: 14.0)),

                // Título del juego - Responsive
                Text(
                  game['title'] as String,
                  style: GoogleFonts.fredoka(
                    fontSize: getResponsiveFontSize(
                      context,
                      mobile: 15.0,
                      tablet: 18.0,
                      desktop: 21.0,
                    ),
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    height: 1.1,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: context.responsive(mobile: 4.0, tablet: 6.0, desktop: 8.0)),

                // Descripción - Más compacta
                Flexible(
                  child: Text(
                    game['description'] as String,
                    style: GoogleFonts.fredoka(
                      fontSize: getResponsiveFontSize(
                        context,
                        mobile: 11.0,
                        tablet: 13.0,
                        desktop: 14.0,
                      ),
                      color: AppColors.textSecondary,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                SizedBox(height: context.responsive(mobile: 6.0, tablet: 8.0, desktop: 10.0)),

                // Badges de edad y dificultad - Compactos y sin overflow
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Badge de edad - Flexible
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.responsive(mobile: 6.0, tablet: 8.0, desktop: 10.0),
                          vertical: context.responsive(mobile: 4.0, tablet: 5.0, desktop: 6.0),
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person,
                              size: context.responsive(mobile: 13.0, tablet: 14.0, desktop: 15.0),
                              color: AppColors.primary,
                            ),
                            SizedBox(width: context.responsive(mobile: 3.0, tablet: 4.0, desktop: 5.0)),
                            Flexible(
                              child: Text(
                                game['ageRange'] as String,
                                style: GoogleFonts.fredoka(
                                  fontSize: getResponsiveFontSize(
                                    context,
                                    mobile: 10.0,
                                    tablet: 11.5,
                                    desktop: 13.0,
                                  ),
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: context.responsive(mobile: 4.0, tablet: 6.0, desktop: 8.0)),

                    // Badge de dificultad - Flexible
                    Flexible(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.responsive(mobile: 6.0, tablet: 8.0, desktop: 10.0),
                          vertical: context.responsive(mobile: 4.0, tablet: 5.0, desktop: 6.0),
                        ),
                        decoration: BoxDecoration(
                          color: _getDifficultyColor(game['difficulty'] as int)
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            game['difficulty'] as int,
                            (index) => Icon(
                              Icons.star,
                              size: context.responsive(mobile: 12.0, tablet: 13.5, desktop: 15.0),
                              color: _getDifficultyColor(game['difficulty'] as int),
                            ),
                          ),
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
    );
  }

  Color _getDifficultyColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return const Color(0xFF27AE60); // Verde - Fácil
      case 2:
        return const Color(0xFFF39C12); // Naranja - Medio
      case 3:
        return const Color(0xFFE74C3C); // Rojo - Difícil
      default:
        return AppColors.primary;
    }
  }

  Map<String, dynamic> _getCategoryInfo(String categoryId) {
    final categories = {
      'math': {
        'title': 'Matemáticas',
        'icon': Icons.calculate,
        'gradient': [const Color(0xFF5C6AC4), const Color(0xFF4A5AB7)],
        'games': _getMathGames(),
      },
      'language': {
        'title': 'Lenguaje',
        'icon': Icons.abc,
        'gradient': [const Color(0xFFE74C3C), const Color(0xFFC0392B)],
        'games': _getLanguageGames(),
      },
      'science': {
        'title': 'Ciencias',
        'icon': Icons.science,
        'gradient': [const Color(0xFF27AE60), const Color(0xFF229954)],
        'games': _getScienceGames(),
      },
      'creativity': {
        'title': 'Creatividad',
        'icon': Icons.palette,
        'gradient': [const Color(0xFFF39C12), const Color(0xFFE67E22)],
        'games': _getCreativityGames(),
      },
    };

    return categories[categoryId] ?? categories['math']!;
  }

  List<Map<String, dynamic>> _getGamesByCategory(String categoryId) {
    switch (categoryId) {
      case 'math':
        return _getMathGames();
      case 'language':
        return _getLanguageGames();
      case 'science':
        return _getScienceGames();
      case 'creativity':
        return _getCreativityGames();
      default:
        return <Map<String, dynamic>>[];
    }
  }

  List<Map<String, dynamic>> _getMathGames() {
    return [
      {
        'id': 'suma_aventurera',
        'title': 'Suma Aventurera',
        'description': 'Resuelve sumas simples para ayudar a un personaje a recolectar tesoros',
        'icon': Icons.add_circle,
        'ageRange': '6-8 años',
        'difficulty': 1,
      },
      {
        'id': 'resta_magica',
        'title': 'Resta Mágica',
        'description': 'Ayuda al mago a resolver restas para crear pociones',
        'icon': Icons.remove_circle,
        'ageRange': '6-8 años',
        'difficulty': 1,
      },
      {
        'id': 'multiplicacion_espacial',
        'title': 'Multiplicación Espacial',
        'description': 'Viaja por el espacio resolviendo tablas de multiplicar',
        'icon': Icons.rocket_launch,
        'ageRange': '8-10 años',
        'difficulty': 2,
      },
      {
        'id': 'division_detective',
        'title': 'División Detective',
        'description': 'Resuelve divisiones para encontrar pistas y resolver casos',
        'icon': Icons.search,
        'ageRange': '9-12 años',
        'difficulty': 3,
      },
      {
        'id': 'numeros_perdidos',
        'title': 'Números Perdidos',
        'description': 'Encuentra el número que falta en secuencias y patrones',
        'icon': Icons.quiz,
        'ageRange': '7-10 años',
        'difficulty': 2,
      },
      {
        'id': 'geometria_constructora',
        'title': 'Geometría Constructora',
        'description': 'Construye edificios identificando figuras geométricas',
        'icon': Icons.category,
        'ageRange': '8-12 años',
        'difficulty': 2,
      },
    ];
  }

  List<Map<String, dynamic>> _getLanguageGames() {
    return [
      {
        'id': 'cazador_vocales',
        'title': 'Cazador de Vocales',
        'description': 'Identifica y selecciona las vocales en palabras simples',
        'icon': Icons.abc,
        'ageRange': '6-7 años',
        'difficulty': 1,
      },
      {
        'id': 'constructor_palabras',
        'title': 'Constructor de Palabras',
        'description': 'Forma palabras correctas seleccionando sílabas',
        'icon': Icons.build,
        'ageRange': '7-9 años',
        'difficulty': 1,
      },
      {
        'id': 'rima_magica',
        'title': 'Rima Mágica',
        'description': 'Encuentra palabras que riman entre sí',
        'icon': Icons.music_note,
        'ageRange': '7-9 años',
        'difficulty': 2,
      },
      {
        'id': 'detectives_ortografia',
        'title': 'Detectives de Ortografía',
        'description': 'Encuentra y corrige errores ortográficos en oraciones',
        'icon': Icons.spellcheck,
        'ageRange': '8-10 años',
        'difficulty': 2,
      },
      {
        'id': 'sinonimos_antonimos',
        'title': 'Sinónimos y Antónimos',
        'description': 'Relaciona palabras con sus sinónimos o antónimos',
        'icon': Icons.compare_arrows,
        'ageRange': '9-11 años',
        'difficulty': 2,
      },
      {
        'id': 'aventura_comprension',
        'title': 'Aventura de Comprensión',
        'description': 'Lee textos cortos y responde preguntas de comprensión',
        'icon': Icons.auto_stories,
        'ageRange': '10-12 años',
        'difficulty': 3,
      },
    ];
  }

  List<Map<String, dynamic>> _getScienceGames() {
    return [
      {
        'id': 'exploradores_cuerpo',
        'title': 'Exploradores del Cuerpo Humano',
        'description': 'Identifica las partes del cuerpo humano y sus funciones básicas',
        'icon': Icons.accessibility_new,
        'ageRange': '6-8 años',
        'difficulty': 1,
      },
      {
        'id': 'cadena_alimenticia',
        'title': 'Cadena Alimenticia',
        'description': 'Ordena correctamente los elementos de una cadena alimenticia',
        'icon': Icons.grass,
        'ageRange': '7-9 años',
        'difficulty': 1,
      },
      {
        'id': 'estados_materia',
        'title': 'Estados de la Materia',
        'description': 'Clasifica objetos según su estado: sólido, líquido o gaseoso',
        'icon': Icons.science,
        'ageRange': '8-10 años',
        'difficulty': 2,
      },
      {
        'id': 'planeta_tierra',
        'title': 'Planeta Tierra',
        'description': 'Responde preguntas sobre el planeta, clima y fenómenos naturales',
        'icon': Icons.public,
        'ageRange': '8-10 años',
        'difficulty': 2,
      },
      {
        'id': 'ecosistemas_mundo',
        'title': 'Ecosistemas del Mundo',
        'description': 'Relaciona animales y plantas con sus ecosistemas correctos',
        'icon': Icons.park,
        'ageRange': '9-11 años',
        'difficulty': 2,
      },
      {
        'id': 'sistema_solar',
        'title': 'Sistema Solar',
        'description': 'Aprende sobre planetas y sus características',
        'icon': Icons.rocket_launch,
        'ageRange': '10-12 años',
        'difficulty': 3,
      },
    ];
  }

  List<Map<String, dynamic>> _getCreativityGames() {
    return [
      {
        'id': 'mezcla_colores',
        'title': 'Mezcla de Colores',
        'description': 'Aprende a mezclar colores primarios para crear colores secundarios',
        'icon': Icons.palette,
        'ageRange': '6-8 años',
        'difficulty': 1,
      },
      {
        'id': 'completa_patron',
        'title': 'Completa el Patrón',
        'description': 'Identifica y completa patrones visuales con formas y colores',
        'icon': Icons.pattern,
        'ageRange': '7-9 años',
        'difficulty': 1,
      },
      {
        'id': 'historias_locas',
        'title': 'Historias Locas',
        'description': 'Completa historias eligiendo palabras creativas y divertidas',
        'icon': Icons.menu_book,
        'ageRange': '8-10 años',
        'difficulty': 2,
      },
      {
        'id': 'asociacion_creativa',
        'title': 'Asociación Creativa',
        'description': 'Conecta objetos o conceptos de formas creativas e inusuales',
        'icon': Icons.psychology,
        'ageRange': '8-10 años',
        'difficulty': 2,
      },
      {
        'id': 'artista_emojis',
        'title': 'Artista de Emojis',
        'description': 'Interpreta y crea representaciones visuales usando emojis',
        'icon': Icons.insert_emoticon,
        'ageRange': '9-11 años',
        'difficulty': 2,
      },
      {
        'id': 'inventor_palabras',
        'title': 'Inventor de Palabras',
        'description': 'Combina palabras para crear nuevas palabras inventadas',
        'icon': Icons.lightbulb,
        'ageRange': '10-12 años',
        'difficulty': 3,
      },
    ];
  }
}
