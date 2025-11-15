library;

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/avatar_part_item.dart';

class AvatarCatalog {
  static bool _initialized = false;
  static final Set<String> _availableCategories = <String>{};

  static final Map<String, List<AvatarPartItem>> _partsByCategory = {
    'face': <AvatarPartItem>[],
    'body': <AvatarPartItem>[],
    'hair': <AvatarPartItem>[],
    'top': <AvatarPartItem>[],
    'bottom': <AvatarPartItem>[],
    'shoes': <AvatarPartItem>[],
    'background': <AvatarPartItem>[],
    'eyes': <AvatarPartItem>[],
    'mouth': <AvatarPartItem>[],
    'hands': <AvatarPartItem>[],
    'accessory': <AvatarPartItem>[],
  };

  static const List<String> _defaultCategoryOrder = [
    'face',
    'body',
    'hair',
    'top',
    'bottom',
    'shoes',
    'background',
    'eyes',
    'mouth',
    'hands',
    'accessory',
  ];

  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap =
          jsonDecode(manifestContent) as Map<String, dynamic>;

      for (final parts in _partsByCategory.values) {
        parts.clear();
      }
      _availableCategories.clear();

      manifestMap.forEach((assetPath, _) {
        if (!assetPath.startsWith('assets/avatar/')) {
          return;
        }

        if (!_isSupportedAsset(assetPath)) {
          return;
        }

        final segments = assetPath.split('/');
        if (segments.length < 4) {
          return;
        }

        final folderName = segments[2];
        final category = _normalizeCategoryKey(folderName);
        if (category == null) {
          return;
        }

        final parts = _partsByCategory[category];
        if (parts == null) {
          return;
        }

        _availableCategories.add(category);

        final alreadyExists = parts.any(
          (part) => part.assetPath.toLowerCase() == assetPath.toLowerCase(),
        );
        if (alreadyExists) {
          return;
        }

        final isDefault = !_hasDefault(parts);
        final item = AvatarPartItem(
          id: _generateId(category, segments.last, parts),
          category: category,
          assetPath: assetPath,
          name: _formatName(segments.last),
          description: _defaultDescription(category),
          price: isDefault ? 0 : _calculatePrice(category),
          isDefault: isDefault,
          emoji: _categoryEmoji(category),
        );

        parts.add(item);
      });

      for (final parts in _partsByCategory.values) {
        parts.sort((a, b) {
          if (a.isDefault == b.isDefault) {
            return a.name.compareTo(b.name);
          }
          return a.isDefault ? -1 : 1;
        });
      }
    } catch (_) {
      // En entornos sin manifest (tests) simplemente conservamos las listas vacías
      // para que la aplicación pueda seguir funcionando con los datos cargados
      // dinámicamente en tiempo de ejecución.
    } finally {
      _initialized = true;
    }
  }

  static bool _isSupportedAsset(String assetPath) {
    return assetPath.toLowerCase().endsWith('.png');
  }

  static bool _hasDefault(List<AvatarPartItem> parts) {
    return parts.any((part) => part.isDefault);
  }

  static String _generateId(
    String category,
    String fileName,
    List<AvatarPartItem> existingParts,
  ) {
    final baseName = fileName.split('.').first;
    var normalized = baseName
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    if (normalized.isEmpty) {
      normalized = 'item';
    }

    var candidate = '${category}_$normalized';
    var counter = 1;
    while (existingParts.any((part) => part.id == candidate)) {
      counter++;
      candidate = '${category}_${normalized}_$counter';
    }

    return candidate;
  }

  static String _formatName(String fileName) {
    final baseName = fileName.split('.').first;
    final parts = baseName
        .split(RegExp(r'[_-]+'))
        .where((segment) => segment.isNotEmpty)
        .map(
          (segment) =>
              segment[0].toUpperCase() + segment.substring(1).toLowerCase(),
        )
        .toList();

    return parts.isEmpty ? 'Elemento' : parts.join(' ');
  }

  static String _defaultDescription(String category) {
    final categoryName = getCategoryName(category).toLowerCase();
    return 'Elemento adicional para la categoría $categoryName.';
  }

  static String? _categoryEmoji(String category) {
    switch (category) {
      case 'face':
        return '😊';
      case 'body':
        return '🧍';
      case 'hair':
        return '💇';
      case 'top':
        return '👕';
      case 'bottom':
        return '👖';
      case 'shoes':
        return '👟';
      case 'hands':
        return '🖐️';
      case 'accessory':
        return '🎩';
      case 'background':
        return '🎨';
      case 'eyes':
        return '👀';
      case 'mouth':
        return '😄';
      default:
        return null;
    }
  }

  static String? _normalizeCategoryKey(String folderName) {
    final normalized = folderName.toLowerCase();
    if (_partsByCategory.containsKey(normalized)) {
      return normalized;
    }

    if (normalized.endsWith('s')) {
      final trimmed = normalized.substring(0, normalized.length - 1);
      if (_partsByCategory.containsKey(trimmed)) {
        return trimmed;
      }
    }

    return null;
  }

  static List<AvatarPartItem> getPartsByCategory(String category) {
    final parts = _partsByCategory[category];
    if (parts == null) {
      return const [];
    }
    return List.unmodifiable(parts);
  }

  static AvatarPartItem? getPartById(String id) {
    if (id.isEmpty) {
      return null;
    }

    for (final parts in _partsByCategory.values) {
      for (final part in parts) {
        if (part.id == id) {
          return part;
        }
      }
    }

    return null;
  }

  static AvatarPartItem? getPartByEmoji(String? emoji, String category) {
    if (emoji == null || emoji.isEmpty) {
      return null;
    }

    for (final part in getPartsByCategory(category)) {
      if (part.emoji == emoji) {
        return part;
      }
    }

    return null;
  }

  static AvatarPartItem? getPartByAsset(String? assetPath, String category) {
    if (assetPath == null || assetPath.isEmpty) {
      return null;
    }

    for (final part in getPartsByCategory(category)) {
      if (part.assetPath == assetPath) {
        return part;
      }
    }

    return null;
  }

  static String resolvePartId(
    String? rawValue, {
    required String category,
    String? fallbackId,
  }) {
    final fallback = fallbackId ?? fallbackForCategory(category);

    if (rawValue == null || rawValue.isEmpty) {
      return fallback;
    }

    if (category == 'accessory' && rawValue == 'none') {
      return fallback;
    }

    final byId = getPartById(rawValue);
    if (byId != null && byId.category == category) {
      return byId.id;
    }

    final byEmoji = getPartByEmoji(rawValue, category);
    if (byEmoji != null) {
      return byEmoji.id;
    }

    final byAsset = getPartByAsset(rawValue, category);
    if (byAsset != null) {
      return byAsset.id;
    }

    return fallback;
  }

  static String fallbackForCategory(String category, {String orElse = ''}) {
    final parts = _partsByCategory[category];
    if (parts == null || parts.isEmpty) {
      return orElse;
    }

    final defaultPart =
        parts.firstWhere((part) => part.isDefault, orElse: () => parts.first);
    return defaultPart.id;
  }

  static List<String> getDefaultUnlockedIds(String category) {
    return getPartsByCategory(category)
        .where((part) => part.isDefault)
        .map((part) => part.id)
        .toList();
  }

  static List<String> get categories {
    final source = _availableCategories.isNotEmpty
        ? _availableCategories
        : _partsByCategory.entries
            .where((entry) => entry.value.isNotEmpty)
            .map((entry) => entry.key)
            .toSet();

    final ordered = <String>[];
    for (final category in _defaultCategoryOrder) {
      if (source.contains(category) &&
          (_partsByCategory[category]?.isNotEmpty ?? false)) {
        ordered.add(category);
      }
    }

    for (final category in source) {
      if (!ordered.contains(category) &&
          (_partsByCategory[category]?.isNotEmpty ?? false)) {
        ordered.add(category);
      }
    }

    return List.unmodifiable(ordered);
  }

  static String getCategoryName(String category) {
    switch (category) {
      case 'face':
        return 'Rostro';
      case 'body':
        return 'Cuerpo';
      case 'eyes':
        return 'Ojos';
      case 'mouth':
        return 'Bocas';
      case 'hair':
        return 'Peinados';
      case 'top':
        return 'Ropa Superior';
      case 'bottom':
        return 'Ropa Inferior';
      case 'shoes':
        return 'Zapatos';
      case 'hands':
        return 'Manos';
      case 'accessory':
        return 'Accesorios';
      case 'background':
        return 'Fondos';
      default:
        return category;
    }
  }

  static String getCategoryIcon(String category) {
    switch (category) {
      case 'face':
        return '😊';
      case 'body':
        return '🧍';
      case 'eyes':
        return '👀';
      case 'mouth':
        return '😄';
      case 'hair':
        return '💇';
      case 'top':
        return '👕';
      case 'bottom':
        return '👖';
      case 'shoes':
        return '👟';
      case 'hands':
        return '🖐️';
      case 'accessory':
        return '🎩';
      case 'background':
        return '🎨';
      default:
        return '❓';
    }
  }

  /// Calcula el precio de un accesorio según su categoría
  /// Los precios están balanceados para el sistema de recompensas del juego
  static int _calculatePrice(String category) {
    switch (category) {
      case 'face':
      case 'body':
        return 50; // Partes básicas del avatar
      case 'eyes':
      case 'mouth':
        return 30; // Expresiones faciales
      case 'hair':
        return 80; // Peinados más caros
      case 'top':
      case 'bottom':
        return 100; // Ropa
      case 'shoes':
        return 60; // Zapatos
      case 'hands':
        return 40; // Manos/gestos
      case 'accessory':
        return 120; // Accesorios especiales más caros
      case 'background':
        return 150; // Fondos premium
      default:
        return 50; // Precio por defecto
    }
  }

}
