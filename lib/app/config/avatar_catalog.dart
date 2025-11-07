library;

/// Catálogo de Partes de Avatar
///
/// Define todas las piezas disponibles para personalizar el avatar. Cada
/// elemento apunta a un asset SVG o PNG que se renderiza en capas dentro del
/// widget de avatar.

import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/models/avatar_part_item.dart';

class AvatarCatalog {
  static bool _initialized = false;
  static final Set<String> _availableCategories = <String>{};
  static const List<String> _defaultCategoryOrder = [
    'face',
    'body',
    'hair',
    'top',
    'bottom',
    'shoes',
    'background',
  ];

  // BASES DE PIEL / CARA
  static final List<AvatarPartItem> faces = [
    const AvatarPartItem(
      id: 'face_skin_light',
      category: 'face',
      assetPath: 'assets/avatar/face/skin_light.svg',
      emoji: '😊',
      name: 'Piel clara',
      description: 'Tono de piel claro neutro',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'face_skin_warm',
      category: 'face',
      assetPath: 'assets/avatar/face/skin_warm.svg',
      emoji: '🙂',
      name: 'Piel cálida',
      description: 'Tono de piel cálido',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'face_skin_dark',
      category: 'face',
      assetPath: 'assets/avatar/face/skin_dark.svg',
      emoji: '😌',
      name: 'Piel oscura',
      description: 'Tono de piel oscuro',
      price: 0,
      isDefault: true,
    ),
  ];

  // CUERPOS BASE
  static final List<AvatarPartItem> bodies = [
    const AvatarPartItem(
      id: 'body_kid_boy',
      category: 'body',
      assetPath: 'assets/avatar/body/body_kid_boy.svg',
      emoji: '🧍‍♂️',
      name: 'Cuerpo niño',
      description: 'Base anatómica estilizada para niño',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'body_kid_girl',
      category: 'body',
      assetPath: 'assets/avatar/body/body_kid_girl.svg',
      emoji: '🧍‍♀️',
      name: 'Cuerpo niña',
      description: 'Base anatómica estilizada para niña',
      price: 0,
      isDefault: true,
    ),
  ];

  // OJOS
  static final List<AvatarPartItem> eyes = [
    const AvatarPartItem(
      id: 'eyes_round_brown',
      category: 'eyes',
      assetPath: 'assets/avatar/eyes/round_brown.svg',
      emoji: '👀',
      name: 'Ojos café',
      description: 'Ojos redondos color café',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'eyes_round_hazel',
      category: 'eyes',
      assetPath: 'assets/avatar/eyes/round_hazel.svg',
      emoji: '👁️',
      name: 'Ojos miel',
      description: 'Iris color miel',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'eyes_round_blue',
      category: 'eyes',
      assetPath: 'assets/avatar/eyes/round_blue.svg',
      emoji: '🌊',
      name: 'Ojos azules',
      description: 'Iris azul brillante',
      price: 50,
    ),
    const AvatarPartItem(
      id: 'eyes_round_green',
      category: 'eyes',
      assetPath: 'assets/avatar/eyes/round_green.svg',
      emoji: '🟢',
      name: 'Ojos verdes',
      description: 'Mirada esmeralda',
      price: 50,
    ),
  ];

  // BOCAS
  static final List<AvatarPartItem> mouths = [
    const AvatarPartItem(
      id: 'mouth_smile',
      category: 'mouth',
      assetPath: 'assets/avatar/mouth/smile.svg',
      emoji: '😃',
      name: 'Sonrisa alegre',
      description: 'Sonrisa amigable',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'mouth_grin',
      category: 'mouth',
      assetPath: 'assets/avatar/mouth/grin.svg',
      emoji: '😁',
      name: 'Sonrisa grande',
      description: 'Sonrisa con mucha energía',
      price: 40,
    ),
    const AvatarPartItem(
      id: 'mouth_shy',
      category: 'mouth',
      assetPath: 'assets/avatar/mouth/shy.svg',
      emoji: '😊',
      name: 'Sonrisa tímida',
      description: 'Perfecta para momentos tranquilos',
      price: 35,
    ),
  ];

  // CABELLOS
  static final List<AvatarPartItem> hairs = [
    const AvatarPartItem(
      id: 'hair_curly_dark',
      category: 'hair',
      assetPath: 'assets/avatar/hair/curly_dark.svg',
      emoji: '🦱',
      name: 'Rizado oscuro',
      description: 'Cabello rizado con volumen',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'hair_long_brown',
      category: 'hair',
      assetPath: 'assets/avatar/hair/long_brown.svg',
      emoji: '👧',
      name: 'Largo castaño',
      description: 'Cabello largo y sedoso',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'hair_short_blonde',
      category: 'hair',
      assetPath: 'assets/avatar/hair/short_blonde.svg',
      emoji: '👱',
      name: 'Corto rubio',
      description: 'Look moderno y fresco',
      price: 45,
    ),
    const AvatarPartItem(
      id: 'hair_afro',
      category: 'hair',
      assetPath: 'assets/avatar/hair/afro.svg',
      emoji: '🧑🏾‍🦱',
      name: 'Afro',
      description: 'Estilo afro con personalidad',
      price: 60,
    ),
  ];

  // ROPA SUPERIOR
  static final List<AvatarPartItem> tops = [
    const AvatarPartItem(
      id: 'top_tshirt_blue',
      category: 'top',
      assetPath: 'assets/avatar/top/tshirt_blue.svg',
      emoji: '👕',
      name: 'Camiseta azul',
      description: 'Camiseta deportiva azul',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'top_blouse_magenta',
      category: 'top',
      assetPath: 'assets/avatar/top/blouse_magenta.svg',
      emoji: '👚',
      name: 'Blusa magenta',
      description: 'Blusa elegante y cómoda',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'top_hoodie_green',
      category: 'top',
      assetPath: 'assets/avatar/top/hoodie_green.svg',
      emoji: '🧥',
      name: 'Sudadera verde',
      description: 'Perfecta para aventuras',
      price: 55,
    ),
    const AvatarPartItem(
      id: 'top_jacket_orange',
      category: 'top',
      assetPath: 'assets/avatar/top/jacket_orange.svg',
      emoji: '🦺',
      name: 'Chaqueta naranja',
      description: 'Con detalles reflectantes',
      price: 70,
    ),
  ];

  // ROPA INFERIOR
  static final List<AvatarPartItem> bottoms = [
    const AvatarPartItem(
      id: 'bottom_jeans_dark',
      category: 'bottom',
      assetPath: 'assets/avatar/bottom/jeans_dark.svg',
      emoji: '👖',
      name: 'Jeans oscuros',
      description: 'Pantalón de mezclilla',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'bottom_skirt_teal',
      category: 'bottom',
      assetPath: 'assets/avatar/bottom/skirt_teal.svg',
      emoji: '👗',
      name: 'Falda verde',
      description: 'Falda con vuelo',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'bottom_shorts_red',
      category: 'bottom',
      assetPath: 'assets/avatar/bottom/shorts_red.svg',
      emoji: '🩳',
      name: 'Shorts rojos',
      description: 'Para entrenar o jugar',
      price: 35,
    ),
  ];

  // ZAPATOS
  static final List<AvatarPartItem> shoes = [
    const AvatarPartItem(
      id: 'shoes_sneakers_blue',
      category: 'shoes',
      assetPath: 'assets/avatar/shoes/sneakers_blue.svg',
      emoji: '👟',
      name: 'Tenis azules',
      description: 'Tenis deportivos',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'shoes_sneakers_pink',
      category: 'shoes',
      assetPath: 'assets/avatar/shoes/sneakers_pink.svg',
      emoji: '👟',
      name: 'Tenis rosa',
      description: 'Tenis para combinar con todo',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'shoes_boots_brown',
      category: 'shoes',
      assetPath: 'assets/avatar/shoes/boots_brown.svg',
      emoji: '👢',
      name: 'Botas cafés',
      description: 'Listas para explorar',
      price: 45,
    ),
  ];

  // MANOS / GUANTES
  static final List<AvatarPartItem> hands = [
    const AvatarPartItem(
      id: 'hands_default_light',
      category: 'hands',
      assetPath: 'assets/avatar/hands/hands_light.svg',
      emoji: '👋',
      name: 'Manos claras',
      description: 'Manos tono claro',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'hands_default_warm',
      category: 'hands',
      assetPath: 'assets/avatar/hands/hands_warm.svg',
      emoji: '✋',
      name: 'Manos cálidas',
      description: 'Tono medio cálido',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'hands_default_dark',
      category: 'hands',
      assetPath: 'assets/avatar/hands/hands_dark.svg',
      emoji: '🤚🏾',
      name: 'Manos oscuras',
      description: 'Tono oscuro',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'hands_gloves_space',
      category: 'hands',
      assetPath: 'assets/avatar/hands/gloves_space.svg',
      emoji: '🧤',
      name: 'Guantes espaciales',
      description: 'Guantes para misiones espaciales',
      price: 60,
    ),
  ];

  // ACCESORIOS
  static final List<AvatarPartItem> accessories = [
    const AvatarPartItem(
      id: 'acc_none',
      category: 'accessory',
      assetPath: 'assets/avatar/accessories/none.svg',
      emoji: 'none',
      name: 'Sin accesorio',
      description: 'Sin accesorios adicionales',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'acc_glasses_round',
      category: 'accessory',
      assetPath: 'assets/avatar/accessories/glasses_round.svg',
      emoji: '👓',
      name: 'Gafas redondas',
      description: 'Perfectas para estudiar',
      price: 45,
    ),
    const AvatarPartItem(
      id: 'acc_headphones',
      category: 'accessory',
      assetPath: 'assets/avatar/accessories/headphones.svg',
      emoji: '🎧',
      name: 'Audífonos',
      description: 'Para escuchar música educativa',
      price: 65,
    ),
    const AvatarPartItem(
      id: 'acc_cap_blue',
      category: 'accessory',
      assetPath: 'assets/avatar/accessories/cap_blue.svg',
      emoji: '🧢',
      name: 'Gorra azul',
      description: 'Estilo deportivo',
      price: 40,
    ),
  ];

  // FONDOS
  static final List<AvatarPartItem> backgrounds = [
    const AvatarPartItem(
      id: 'bg_classroom',
      category: 'background',
      assetPath: 'assets/avatar/backgrounds/classroom.svg',
      emoji: '⬜',
      name: 'Salón de clases',
      description: 'Fondo neutro de aula',
      price: 0,
      isDefault: true,
    ),
    const AvatarPartItem(
      id: 'bg_library',
      category: 'background',
      assetPath: 'assets/avatar/backgrounds/library.svg',
      emoji: '📚',
      name: 'Biblioteca',
      description: 'Fondo con libros y conocimiento',
      price: 40,
    ),
    const AvatarPartItem(
      id: 'bg_science_lab',
      category: 'background',
      assetPath: 'assets/avatar/backgrounds/science_lab.svg',
      emoji: '🧪',
      name: 'Laboratorio',
      description: 'Ideal para experimentos',
      price: 60,
    ),
    const AvatarPartItem(
      id: 'bg_space',
      category: 'background',
      assetPath: 'assets/avatar/backgrounds/space.svg',
      emoji: '🌌',
      name: 'Espacio',
      description: 'Aprende entre las estrellas',
      price: 80,
    ),
  ];

  static final Map<String, List<AvatarPartItem>> _partsByCategory = {
    'face': faces,
    'body': bodies,
    'eyes': eyes,
    'mouth': mouths,
    'hair': hairs,
    'top': tops,
    'bottom': bottoms,
    'shoes': shoes,
    'hands': hands,
    'accessory': accessories,
    'background': backgrounds,
  };

  /// Carga dinámicamente todas las piezas declaradas en los assets.
  ///
  /// Esto permite agregar nuevas piezas simplemente colocando los archivos
  /// dentro de `assets/avatar/<categoria>/` sin modificar el código.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap =
          jsonDecode(manifestContent) as Map<String, dynamic>;

      _availableCategories.clear();

      manifestMap.forEach((assetPath, value) {
        if (!assetPath.startsWith('assets/avatar/')) {
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

        _availableCategories.add(category);

        final parts = _partsByCategory[category];
        if (parts == null) {
          return;
        }

        final alreadyExists = parts.any(
          (part) => part.assetPath.toLowerCase() == assetPath.toLowerCase(),
        );
        if (alreadyExists) {
          return;
        }

        final item = AvatarPartItem(
          id: _generateId(category, segments.last, parts),
          category: category,
          assetPath: assetPath,
          name: _formatName(segments.last),
          description: _defaultDescription(category),
          price: 0,
          isDefault: true,
          emoji: _categoryEmoji(category),
        );

        parts.add(item);
      });

      // Ordenamos las piezas manteniendo primero las predeterminadas.
      for (final parts in _partsByCategory.values) {
        parts.sort((a, b) {
          if (a.isDefault == b.isDefault) {
            return a.name.compareTo(b.name);
          }
          return a.isDefault ? -1 : 1;
        });
      }
    } catch (_) {
      // Ignoramos el error en entornos donde el manifest no esté disponible
      // (por ejemplo, pruebas de unidad). En ese caso conservamos solo los
      // elementos declarados manualmente.
    } finally {
      _initialized = true;
    }
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
        .map((segment) =>
            segment[0].toUpperCase() + segment.substring(1).toLowerCase())
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
        return null;
    }
  }

  /// Obtiene todas las partes de una categoría
  static List<AvatarPartItem> getPartsByCategory(String category) {
    switch (category) {
      case 'face':
        return faces;
      case 'body':
        return bodies;
      case 'eyes':
        return eyes;
      case 'mouth':
        return mouths;
      case 'hair':
        return hairs;
      case 'top':
        return tops;
      case 'bottom':
        return bottoms;
      case 'shoes':
        return shoes;
      case 'hands':
        return hands;
      case 'accessory':
        return accessories;
      case 'background':
        return backgrounds;
      default:
        return [];
    }
  }

  /// Obtiene una parte por su ID
  static AvatarPartItem? getPartById(String id) {
    for (final part in _allParts) {
      if (part.id == id) {
        return part;
      }
    }
    return null;
  }

  /// Obtiene una parte por emoji (compatibilidad con datos antiguos)
  static AvatarPartItem? getPartByEmoji(String? emoji, String category) {
    if (emoji == null) return null;
    for (final part in getPartsByCategory(category)) {
      if (part.emoji == emoji) {
        return part;
      }
    }
    return null;
  }

  /// Obtiene una parte por ruta de asset
  static AvatarPartItem? getPartByAsset(String? assetPath, String category) {
    if (assetPath == null) return null;
    for (final part in getPartsByCategory(category)) {
      if (part.assetPath == assetPath) {
        return part;
      }
    }
    return null;
  }

  /// Resuelve cualquier valor almacenado (emoji antiguo, id o ruta) a un ID válido
  static String resolvePartId(
    String? rawValue, {
    required String category,
    required String fallbackId,
  }) {
    if (rawValue == null || rawValue.isEmpty) {
      return fallbackId;
    }

    if (category == 'accessory' && rawValue == 'none') {
      return 'acc_none';
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

    return fallbackId;
  }

  /// Retorna la lista de IDs desbloqueados por defecto para la categoría
  static List<String> getDefaultUnlockedIds(String category) {
    return getPartsByCategory(category)
        .where((part) => part.isDefault)
        .map((part) => part.id)
        .toList();
  }

  /// Obtiene todas las categorías disponibles
  static List<String> get categories {
    if (_availableCategories.isEmpty) {
      return List.unmodifiable(_defaultCategoryOrder);
    }

    final ordered = _defaultCategoryOrder
        .where((category) => _availableCategories.contains(category))
        .toList();

    for (final category in _availableCategories) {
      if (!ordered.contains(category)) {
        ordered.add(category);
      }
    }

    return List.unmodifiable(ordered);
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

  /// Obtiene el nombre en español de una categoría
  static String getCategoryName(String category) {
    switch (category) {
      case 'face':
        return 'Piel';
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

  /// Obtiene el icono de una categoría
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

  static List<AvatarPartItem> get _allParts => [
        ...faces,
        ...bodies,
        ...eyes,
        ...mouths,
        ...hairs,
        ...tops,
        ...bottoms,
        ...shoes,
        ...hands,
        ...accessories,
        ...backgrounds,
      ];
}
