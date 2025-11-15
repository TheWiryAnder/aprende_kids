/// Sheet de Personalización de Avatar
///
/// Permite al usuario cambiar las partes de su avatar
/// usando todas las piezas disponibles en las carpetas de assets.
///
/// Autor: Sistema Educativo
/// Fecha: 2025

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/config/avatar_catalog.dart';
import '../../app/theme/colors.dart';
import '../../domain/models/avatar_model.dart';
import '../../domain/models/avatar_part_item.dart';
import '../../domain/services/avatar_service.dart';
import 'avatar_asset.dart';
import 'avatar_widget.dart';
import '../../app/utils/responsive_utils.dart';

class AvatarCustomizationSheet extends StatefulWidget {
  final AvatarModel avatar;
  final String userId;

  const AvatarCustomizationSheet({
    super.key,
    required this.avatar,
    required this.userId,
  });

  @override
  State<AvatarCustomizationSheet> createState() => _AvatarCustomizationSheetState();
}

class _AvatarCustomizationSheetState extends State<AvatarCustomizationSheet> {
  late AvatarModel _currentAvatar;
  String _selectedCategory = 'face';
  final AvatarService _avatarService = AvatarService();
  bool _isUpdating = false;
  late final ScrollController _categoryController;

  @override
  void initState() {
    super.initState();
    _currentAvatar = widget.avatar;
    _categoryController = ScrollController();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  Future<void> _updateAvatarPart(String category, String partId) async {
    setState(() => _isUpdating = true);

    try {
      await _avatarService.updateAvatarPart(
        userId: widget.userId,
        category: category,
        partId: partId,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '¡Avatar actualizado!',
              style: GoogleFonts.fredoka(),
            ),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error al actualizar',
              style: GoogleFonts.fredoka(),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUpdating = false);
      }
    }
  }

  String _getCurrentPart(String category) {
    switch (category) {
      case 'face':
        return _currentAvatar.face;
      case 'body':
        return _currentAvatar.body;
      case 'eyes':
        return _currentAvatar.eyes;
      case 'mouth':
        return _currentAvatar.mouth;
      case 'hair':
        return _currentAvatar.hair;
      case 'top':
        return _currentAvatar.top;
      case 'bottom':
        return _currentAvatar.bottom;
      case 'shoes':
        return _currentAvatar.shoes;
      case 'hands':
        return _currentAvatar.hands;
      case 'accessory':
        return _currentAvatar.accessory;
      case 'background':
        return _currentAvatar.background;
      default:
        return '';
    }
  }

  List<String> _getUnlockedList(String category) {
    switch (category) {
      case 'face':
        return _currentAvatar.unlockedFaces;
      case 'body':
        return _currentAvatar.unlockedBodies;
      case 'eyes':
        return _currentAvatar.unlockedEyes;
      case 'mouth':
        return _currentAvatar.unlockedMouths;
      case 'hair':
        return _currentAvatar.unlockedHairs;
      case 'top':
        return _currentAvatar.unlockedTops;
      case 'bottom':
        return _currentAvatar.unlockedBottoms;
      case 'shoes':
        return _currentAvatar.unlockedShoes;
      case 'hands':
        return _currentAvatar.unlockedHands;
      case 'accessory':
        return _currentAvatar.unlockedAccessories;
      case 'background':
        return _currentAvatar.unlockedBackgrounds;
      default:
        return [];
    }
  }

  // --- ÚNICA definición: usa el widget separado para el carrusel de categorías.
  Widget _buildCategorySelector() {
    return _AvatarCategoryCarousel(
      controller: _categoryController,
      selectedCategory: _selectedCategory,
      onCategorySelected: (category) {
        setState(() {
          _selectedCategory = category;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double availableWidth = size.width - 32;
    // Modal más compacto que se adapta al contenido
    final double resolvedWidth = availableWidth.isFinite
        ? availableWidth.clamp(320.0, 900.0).toDouble()
        : 900.0;
    // Altura ajustada para contenido más compacto
    final double resolvedHeight = math.min(size.height * 0.85, 680.0);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: resolvedWidth,
          maxHeight: resolvedHeight,
        ),
        child: Material(
          color: Colors.white,
          elevation: 12,
          borderRadius: BorderRadius.circular(28),
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Expanded(
                      child: Text(
                        'Personalizar Avatar',
                        style: GoogleFonts.fredoka(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              // Vista previa del avatar (compacta)
              StreamBuilder<AvatarModel?>(
                stream: _avatarService.avatarStream(widget.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.data != null) {
                    _currentAvatar = snapshot.data!;
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: AvatarWidget(
                      avatar: _currentAvatar,
                      size: 100,
                      animate: false,
                    ),
                  );
                },
              ),

              const SizedBox(height: 8),

              // Selector de categoría
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildCategorySelector(),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Divider(height: 1),
              ),

              // Lista de partes desbloqueadas
              Expanded(
                child: _isUpdating
                    ? const Center(child: CircularProgressIndicator())
                    : _buildPartsList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPartsList() {
    final currentPart = _getCurrentPart(_selectedCategory);
    final unlockedIds = _getUnlockedList(_selectedCategory);

    // Filtrar solo las partes desbloqueadas o por defecto
    final allParts = AvatarCatalog.getPartsByCategory(_selectedCategory);
    final availableParts = allParts.where((part) {
      return part.isDefault || unlockedIds.contains(part.id);
    }).toList();

    if (availableParts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes accesorios desbloqueados',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '¡Visita la tienda para comprar más!',
              style: GoogleFonts.fredoka(
                fontSize: 14,
                color: Colors.grey.shade500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Grid responsive según ancho de pantalla
        final crossAxisCount = getGridCrossAxisCount(
          constraints.maxWidth,
          minItemWidth: 120,
        );

        return Scrollbar(
          thumbVisibility: true,
          thickness: 8,
          radius: const Radius.circular(4),
          child: GridView.builder(
            padding: EdgeInsets.fromLTRB(
              context.responsive(mobile: 16.0, tablet: 24.0, desktop: 32.0),
              12,
              context.responsive(mobile: 24.0, tablet: 32.0, desktop: 40.0),
              12,
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
            itemCount: availableParts.length,
            itemBuilder: (context, index) {
              final part = availableParts[index];
              final isSelected = currentPart == part.id;

        return GestureDetector(
          onTap: () {
            _updateAvatarPart(_selectedCategory, part.id);
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? AppColors.primary
                    : Colors.grey.shade300,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                // Imagen AMPLIADA 50% para mejor visualización infantil
                Expanded(
                  flex: 8,
                  child: Center(
                    child: _PartPreview(part: part),
                  ),
                ),
                const SizedBox(height: 6),
                // Texto compacto
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    part.name,
                    style: GoogleFonts.fredoka(
                      fontSize: 11,
                      fontWeight: isSelected
                          ? FontWeight.bold
                          : FontWeight.w600,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 2),
                // Badge compacto
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(bottom: 2),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Equipado',
                      style: GoogleFonts.fredoka(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(height: 2),
                const Spacer(flex: 1),
              ],
            ),
          ),
        );
            },
          ),
        );
      },
    );
  }
}

class _PartPreview extends StatelessWidget {
  final AvatarPartItem part;

  const _PartPreview({required this.part});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Tamaño responsive de imagen
    final imageSize = context.responsive(
      mobile: 80.0,
      tablet: 95.0,
      desktop: 105.0,
    );

    final fallback = Text(
      part.emoji == null || part.emoji!.isEmpty ? '🎨' : part.emoji!,
      style: theme.textTheme.displaySmall?.copyWith(fontSize: 52),
    );

    if (part.assetPath.isEmpty) {
      return fallback;
    }

    return AvatarAsset(
      assetPath: part.assetPath,
      width: imageSize,
      height: imageSize,
      fit: BoxFit.contain,
      placeholder: fallback,
    );
  }
}

class _AvatarCategoryCarousel extends StatelessWidget {
  final ScrollController controller;
  final String selectedCategory;
  final ValueChanged<String> onCategorySelected;

  const _AvatarCategoryCarousel({
    required this.controller,
    required this.selectedCategory,
    required this.onCategorySelected,
  });

  Widget _buildCategoryChip(BuildContext context, String category) {
    final bool isSelected = selectedCategory == category;
    final Color chipColor = isSelected ? AppColors.primary : Colors.grey.shade100;

    return Material(
      color: chipColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => onCategorySelected(category),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 8,
        runSpacing: 8,
        children: AvatarCatalog.categories.map((category) {
          return _buildCategoryChip(context, category);
        }).toList(),
      ),
    );
  }
}
