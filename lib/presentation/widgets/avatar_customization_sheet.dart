/// Sheet de Personalización de Avatar
///
/// Permite al usuario cambiar las partes de su avatar
/// usando todas las piezas disponibles en las carpetas de assets.
///
/// Autor: Sistema Educativo
/// Fecha: 2025

import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/config/avatar_catalog.dart';
import '../../app/theme/colors.dart';
import '../../domain/models/avatar_model.dart';
import '../../domain/models/avatar_part_item.dart';
import '../../domain/services/avatar_service.dart';
import 'avatar_asset.dart';
import 'avatar_widget.dart';

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
    final double resolvedWidth = availableWidth.isFinite
        ? availableWidth.clamp(280.0, 720.0).toDouble()
        : 720.0;
    final double resolvedHeight = math.min(size.height * 0.85, 640.0);

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

              // Vista previa del avatar
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
                      size: 140,
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
                padding: EdgeInsets.symmetric(vertical: 12),
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
    final availableParts =
        AvatarCatalog.getPartsByCategory(_selectedCategory).toList();

    if (availableParts.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.inventory_2_outlined,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'No hay elementos disponibles en esta categoría',
              style: GoogleFonts.fredoka(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
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
                _PartPreview(part: part),
                const SizedBox(height: 8),
                Text(
                  part.name,
                  style: GoogleFonts.fredoka(
                    fontSize: 13,
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
                if (isSelected)
                  Container(
                    margin: const EdgeInsets.only(top: 6),
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      'Equipado',
                      style: GoogleFonts.fredoka(
                        fontSize: 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
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
    final fallback = Text(
      part.emoji == null || part.emoji!.isEmpty ? '🎨' : part.emoji!,
      style: theme.textTheme.displaySmall?.copyWith(fontSize: 52),
    );

    if (part.assetPath.isEmpty) {
      return fallback;
    }

    return Center(
      child: AvatarAsset(
        assetPath: part.assetPath,
        width: 80,
        height: 80,
        fit: BoxFit.contain,
        placeholder: fallback,
      ),
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

  static const double _buttonDelta = 160;

  void _scrollCategories(double delta) {
    if (!controller.hasClients) return;

    final ScrollPosition position = controller.position;
    final double target =
        (controller.offset + delta).clamp(0.0, position.maxScrollExtent);

    if (target == controller.offset) return;

    controller.animateTo(
      target,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  void _handleCategoryPointerSignal(PointerSignalEvent event) {
    if (event is! PointerScrollEvent || !controller.hasClients) return;

    final ScrollPosition position = controller.position;
    final Offset delta = event.scrollDelta;
    final double rawDelta = delta.dy.abs() > delta.dx.abs() ? delta.dy : delta.dx;

    if (rawDelta == 0) return;

    final double target =
        (controller.offset + rawDelta).clamp(0.0, position.maxScrollExtent);

    if (target != controller.offset) {
      controller.jumpTo(target);
    }
  }

  Widget _buildCategoryChip(BuildContext context, String category) {
    final bool isSelected = selectedCategory == category;
    final Color chipColor = isSelected ? AppColors.primary : Colors.grey.shade100;

    return Material(
      color: chipColor,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => onCategorySelected(category),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey.shade300,
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                AvatarCatalog.getCategoryIcon(category),
                style: const TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                AvatarCatalog.getCategoryName(category),
                style: GoogleFonts.fredoka(
                  fontSize: 12,
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

  Widget _buildScrollButton({
    required IconData icon,
    required double delta,
  }) {
    return SizedBox(
      width: 36,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          final ScrollController ctrl = controller;
          final bool canScroll = ctrl.hasClients &&
              ((delta < 0 && ctrl.offset > 0) ||
                  (delta > 0 && ctrl.offset < ctrl.position.maxScrollExtent));

          return IconButton(
            icon: Icon(icon, size: 24),
            color: canScroll ? AppColors.primary : Colors.grey.shade400,
            tooltip: delta < 0 ? 'Ver anteriores' : 'Ver siguientes',
            onPressed: canScroll ? () => _scrollCategories(delta) : null,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Row(
        children: [
          _buildScrollButton(icon: Icons.chevron_left, delta: -_buttonDelta),
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: const {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                  PointerDeviceKind.stylus,
                },
              ),
              child: Listener(
                onPointerSignal: _handleCategoryPointerSignal,
                child: Scrollbar(
                  controller: controller,
                  thumbVisibility: true,
                  interactive: true,
                  child: ListView.separated(
                    controller: controller,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: AvatarCatalog.categories.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final category = AvatarCatalog.categories[index];
                      return _buildCategoryChip(context, category);
                    },
                  ),
                ),
              ),
            ),
          ),
          _buildScrollButton(icon: Icons.chevron_right, delta: _buttonDelta),
        ],
      ),
    );
  }
}
