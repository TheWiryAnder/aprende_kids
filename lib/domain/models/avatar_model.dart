library;

import '../../app/config/avatar_catalog.dart';
import 'avatar_part_item.dart';

/// Modelo de Avatar
///
/// Representa un avatar personalizable basado en capas gráficas.
/// Cada campo almacena el identificador de una pieza dentro del
/// [AvatarCatalog], lo que permite renderizar texturas, ropa y
/// accesorios intercambiables.
class AvatarModel {
  final String userId;
  final String gender; // 'male' o 'female'

  // Partes del avatar (identificadores de asset)
  final String face; // Cara/base de piel
  final String body; // Cuerpo base
  final String eyes; // Ojos
  final String mouth; // Boca
  final String hair; // Cabello
  final String top; // Ropa superior
  final String bottom; // Ropa inferior
  final String shoes; // Zapatos
  final String hands; // Manos/guantes
  final String accessory; // Accesorio (gafas, gorro, etc.)
  final String background; // Fondo del avatar

  // Expresiones/animaciones disponibles
  final String currentExpression; // 'neutral', 'happy', 'thinking', 'celebrating', 'jumping', etc.

  // Partes desbloqueadas por el usuario
  final List<String> unlockedFaces;
  final List<String> unlockedBodies;
  final List<String> unlockedEyes;
  final List<String> unlockedMouths;
  final List<String> unlockedHairs;
  final List<String> unlockedTops;
  final List<String> unlockedBottoms;
  final List<String> unlockedShoes;
  final List<String> unlockedHands;
  final List<String> unlockedAccessories;
  final List<String> unlockedBackgrounds;

  const AvatarModel({
    required this.userId,
    required this.gender,
    required this.face,
    required this.body,
    required this.eyes,
    required this.mouth,
    required this.hair,
    required this.top,
    required this.bottom,
    required this.shoes,
    required this.hands,
    required this.accessory,
    required this.background,
    this.currentExpression = 'neutral',
    this.unlockedFaces = const [],
    this.unlockedBodies = const [],
    this.unlockedEyes = const [],
    this.unlockedMouths = const [],
    this.unlockedHairs = const [],
    this.unlockedTops = const [],
    this.unlockedBottoms = const [],
    this.unlockedShoes = const [],
    this.unlockedHands = const [],
    this.unlockedAccessories = const [],
    this.unlockedBackgrounds = const [],
  });

  /// Crea un avatar básico para un nuevo usuario masculino
  factory AvatarModel.defaultMale(String userId) {
    String _default(String category) {
      return AvatarCatalog.fallbackForCategory(category);
    }

    List<String> _defaults(String category) {
      return AvatarCatalog.getDefaultUnlockedIds(category);
    }

    return AvatarModel(
      userId: userId,
      gender: 'male',
      face: _default('face'),
      body: _default('body'),
      eyes: _default('eyes'),
      mouth: _default('mouth'),
      hair: _default('hair'),
      top: _default('top'),
      bottom: _default('bottom'),
      shoes: _default('shoes'),
      hands: _default('hands'),
      accessory: _default('accessory'),
      background: _default('background'),
      unlockedFaces: _defaults('face'),
      unlockedBodies: _defaults('body'),
      unlockedEyes: _defaults('eyes'),
      unlockedMouths: _defaults('mouth'),
      unlockedHairs: _defaults('hair'),
      unlockedTops: _defaults('top'),
      unlockedBottoms: _defaults('bottom'),
      unlockedShoes: _defaults('shoes'),
      unlockedHands: _defaults('hands'),
      unlockedAccessories: _defaults('accessory'),
      unlockedBackgrounds: _defaults('background'),
    );
  }

  /// Crea un avatar básico para un nuevo usuario femenino
  factory AvatarModel.defaultFemale(String userId) {
    String _default(String category) {
      return AvatarCatalog.fallbackForCategory(category);
    }

    List<String> _defaults(String category) {
      return AvatarCatalog.getDefaultUnlockedIds(category);
    }

    return AvatarModel(
      userId: userId,
      gender: 'female',
      face: _default('face'),
      body: _default('body'),
      eyes: _default('eyes'),
      mouth: _default('mouth'),
      hair: _default('hair'),
      top: _default('top'),
      bottom: _default('bottom'),
      shoes: _default('shoes'),
      hands: _default('hands'),
      accessory: _default('accessory'),
      background: _default('background'),
      unlockedFaces: _defaults('face'),
      unlockedBodies: _defaults('body'),
      unlockedEyes: _defaults('eyes'),
      unlockedMouths: _defaults('mouth'),
      unlockedHairs: _defaults('hair'),
      unlockedTops: _defaults('top'),
      unlockedBottoms: _defaults('bottom'),
      unlockedShoes: _defaults('shoes'),
      unlockedHands: _defaults('hands'),
      unlockedAccessories: _defaults('accessory'),
      unlockedBackgrounds: _defaults('background'),
    );
  }

  /// Convierte el modelo a Map para Firebase
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'gender': gender,
      'face': face,
      'body': body,
      'eyes': eyes,
      'mouth': mouth,
      'hair': hair,
      'top': top,
      'bottom': bottom,
      'shoes': shoes,
      'hands': hands,
      'accessory': accessory,
      'background': background,
      'currentExpression': currentExpression,
      'unlockedFaces': unlockedFaces,
      'unlockedBodies': unlockedBodies,
      'unlockedEyes': unlockedEyes,
      'unlockedMouths': unlockedMouths,
      'unlockedHairs': unlockedHairs,
      'unlockedTops': unlockedTops,
      'unlockedBottoms': unlockedBottoms,
      'unlockedShoes': unlockedShoes,
      'unlockedHands': unlockedHands,
      'unlockedAccessories': unlockedAccessories,
      'unlockedBackgrounds': unlockedBackgrounds,
    };
  }

  /// Crea un modelo desde Map de Firebase con compatibilidad retroactiva
  factory AvatarModel.fromMap(Map<String, dynamic> map) {
    final gender = (map['gender'] as String? ?? 'male').toLowerCase();
    return AvatarModel(
      userId: map['userId'] as String? ?? '',
      gender: gender,
      face: AvatarCatalog.resolvePartId(
        map['face'] as String?,
        category: 'face',
        fallbackId: AvatarCatalog.fallbackForCategory('face'),
      ),
      body: AvatarCatalog.resolvePartId(
        map['body'] as String?,
        category: 'body',
        fallbackId: AvatarCatalog.fallbackForCategory('body'),
      ),
      eyes: AvatarCatalog.resolvePartId(
        map['eyes'] as String?,
        category: 'eyes',
        fallbackId: AvatarCatalog.fallbackForCategory('eyes'),
      ),
      mouth: AvatarCatalog.resolvePartId(
        map['mouth'] as String?,
        category: 'mouth',
        fallbackId: AvatarCatalog.fallbackForCategory('mouth'),
      ),
      hair: AvatarCatalog.resolvePartId(
        map['hair'] as String?,
        category: 'hair',
        fallbackId: AvatarCatalog.fallbackForCategory('hair'),
      ),
      top: AvatarCatalog.resolvePartId(
        map['top'] as String?,
        category: 'top',
        fallbackId: AvatarCatalog.fallbackForCategory('top'),
      ),
      bottom: AvatarCatalog.resolvePartId(
        map['bottom'] as String?,
        category: 'bottom',
        fallbackId: AvatarCatalog.fallbackForCategory('bottom'),
      ),
      shoes: AvatarCatalog.resolvePartId(
        map['shoes'] as String?,
        category: 'shoes',
        fallbackId: AvatarCatalog.fallbackForCategory('shoes'),
      ),
      hands: AvatarCatalog.resolvePartId(
        map['hands'] as String?,
        category: 'hands',
        fallbackId: AvatarCatalog.fallbackForCategory('hands'),
      ),
      accessory: AvatarCatalog.resolvePartId(
        map['accessory'] as String?,
        category: 'accessory',
        fallbackId: AvatarCatalog.fallbackForCategory('accessory'),
      ),
      background: AvatarCatalog.resolvePartId(
        map['background'] as String?,
        category: 'background',
        fallbackId: AvatarCatalog.fallbackForCategory('background'),
      ),
      currentExpression: map['currentExpression'] as String? ?? 'neutral',
      unlockedFaces: _mapUnlocked(map['unlockedFaces'], 'face'),
      unlockedBodies: _mapUnlocked(map['unlockedBodies'], 'body'),
      unlockedEyes: _mapUnlocked(map['unlockedEyes'], 'eyes'),
      unlockedMouths: _mapUnlocked(map['unlockedMouths'], 'mouth'),
      unlockedHairs: _mapUnlocked(map['unlockedHairs'], 'hair'),
      unlockedTops: _mapUnlocked(map['unlockedTops'], 'top'),
      unlockedBottoms: _mapUnlocked(map['unlockedBottoms'], 'bottom'),
      unlockedShoes: _mapUnlocked(map['unlockedShoes'], 'shoes'),
      unlockedHands: _mapUnlocked(map['unlockedHands'], 'hands'),
      unlockedAccessories:
          _mapUnlocked(map['unlockedAccessories'], 'accessory'),
      unlockedBackgrounds:
          _mapUnlocked(map['unlockedBackgrounds'], 'background'),
    );
  }

  static List<String> _mapUnlocked(dynamic rawList, String category) {
    final defaultIds = AvatarCatalog.getDefaultUnlockedIds(category);
    if (rawList == null) {
      return defaultIds;
    }

    final entries = List<String>.from(rawList as List);
    final fallback = defaultIds.isNotEmpty ? defaultIds.first : '';
    final resolved = <String>{...defaultIds};

    for (final value in entries) {
      final normalized = AvatarCatalog.resolvePartId(
        value,
        category: category,
        fallbackId: fallback,
      );

      if (normalized.isNotEmpty) {
        resolved.add(normalized);
      }
    }

    return resolved.toList();
  }

  /// Copia el avatar con cambios
  AvatarModel copyWith({
    String? userId,
    String? gender,
    String? face,
    String? body,
    String? eyes,
    String? mouth,
    String? hair,
    String? top,
    String? bottom,
    String? shoes,
    String? hands,
    String? accessory,
    String? background,
    String? currentExpression,
    List<String>? unlockedFaces,
    List<String>? unlockedBodies,
    List<String>? unlockedEyes,
    List<String>? unlockedMouths,
    List<String>? unlockedHairs,
    List<String>? unlockedTops,
    List<String>? unlockedBottoms,
    List<String>? unlockedShoes,
    List<String>? unlockedHands,
    List<String>? unlockedAccessories,
    List<String>? unlockedBackgrounds,
  }) {
    return AvatarModel(
      userId: userId ?? this.userId,
      gender: gender ?? this.gender,
      face: face ?? this.face,
      body: body ?? this.body,
      eyes: eyes ?? this.eyes,
      mouth: mouth ?? this.mouth,
      hair: hair ?? this.hair,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      shoes: shoes ?? this.shoes,
      hands: hands ?? this.hands,
      accessory: accessory ?? this.accessory,
      background: background ?? this.background,
      currentExpression: currentExpression ?? this.currentExpression,
      unlockedFaces: unlockedFaces ?? this.unlockedFaces,
      unlockedBodies: unlockedBodies ?? this.unlockedBodies,
      unlockedEyes: unlockedEyes ?? this.unlockedEyes,
      unlockedMouths: unlockedMouths ?? this.unlockedMouths,
      unlockedHairs: unlockedHairs ?? this.unlockedHairs,
      unlockedTops: unlockedTops ?? this.unlockedTops,
      unlockedBottoms: unlockedBottoms ?? this.unlockedBottoms,
      unlockedShoes: unlockedShoes ?? this.unlockedShoes,
      unlockedHands: unlockedHands ?? this.unlockedHands,
      unlockedAccessories: unlockedAccessories ?? this.unlockedAccessories,
      unlockedBackgrounds: unlockedBackgrounds ?? this.unlockedBackgrounds,
    );
  }

  /// Obtiene la parte seleccionada por categoría, útil para UI
  AvatarPartItem? partForCategory(String category) {
    switch (category) {
      case 'face':
        return AvatarCatalog.getPartById(face);
      case 'body':
        return AvatarCatalog.getPartById(body);
      case 'eyes':
        return AvatarCatalog.getPartById(eyes);
      case 'mouth':
        return AvatarCatalog.getPartById(mouth);
      case 'hair':
        return AvatarCatalog.getPartById(hair);
      case 'top':
        return AvatarCatalog.getPartById(top);
      case 'bottom':
        return AvatarCatalog.getPartById(bottom);
      case 'shoes':
        return AvatarCatalog.getPartById(shoes);
      case 'hands':
        return AvatarCatalog.getPartById(hands);
      case 'accessory':
        return AvatarCatalog.getPartById(accessory);
      case 'background':
        return AvatarCatalog.getPartById(background);
      default:
        return null;
    }
  }
}
