/// Configuración de rutas de la aplicación
///
/// Usa GoRouter para navegación declarativa
/// Incluye guards de autenticación y rutas anidadas
///
/// Autor: [Tu nombre]
/// Fecha: 2025

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';
import '../presentation/screens/auth/register_screen.dart';
import '../presentation/screens/auth/avatar_selection_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/games/game_selection_screen.dart';
import '../presentation/screens/games/suma_aventurera_game.dart';
import '../presentation/screens/games/resta_magica_game.dart';
import '../presentation/screens/games/multiplicacion_espacial_game.dart';
import '../presentation/screens/games/division_detective_game.dart';
import '../presentation/screens/games/numeros_perdidos_game.dart';
import '../presentation/screens/games/geometria_constructora_game.dart';
import '../presentation/screens/games/cazador_vocales_game.dart';
import '../presentation/screens/games/constructor_palabras_game.dart';
import '../presentation/screens/games/rima_magica_game.dart';
import '../presentation/screens/games/detectives_ortografia_game.dart';
import '../presentation/screens/games/sinonimos_antonimos_game.dart';
import '../presentation/screens/games/aventura_comprension_game.dart';
import '../presentation/screens/games/exploradores_cuerpo_game.dart';
import '../presentation/screens/games/cadena_alimenticia_game.dart';
import '../presentation/screens/games/estados_materia_game.dart';
import '../presentation/screens/games/planeta_tierra_game.dart';
import '../presentation/screens/games/ecosistemas_mundo_game.dart';
import '../presentation/screens/games/sistema_solar_game.dart';
import '../presentation/screens/games/mezcla_colores_game.dart';
import '../presentation/screens/games/completa_patron_game.dart';
import '../presentation/screens/games/historias_locas_game.dart';
import '../presentation/screens/games/asociacion_creativa_game.dart';
import '../presentation/screens/games/artista_emojis_game.dart';
import '../presentation/screens/games/inventor_palabras_game.dart';
import '../presentation/screens/games/game_results_screen.dart';
import '../presentation/screens/ranking/ranking_screen.dart';
import '../presentation/screens/profile/profile_screen.dart';
import '../presentation/screens/shop/avatar_shop_screen.dart';
import '../presentation/screens/rewards/rewards_screen.dart';
import '../presentation/screens/parental/parental_dashboard.dart';
import '../presentation/screens/games/word_search_level_selector.dart';
import '../presentation/screens/games/emoji_sorting_level_selector.dart';

class AppRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),

      // Auth Routes
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/avatar-selection',
        name: 'avatar-selection',
        builder: (context, state) => const AvatarSelectionScreen(),
      ),

      // Home
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Games
      GoRoute(
        path: '/games/:categoryId',
        name: 'game-selection',
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          return GameSelectionScreen(categoryId: categoryId);
        },
      ),
      GoRoute(
        path: '/play/:gameId',
        name: 'play-game',
        builder: (context, state) {
          final gameId = state.pathParameters['gameId']!;
          // Mapear gameId a la pantalla correspondiente
          switch (gameId) {
            // Juegos de Matemáticas
            case 'suma_aventurera':
              return const SumaAventureraGame();
            case 'resta_magica':
              return const RestaMagicaGame();
            case 'multiplicacion_espacial':
              return const MultiplicacionEspacialGame();
            case 'division_detective':
              return const DivisionDetectiveGame();
            case 'numeros_perdidos':
              return const NumerosPerdidosGame();
            case 'geometria_constructora':
              return const GeometriaConstructoraGame();
            // Juegos de Lenguaje
            case 'cazador_vocales':
              return const CazadorVocalesGame();
            case 'constructor_palabras':
              return const ConstructorPalabrasGame();
            case 'rima_magica':
              return const RimaMagicaGame();
            case 'detectives_ortografia':
              return const DetectivesOrtografiaGame();
            case 'sinonimos_antonimos':
              return const SinonimosAntonimosGame();
            case 'aventura_comprension':
              return const AventuraComprensionGame();
            // Juegos de Ciencias
            case 'exploradores_cuerpo':
              return const ExploradoresCuerpoGame();
            case 'cadena_alimenticia':
              return const CadenaAlimenticiaGame();
            case 'estados_materia':
              return const EstadosMateriaGame();
            case 'planeta_tierra':
              return const PlanetaTierraGame();
            case 'ecosistemas_mundo':
              return const EcosistemasMundoGame();
            case 'sistema_solar':
              return const SistemaSolarGame();
            // Juegos de Creatividad
            case 'mezcla_colores':
              return const MezclaColoresGame();
            case 'completa_patron':
              return const CompletaPatronGame();
            case 'historias_locas':
              return const HistoriasLocasGame();
            case 'asociacion_creativa':
              return const AsociacionCreativaGame();
            case 'artista_emojis':
              return const ArtistaEmojisGame();
            case 'inventor_palabras':
              return const InventorPalabrasGame();
            default:
              return Scaffold(
                body: Center(
                  child: Text('Juego no encontrado: $gameId'),
                ),
              );
          }
        },
      ),
      GoRoute(
        path: '/game-results',
        name: 'game-results',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return GameResultsScreen(gameData: extra);
        },
      ),

      // Ranking
      GoRoute(
        path: '/ranking',
        name: 'ranking',
        builder: (context, state) => const RankingScreen(),
      ),

      // Profile
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),

      // Avatar Shop
      GoRoute(
        path: '/shop',
        name: 'shop',
        builder: (context, state) => const AvatarShopScreen(),
      ),

      // Rewards
      GoRoute(
        path: '/rewards',
        name: 'rewards',
        builder: (context, state) => const RewardsScreen(),
      ),

      // Parental Control
      GoRoute(
        path: '/parental',
        name: 'parental',
        builder: (context, state) => const ParentalDashboard(),
      ),

      // Fun Games (Juegos de distracción)
      GoRoute(
        path: '/word-search',
        name: 'word-search',
        builder: (context, state) => const WordSearchLevelSelector(),
      ),
      GoRoute(
        path: '/emoji-sorting',
        name: 'emoji-sorting',
        builder: (context, state) => const EmojiSortingLevelSelector(),
      ),
    ],

    // Redirect para autenticación
    redirect: (context, state) {
      // TODO: Implementar lógica de redirección basada en estado de auth
      return null;
    },

    // Error handler
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error}'),
      ),
    ),
  );
}
