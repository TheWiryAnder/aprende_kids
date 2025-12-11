library;

/// Pantalla principal con las 4 categorías de juegos en una sola fila
///
/// Muestra: Puntuación total, Ranking, y 4 categorías horizontales
///
/// Autor: [Tu nombre]
/// Fecha: 2025

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';
import '../../bloc/auth/auth_bloc.dart';
import '../../bloc/auth/auth_event.dart';
import '../../bloc/auth/auth_state.dart';
import '../../../app/theme/colors.dart';
import '../../../domain/services/avatar_service.dart';
import '../../../domain/services/tutorial_service.dart';
import '../../widgets/avatar_widget.dart';
import '../../../app/utils/responsive_utils.dart';
import '../../widgets/welcome_video_overlay.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _hasShownWelcome = false;

  // Tutorial Coach Mark
  final TutorialService _tutorialService = TutorialService();
  TutorialCoachMark? _tutorialCoachMark;

  // ✅ SCROLL CONTROLLER: Para hacer scroll automático en el tutorial
  final ScrollController _scrollController = ScrollController();

  // GlobalKeys para los elementos del tutorial
  final GlobalKey _avatarKey = GlobalKey();
  final GlobalKey _categoriesKey = GlobalKey();
  final GlobalKey _gameCardsKey = GlobalKey(); // ✅ Key específica para tarjetas de juegos
  final GlobalKey _coinsKey = GlobalKey();

  // ✅ ÍNDICE DE NAVEGACIÓN: Para controlar qué pantalla está activa
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _checkAndShowTutorial();
  }

  /// Verifica si debe mostrar el tutorial y lo ejecuta
  Future<void> _checkAndShowTutorial() async {
    // Esperar un poco para que la UI se renderice completamente
    await Future<void>.delayed(const Duration(milliseconds: 1500));

    final hasSeenTutorial = await _tutorialService.hasSeenTutorial();

    if (!hasSeenTutorial && mounted) {
      _showTutorial();
    }
  }

  /// Hace scroll automático al elemento del tutorial
  /// Garantiza que el elemento esté visible antes de mostrar el globo
  Future<void> _scrollToTarget(GlobalKey key) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));

    if (key.currentContext != null) {
      await Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 600),
        alignment: 0.6, // ✅ REDUCIDO: 0.6 = menos scroll, solo hasta mostrar tarjetas
        curve: Curves.easeInOut,
      );

      // Esperar más tiempo para que el scroll termine y el contenido se estabilice
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
  }

  /// Crea y muestra el tutorial interactivo
  void _showTutorial() {
    final targets = _createTutorialTargets();

    _tutorialCoachMark = TutorialCoachMark(
      targets: targets,
      colorShadow: Colors.black,
      paddingFocus: 10,
      opacityShadow: 0.8,
      // ✅ SCROLL AUTOMÁTICO: Antes de mostrar cada paso, hacer scroll al elemento
      onClickTarget: (target) {
        // Identificar qué elemento se está mostrando y hacer scroll
        if (target.keyTarget != null) {
          _scrollToTarget(target.keyTarget!);
        }
      },
      onFinish: () {
        _tutorialService.markTutorialAsCompleted();
        print('✅ Tutorial completado');
      },
      onSkip: () {
        _tutorialService.markTutorialAsCompleted();
        print('⏭️ Tutorial omitido');
        return true;
      },
    );

    _tutorialCoachMark?.show(context: context);
  }

  /// Crea los targets (pasos) del tutorial
  List<TargetFocus> _createTutorialTargets() {
    return [
      // Paso 1: Bienvenida - Avatar
      TargetFocus(
        identify: "avatar_welcome",
        keyTarget: _avatarKey,
        shape: ShapeLightFocus.Circle,
        radius: 10,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTutorialContent(
                title: '¡Hola! 👋',
                description: 'Soy tu asistente. ¡Bienvenido a Aprende Kids! Aquí aprenderemos jugando.',
                icon: Icons.waving_hand,
                color: Colors.blue,
                onNext: controller.next,
                onSkip: controller.skip,
                showSkip: true,
              );
            },
          ),
        ],
      ),

      // Paso 2: Monedas y Puntos
      TargetFocus(
        identify: "coins_points",
        keyTarget: _coinsKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            builder: (context, controller) {
              return _buildTutorialContent(
                title: '¡Tus Premios! 💰',
                description: '¡Aquí verás tus monedas y puntos! Gana más completando lecciones y juegos.',
                icon: Icons.monetization_on,
                color: Colors.amber,
                onNext: controller.next,
                onSkip: controller.skip,
                showSkip: true,
              );
            },
          ),
        ],
      ),

      // Paso 3: Categorías de Aprendizaje
      TargetFocus(
        identify: "categories",
        keyTarget: _categoriesKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top, // ✅ CAMBIADO: top para que se vea el texto completo
            builder: (context, controller) {
              return _buildTutorialContent(
                title: 'Tus Materias 📚',
                description: 'Aquí tienes tus materias favoritas: Matemáticas, Lenguaje, Ciencias y más. ¡Toca una para empezar!',
                icon: Icons.school,
                color: Colors.green,
                onNext: () async {
                  // ✅ SCROLL AUTOMÁTICO: Antes de pasar al paso 4, hacer scroll a las tarjetas
                  await _scrollToTarget(_gameCardsKey);
                  controller.next();
                },
                onSkip: controller.skip,
                showSkip: true,
              );
            },
          ),
        ],
      ),

      // Paso 4: Tarjetas de Juegos (con scroll automático)
      TargetFocus(
        identify: "game_cards",
        keyTarget: _gameCardsKey,
        shape: ShapeLightFocus.RRect,
        radius: 10,
        enableOverlayTab: true,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            builder: (context, controller) {
              return _buildTutorialContent(
                title: '¡Hora de Jugar! 🎮',
                description: 'Cuando quieras distraerte, baja aquí para jugar Sopa de Letras, Clasifica y Gana, y ganar monedas extra.',
                icon: Icons.sports_esports,
                color: Colors.purple,
                onNext: () {
                  controller.next();
                },
                onSkip: controller.skip,
                showSkip: false,
                isLast: true,
              );
            },
          ),
        ],
      ),
    ];
  }

  /// Widget personalizado para el contenido del tutorial (estilo cómic)
  Widget _buildTutorialContent({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required VoidCallback onNext,
    required VoidCallback onSkip,
    bool showSkip = true,
    bool isLast = false,
  }) {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: color,
          width: 3,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header con icono y título
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 30,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.fredoka(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Descripción
          Text(
            description,
            style: GoogleFonts.fredoka(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),

          // Botones
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Botón Saltar
              if (showSkip)
                TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Saltar',
                    style: GoogleFonts.fredoka(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              const SizedBox(width: 12),

              // Botón Siguiente/Entendido
              ElevatedButton(
                onPressed: onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  isLast ? '¡Entendido!' : 'Siguiente',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tutorialCoachMark?.finish();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        // Si no está autenticado, redirigir a login
        if (state is! AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = state.user;

        // Mostrar video de bienvenida solo la primera vez
        if (!_hasShownWelcome) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() => _hasShownWelcome = true);
            WelcomeVideoOverlay.show(context);
          });
        }

        return Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF4A90E2),
                  Color(0xFF50E3C2),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Header con nombre
                  _buildHeader(context, user.displayName, user.avatarId),

                  // Contenido principal
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
                        controller: _scrollController,
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Puntuación y Ranking (con GlobalKey para tutorial)
                            Container(
                              key: _coinsKey,
                              child: _buildScoreAndRanking(context),
                            ),

                            const SizedBox(height: 32),

                            // Título
                            Text(
                              '¿Qué quieres aprender hoy?',
                              style: GoogleFonts.fredoka(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 24),

                            // Categorías en fila horizontal (con GlobalKey para tutorial)
                            Container(
                              key: _categoriesKey,
                              child: _buildCategoriesRow(context),
                            ),

                            const SizedBox(height: 48),

                            // Nueva sección: Zona de Juegos
                            _buildGamesZoneSection(context),

                            // ✅ COLCHÓN DE SCROLL: Espacio extra para que el tutorial
                            // pueda mostrar el globo completo en elementos inferiores
                            // AUMENTADO: 280px para dar espacio a la barra de navegación
                            const SizedBox(height: 280),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ✅ BARRA DE NAVEGACIÓN INFERIOR con estilo azul igual al header
          bottomNavigationBar: _buildBottomNavigationBar(context),
        );
      },
    );
  }

  Widget _buildGamesZoneSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Título de la sección
        Text(
          '¿Listo para un descanso?',
          style: GoogleFonts.fredoka(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Zona de Juegos - Diviértete sin presión',
          style: GoogleFonts.fredoka(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),

        // Juegos de distracción (con GlobalKey para tutorial)
        Container(
          key: _gameCardsKey,
          child: _buildFunGamesRow(context),
        ),
      ],
    );
  }

  Widget _buildFunGamesRow(BuildContext context) {
    final games = [
      {
        'id': 'word_search',
        'title': 'Sopa de Letras',
        'description': 'Encuentra las palabras ocultas',
        'icon': Icons.search,
        'color': const Color(0xFF9B59B6), // Violeta
      },
      {
        'id': 'emoji_sorting',
        'title': 'Clasifica y Gana',
        'description': 'Pon cada cosa en su lugar',
        'icon': Icons.category,
        'color': const Color(0xFF1ABC9C), // Turquesa
      },
    ];

    // ✅ CORRECCIÓN: En móvil 1 columna vertical, en desktop: Row horizontal
    if (context.isMobile) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // ✅ 1 columna en móvil
          childAspectRatio: 3.5, // ✅ Tarjeta horizontal ancha y baja
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: games.length,
        itemBuilder: (context, index) {
          final game = games[index];
          return _buildFunGameCard(
            context,
            id: game['id'] as String,
            title: game['title'] as String,
            description: game['description'] as String,
            icon: game['icon'] as IconData,
            color: game['color'] as Color,
          );
        },
      );
    }

    return Row(
      children: games.map((game) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 16),
            child: _buildFunGameCard(
              context,
              id: game['id'] as String,
              title: game['title'] as String,
              description: game['description'] as String,
              icon: game['icon'] as IconData,
              color: game['color'] as Color,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFunGameCard(
    BuildContext context, {
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    final isMobile = context.isMobile;

    return GestureDetector(
      onTap: () {
        if (id == 'word_search') {
          context.push('/word-search');
        } else if (id == 'emoji_sorting') {
          context.push('/emoji-sorting');
        }
      },
      child: Container(
        padding: EdgeInsets.all(isMobile ? 12 : 20),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: isMobile
            ? Row(
                children: [
                  // Icono en móvil
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 32,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Texto en móvil
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: GoogleFonts.fredoka(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userName, String avatarId) {
    final user = FirebaseAuth.instance.currentUser;
    final avatarService = AvatarService();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Avatar + Saludo (clickeable para ir al perfil)
          Expanded(
            child: GestureDetector(
              onTap: () => context.push('/profile'),
              child: Row(
                children: [
                  // Avatar con StreamBuilder (con GlobalKey para tutorial)
                  if (user != null)
                    Container(
                      key: _avatarKey,
                      child: StreamBuilder(
                        stream: avatarService.avatarStream(user.uid),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data != null) {
                            return SimpleAvatarWidget(
                              avatar: snapshot.data!,
                              size: 60,
                            );
                          }
                          // Placeholder mientras carga
                          return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 32,
                              color: AppColors.primary,
                            ),
                          );
                        },
                      ),
                    )
                  else
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.person,
                        size: 32,
                        color: AppColors.primary,
                      ),
                    ),
                  const SizedBox(width: 16),

                  // Saludo
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '¡Hola, $userName!',
                          style: GoogleFonts.fredoka(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Listo para aprender',
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
            ),
          ),

          // Widget de monedas (con StreamBuilder para actualización en tiempo real)
          if (user != null)
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                int coins = 0;
                if (snapshot.hasData && snapshot.data!.exists) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  coins = data?['coins'] as int? ?? 0;
                }

                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade400,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('💰', style: TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(
                        coins.toString(),
                        style: GoogleFonts.fredoka(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.brown.shade800,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

          // Botón de tienda
          IconButton(
            icon: const Icon(Icons.shopping_bag, color: Colors.white),
            iconSize: 28,
            onPressed: () => context.push('/shop'),
          ),

          // Botón de logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            iconSize: 28,
            onPressed: () {
              _showLogoutDialog(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildScoreAndRanking(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        int totalScore = 0;
        int gamesPlayed = 0;

        if (snapshot.hasData && snapshot.data!.exists) {
          final data = snapshot.data!.data() as Map<String, dynamic>;
          totalScore = (data['totalScore'] ?? 0) as int;
          gamesPlayed = (data['gamesPlayed'] ?? 0) as int;
        }

        return Row(
          children: [
            // Tarjeta de puntuación responsive
            Expanded(
              child: Container(
                padding: EdgeInsets.all(
                  context.responsive(mobile: 16.0, tablet: 18.0, desktop: 20.0),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFF9800)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.white,
                          size: context.responsive(mobile: 24.0, tablet: 28.0, desktop: 32.0),
                        ),
                        SizedBox(width: context.responsive(mobile: 6.0, tablet: 7.0, desktop: 8.0)),
                        Text(
                          'Mis Puntos',
                          style: GoogleFonts.fredoka(
                            fontSize: getResponsiveFontSize(
                              context,
                              mobile: 15.0,
                              tablet: 16.5,
                              desktop: 18.0,
                            ),
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: context.responsive(mobile: 8.0, tablet: 10.0, desktop: 12.0)),
                    Text(
                      '$totalScore',
                      style: GoogleFonts.fredoka(
                        fontSize: getResponsiveFontSize(
                          context,
                          mobile: 36.0,
                          tablet: 42.0,
                          desktop: 48.0,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: context.responsive(mobile: 2.0, tablet: 3.0, desktop: 4.0)),
                    Text(
                      '$gamesPlayed juegos jugados',
                      style: GoogleFonts.fredoka(
                        fontSize: getResponsiveFontSize(
                          context,
                          mobile: 11.0,
                          tablet: 12.5,
                          desktop: 14.0,
                        ),
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Botón de ranking responsive
            GestureDetector(
              onTap: () => context.push('/ranking'),
              child: Container(
                width: context.responsive(
                  mobile: 120.0,
                  tablet: 130.0,
                  desktop: 140.0,
                ),
                padding: EdgeInsets.symmetric(
                  vertical: context.responsive(mobile: 16.0, tablet: 18.0, desktop: 20.0),
                  horizontal: context.responsive(mobile: 12.0, tablet: 14.0, desktop: 16.0),
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF42A5F5), Color(0xFF2196F3)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emoji_events,
                      color: Colors.amber,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Ver\nRanking',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fredoka(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCategoriesRow(BuildContext context) {
    final categories = [
      {
        'id': 'math',
        'title': 'Matemáticas',
        'description': 'Números y operaciones divertidas',
        'icon': Icons.calculate,
        'gradient': [const Color(0xFF5C6AC4), const Color(0xFF4A5AB7)],
      },
      {
        'id': 'language',
        'title': 'Lenguaje',
        'description': 'Letras, palabras y lectura',
        'icon': Icons.abc,
        'gradient': [const Color(0xFFE74C3C), const Color(0xFFC0392B)],
      },
      {
        'id': 'science',
        'title': 'Ciencias',
        'description': 'Descubre el mundo',
        'icon': Icons.science,
        'gradient': [const Color(0xFF27AE60), const Color(0xFF229954)],
      },
      {
        'id': 'creativity',
        'title': 'Creatividad',
        'description': 'Arte, música y más',
        'icon': Icons.palette,
        'gradient': [const Color(0xFFF39C12), const Color(0xFFE67E22)],
      },
    ];

    // ✅ CORRECCIÓN: En móvil 1 columna vertical, en desktop: Row horizontal
    if (context.isMobile) {
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1, // ✅ 1 columna en móvil para ocupar todo el ancho
          childAspectRatio: 3.5, // ✅ Tarjeta horizontal ancha y baja
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            context,
            id: category['id'] as String,
            title: category['title'] as String,
            description: category['description'] as String,
            icon: category['icon'] as IconData,
            gradient: category['gradient'] as List<Color>,
          );
        },
      );
    }

    // Desktop: Row horizontal
    return Row(
      children: categories.asMap().entries.map((entry) {
        final index = entry.key;
        final category = entry.value;

        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: index < categories.length - 1 ? 16 : 0),
            child: _buildCategoryCard(
              context,
              id: category['id'] as String,
              title: category['title'] as String,
              description: category['description'] as String,
              icon: category['icon'] as IconData,
              gradient: category['gradient'] as List<Color>,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context, {
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradient,
  }) {
    final isMobile = context.isMobile;

    return GestureDetector(
      onTap: () {
        context.push('/games/$id');
      },
      child: Container(
        height: isMobile ? null : context.responsive(
          mobile: 220.0,
          tablet: 250.0,
          desktop: 280.0,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(isMobile ? 16 : 32),
          boxShadow: [
            BoxShadow(
              color: gradient[0].withValues(alpha: 0.4),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(
            context.responsive(mobile: 12.0, tablet: 20.0, desktop: 24.0),
          ),
          child: isMobile
              ? Row(
                  children: [
                    // Icono en móvil
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: 28,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Texto en móvil
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.fredoka(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            description,
                            style: GoogleFonts.fredoka(
                              fontSize: 12,
                              color: Colors.white.withValues(alpha: 0.9),
                              height: 1.2,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Icono grande responsive
                    Container(
                      width: context.responsive(mobile: 60.0, tablet: 80.0, desktop: 100.0),
                      height: context.responsive(mobile: 60.0, tablet: 80.0, desktop: 100.0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.25),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        icon,
                        size: context.responsive(mobile: 32.0, tablet: 44.0, desktop: 56.0),
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: context.responsive(mobile: 12.0, tablet: 16.0, desktop: 20.0)),

                    // Título grande responsive
                    Text(
                      title,
                      style: GoogleFonts.fredoka(
                        fontSize: getResponsiveFontSize(
                          context,
                          mobile: 18.0,
                          tablet: 21.0,
                          desktop: 24.0,
                        ),
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 0.5,
                        height: 1.1,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: context.responsive(mobile: 6.0, tablet: 7.0, desktop: 8.0)),

                    // Descripción responsive
                    Text(
                      description,
                      style: GoogleFonts.fredoka(
                        fontSize: getResponsiveFontSize(
                          context,
                          mobile: 12.0,
                          tablet: 13.5,
                          desktop: 15.0,
                        ),
                        color: Colors.white.withValues(alpha: 0.95),
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  /// ✅ BARRA DE NAVEGACIÓN INFERIOR
  /// Estilo azul igual al header superior con bordes redondeados superiores
  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF4A90E2), // Mismo azul del header
            Color(0xFF50E3C2), // Mismo gradiente del header
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30), // Bordes redondeados superiores
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 15,
            offset: const Offset(0, -5), // Sombra hacia arriba
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // Botón Inicio
              _buildNavButton(
                icon: Icons.home,
                label: 'Inicio',
                index: 0,
                onTap: () {
                  setState(() => _currentIndex = 0);
                  // Ya estamos en Home, no hacer nada
                },
              ),

              // Botón Ranking
              _buildNavButton(
                icon: Icons.emoji_events,
                label: 'Ranking',
                index: 1,
                onTap: () {
                  setState(() => _currentIndex = 1);
                  context.push('/ranking');
                },
              ),

              // Botón Perfil
              _buildNavButton(
                icon: Icons.person,
                label: 'Perfil',
                index: 2,
                onTap: () {
                  setState(() => _currentIndex = 2);
                  context.push('/profile');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget para cada botón de navegación
  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required int index,
    required VoidCallback onTap,
  }) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icono
          Icon(
            icon,
            size: isSelected ? 32 : 28,
            color: isSelected
                ? Colors.amber.shade300 // Color dorado cuando está seleccionado
                : Colors.white.withValues(alpha: 0.7), // Blanco con opacidad cuando no está seleccionado
          ),
          const SizedBox(height: 4),
          // Label
          Text(
            label,
            style: GoogleFonts.fredoka(
              fontSize: isSelected ? 13 : 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Colors.amber.shade300
                  : Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          '¿Salir?',
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          '¿Estás seguro que quieres salir?',
          style: GoogleFonts.fredoka(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancelar',
              style: GoogleFonts.fredoka(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<AuthBloc>().add(AuthLogoutRequested());
              context.go('/login');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Salir',
              style: GoogleFonts.fredoka(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
