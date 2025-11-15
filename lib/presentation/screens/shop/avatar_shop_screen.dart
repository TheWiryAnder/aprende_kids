library;

/// Pantalla de Tienda de Avatares
///
/// Permite comprar nuevas partes de avatar con monedas.
/// Muestra partes desbloqueadas y disponibles para comprar.
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
import '../../../app/config/avatar_catalog.dart';
import '../../../domain/models/avatar_part_item.dart';
import '../../widgets/avatar_asset.dart';
import '../../../app/utils/responsive_utils.dart';

class AvatarShopScreen extends StatefulWidget {
  const AvatarShopScreen({super.key});

  @override
  State<AvatarShopScreen> createState() => _AvatarShopScreenState();
}

class _AvatarShopScreenState extends State<AvatarShopScreen> {
  String _selectedCategory = 'face';
  final AvatarService _avatarService = AvatarService();

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'Debes iniciar sesión',
            style: GoogleFonts.fredoka(),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primary,
              AppColors.primary.withOpacity(0.7),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              _buildHeader(context, user.uid),

              // Contenido
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 16),

                      // Selector de categoría (centrado con Wrap)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: AvatarCatalog.categories.map((category) {
                            final isSelected = _selectedCategory == category;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedCategory = category;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: isSelected ? AppColors.primary : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                                    width: 2,
                                  ),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      AvatarCatalog.getCategoryIcon(category),
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      AvatarCatalog.getCategoryName(category),
                                      style: GoogleFonts.fredoka(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: isSelected ? Colors.white : AppColors.textPrimary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Divider(height: 1),
                      ),

                      // Lista de items
                      Expanded(
                        child: _buildItemsList(user.uid),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String userId) {
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
            child: Text(
              'Tienda de Avatares',
              style: GoogleFonts.fredoka(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Monedas del usuario
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .snapshots(),
            builder: (context, snapshot) {
              int coins = 0;
              if (snapshot.hasData && snapshot.data != null) {
                final data = snapshot.data!.data() as Map<String, dynamic>?;
                coins = data?['coins'] as int? ?? 0;
              }

              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                    Text(
                      '$coins',
                      style: GoogleFonts.fredoka(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildItemsList(String userId) {
    return StreamBuilder<AvatarModel?>(
      stream: _avatarService.avatarStream(userId),
      builder: (context, avatarSnapshot) {
        if (!avatarSnapshot.hasData || avatarSnapshot.data == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final avatar = avatarSnapshot.data!;
        final allParts = AvatarCatalog.getPartsByCategory(_selectedCategory);
        final unlockedIds = _getUnlockedList(avatar, _selectedCategory);

        return StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId)
              .snapshots(),
          builder: (context, userSnapshot) {
            int userCoins = 0;
            if (userSnapshot.hasData && userSnapshot.data != null) {
              final data = userSnapshot.data!.data() as Map<String, dynamic>?;
              userCoins = data?['coins'] as int? ?? 0;
            }

            return LayoutBuilder(
              builder: (context, constraints) {
                // Grid responsive según ancho de pantalla
                final crossAxisCount = getGridCrossAxisCount(
                  constraints.maxWidth,
                  minItemWidth: 150,
                );

                // Tamaño de imagen adaptativo
                final imageSize = context.responsive(
                  mobile: 140.0,
                  tablet: 180.0,
                  desktop: 210.0,
                );

                return Scrollbar(
                  thumbVisibility: true,
                  thickness: 8,
                  radius: const Radius.circular(4),
                  child: GridView.builder(
                    padding: EdgeInsets.fromLTRB(
                      context.responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0),
                      8,
                      context.responsive(mobile: 24.0, tablet: 32.0, desktop: 40.0),
                      16,
                    ),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: context.responsive(
                        mobile: 8.0,
                        tablet: 12.0,
                        desktop: 16.0,
                      ),
                      mainAxisSpacing: context.responsive(
                        mobile: 8.0,
                        tablet: 12.0,
                        desktop: 16.0,
                      ),
                      childAspectRatio: 0.9,
                    ),
                    itemCount: allParts.length,
                    itemBuilder: (context, index) {
                      final part = allParts[index];
                      final isUnlocked = unlockedIds.contains(part.id);
                      final canAfford = userCoins >= part.price;

                      return _buildShopItem(
                        part: part,
                        isUnlocked: isUnlocked,
                        canAfford: canAfford,
                        userId: userId,
                        imageSize: imageSize,
                      );
                    },
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildShopItem({
    required AvatarPartItem part,
    required bool isUnlocked,
    required bool canAfford,
    required String userId,
    required double imageSize,
  }) {
    return GestureDetector(
      onTap: isUnlocked || part.isDefault
          ? null
          : () => _showPurchaseDialog(part, canAfford, userId),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isUnlocked || part.isDefault
              ? Colors.green.shade50
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked || part.isDefault
                ? Colors.green
                : canAfford
                    ? AppColors.primary
                    : Colors.grey.shade300,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 1),
            // Imagen RESPONSIVE - se adapta al tamaño del dispositivo
            Expanded(
              flex: 9,
              child: Center(
                child: _PartThumbnail(part: part, size: imageSize),
              ),
            ),
            const SizedBox(height: 6),

            // Nombre más grande y legible
            Text(
              part.name,
              style: GoogleFonts.fredoka(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),

            // Estado/Precio más visible
            if (isUnlocked || part.isDefault)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white, size: 14),
                    const SizedBox(width: 4),
                    Text(
                      'Comprado',
                      style: GoogleFonts.fredoka(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: canAfford ? Colors.orange : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: canAfford ? Colors.white : Colors.grey.shade600,
                      size: 14,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${part.price}',
                      style: GoogleFonts.fredoka(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: canAfford ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            const Spacer(flex: 1),
          ],
        ),
      ),
    );
  }

  void _showPurchaseDialog(AvatarPartItem part, bool canAfford, String userId) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: Text(
          canAfford ? '¿Comprar ${part.name}?' : 'Monedas Insuficientes',
          style: GoogleFonts.fredoka(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _PartThumbnail(part: part, size: 120),
            const SizedBox(height: 20),
            Text(
              part.description,
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.orange, width: 2),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.monetization_on,
                    color: Colors.orange,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${part.price} monedas',
                    style: GoogleFonts.fredoka(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange.shade900,
                    ),
                  ),
                ],
              ),
            ),
            if (!canAfford) ...[
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '¡Necesitas más monedas!\nJuega minijuegos para ganar más.',
                  style: GoogleFonts.fredoka(
                    fontSize: 16,
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Cancelar',
              style: GoogleFonts.fredoka(
                color: AppColors.textSecondary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: canAfford
                ? () async {
                    Navigator.pop(dialogContext);
                    await _purchasePart(part, userId);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: canAfford ? AppColors.primary : Colors.grey.shade300,
              foregroundColor: canAfford ? Colors.white : Colors.grey.shade600,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: canAfford ? 4 : 0,
            ),
            child: Text(
              'Comprar',
              style: GoogleFonts.fredoka(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _purchasePart(AvatarPartItem part, String userId) async {
    try {
      final success = await _avatarService.purchaseAvatarPart(
        userId: userId,
        partId: part.id,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '¡${part.name} comprado con éxito!',
                style: GoogleFonts.fredoka(),
              ),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'No tienes suficientes monedas',
                style: GoogleFonts.fredoka(),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al comprar: $e',
              style: GoogleFonts.fredoka(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  List<String> _getUnlockedList(AvatarModel avatar, String category) {
    switch (category) {
      case 'face':
        return avatar.unlockedFaces;
      case 'eyes':
        return avatar.unlockedEyes;
      case 'mouth':
        return avatar.unlockedMouths;
      case 'hair':
        return avatar.unlockedHairs;
      case 'top':
        return avatar.unlockedTops;
      case 'bottom':
        return avatar.unlockedBottoms;
      case 'shoes':
        return avatar.unlockedShoes;
      case 'hands':
        return avatar.unlockedHands;
      case 'accessory':
        return avatar.unlockedAccessories;
      case 'background':
        return avatar.unlockedBackgrounds;
      default:
        return [];
    }
  }
}

class _PartThumbnail extends StatelessWidget {
  final AvatarPartItem part;
  final double size;

  const _PartThumbnail({required this.part, this.size = 56});

  @override
  Widget build(BuildContext context) {
    if (part.assetPath.isEmpty) {
      return Text(
        part.emoji == null || part.emoji!.isEmpty ? '🎨' : part.emoji!,
        style: TextStyle(fontSize: size * 0.6),
      );
    }

    return AvatarAsset(
      assetPath: part.assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
