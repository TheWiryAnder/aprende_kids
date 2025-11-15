library;

/// Pantalla de Perfil del Usuario
///
/// Muestra información del usuario: avatar, nombre, puntos, monedas y ranking.
/// Permite editar el nombre de usuario.
///
/// Autor: Sistema Educativo
/// Fecha: 2025

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../app/theme/colors.dart';
import '../../../domain/models/avatar_model.dart';
import '../../../domain/services/avatar_service.dart';
import '../../widgets/avatar_widget.dart';
import '../../widgets/avatar_customization_sheet.dart';
import '../../../app/utils/responsive_utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  bool _isEditingUsername = false;
  bool _isSaving = false;

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _updateUsername() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _usernameController.text.trim().isEmpty) return;

    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'username': _usernameController.text.trim()});

      if (mounted) {
        setState(() {
          _isEditingUsername = false;
          _isSaving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Nombre actualizado!',
              style: GoogleFonts.fredoka(),
            ),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al actualizar nombre',
              style: GoogleFonts.fredoka(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<int> _getUserRanking(String userId) async {
    try {
      final usersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .orderBy('totalScore', descending: true)
          .get();

      final userIndex = usersSnapshot.docs.indexWhere((doc) => doc.id == userId);
      return userIndex != -1 ? userIndex + 1 : 0;
    } catch (e) {
      return 0;
    }
  }

  void _showAvatarCustomization(BuildContext context, AvatarModel avatar, String userId) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: AvatarCustomizationSheet(
          avatar: avatar,
          userId: userId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'No has iniciado sesión',
                style: GoogleFonts.fredoka(fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                child: Text('Iniciar Sesión', style: GoogleFonts.fredoka()),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error al cargar perfil',
                style: GoogleFonts.fredoka(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null) {
            return Center(
              child: Text(
                'No se encontraron datos del usuario',
                style: GoogleFonts.fredoka(),
              ),
            );
          }

          final username = userData['username'] ?? 'Usuario';
          final totalScore = (userData['totalScore'] ?? 0) as int;
          final gamesPlayed = (userData['gamesPlayed'] ?? 0) as int;
          final coins = (userData['coins'] ?? 0) as int;

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withValues(alpha: 0.7),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 800),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: context.isMobile
                              ? _buildMobileLayout(username as String, totalScore, coins, gamesPlayed, user.uid)
                              : _buildDesktopLayout(username as String, totalScore, coins, gamesPlayed, user.uid),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Mi Perfil',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 28),
            onPressed: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Cerrar Sesión', style: GoogleFonts.fredoka()),
                  content: Text(
                    '¿Estás seguro de que quieres cerrar sesión?',
                    style: GoogleFonts.fredoka(),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text('Cancelar', style: GoogleFonts.fredoka()),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text('Salir', style: GoogleFonts.fredoka()),
                    ),
                  ],
                ),
              );

              if (confirm == true && mounted) {
                await FirebaseAuth.instance.signOut();
                if (mounted) context.go('/login');
              }
            },
          ),
        ],
      ),
    );
  }

  // Layout para MÓVIL: Información primero, avatar al final
  Widget _buildMobileLayout(String username, int totalScore, int coins, int gamesPlayed, String userId) {
    return Column(
      children: [
        // 1. Información del usuario primero
        _buildProfileCard(username, totalScore, coins, gamesPlayed, userId),
        const SizedBox(height: 16),

        // 2. Estadísticas
        _buildStatsCards(totalScore, coins, gamesPlayed),
        const SizedBox(height: 16),

        // 3. Ranking
        _buildRankingCard(userId),
        const SizedBox(height: 16),

        // 4. Avatar al FINAL
        _buildAvatarCard(userId),
      ],
    );
  }

  // Layout para DESKTOP: Avatar izquierda, información derecha
  Widget _buildDesktopLayout(String username, int totalScore, int coins, int gamesPlayed, String userId) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Recuadro del Avatar (izquierda) - ocupa toda la altura
          _buildAvatarCard(userId),
          const SizedBox(width: 16),
          // Columna derecha con toda la información
          Expanded(
            child: Column(
              children: [
                _buildProfileCard(username, totalScore, coins, gamesPlayed, userId),
                const SizedBox(height: 16),
                _buildStatsCards(totalScore, coins, gamesPlayed),
                const SizedBox(height: 16),
                _buildRankingCard(userId),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Recuadro del Avatar (responsive)
  Widget _buildAvatarCard(String userId) {
    final avatarService = AvatarService();
    final isMobile = context.isMobile;

    return Container(
      width: isMobile ? double.infinity : 250,
      padding: EdgeInsets.all(isMobile ? 20.0 : 24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: StreamBuilder<AvatarModel?>(
        stream: avatarService.avatarStream(userId),
        builder: (context, avatarSnapshot) {
          final avatar = avatarSnapshot.data;

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              if (avatar != null)
                AvatarWidget(
                  avatar: avatar,
                  size: 180,
                  animate: true,
                )
              else
                Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primary.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              const SizedBox(height: 20),
              // Botón de personalización
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: avatar != null
                      ? () => _showAvatarCustomization(context, avatar, userId)
                      : null,
                  icon: const Icon(Icons.brush, size: 18),
                  label: Text(
                    'Personalizar',
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Recuadro de información del usuario (derecha)
  Widget _buildProfileCard(String username, int totalScore, int coins, int gamesPlayed, String userId) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nombre de usuario (editable)
          _isEditingUsername
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _usernameController,
                        style: GoogleFonts.fredoka(fontSize: 18),
                        decoration: InputDecoration(
                          hintText: 'Nuevo nombre',
                          hintStyle: GoogleFonts.fredoka(),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        enabled: !_isSaving,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.check, color: Colors.green),
                      onPressed: _isSaving ? null : _updateUsername,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: _isSaving
                          ? null
                          : () {
                              setState(() => _isEditingUsername = false);
                            },
                    ),
                  ],
                )
              : Row(
                  children: [
                    Text(
                      username,
                      style: GoogleFonts.fredoka(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      onPressed: () {
                        setState(() {
                          _isEditingUsername = true;
                          _usernameController.text = username;
                        });
                      },
                    ),
                  ],
                ),

          const SizedBox(height: 16),

          Text(
            '$gamesPlayed ${gamesPlayed == 1 ? 'juego jugado' : 'juegos jugados'}',
            style: GoogleFonts.fredoka(
              fontSize: 18,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(int totalScore, int coins, int gamesPlayed) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            icon: Icons.star,
            iconColor: Colors.amber,
            label: 'Puntos',
            value: totalScore.toString(),
            gradient: [Colors.amber.shade100, Colors.amber.shade50],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            icon: Icons.monetization_on,
            iconColor: Colors.orange,
            label: 'Monedas',
            value: coins.toString(),
            gradient: [Colors.orange.shade100, Colors.orange.shade50],
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradient,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
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
      ),
    );
  }

  Widget _buildRankingCard(String userId) {
    return FutureBuilder<int>(
      future: _getUserRanking(userId),
      builder: (context, snapshot) {
        final ranking = snapshot.data ?? 0;

        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Ranking Global',
                    style: GoogleFonts.fredoka(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              snapshot.hasData
                  ? Column(
                      children: [
                        Text(
                          '#$ranking',
                          style: GoogleFonts.fredoka(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          ranking == 1
                              ? '¡Eres el número 1! 🏆'
                              : ranking <= 10
                                  ? '¡Estás en el Top 10! 🌟'
                                  : ranking <= 50
                                      ? '¡Estás en el Top 50! ⭐'
                                      : '¡Sigue jugando para subir! 💪',
                          style: GoogleFonts.fredoka(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    )
                  : const CircularProgressIndicator(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => context.push('/ranking'),
                icon: const Icon(Icons.leaderboard),
                label: Text(
                  'Ver Ranking Completo',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
