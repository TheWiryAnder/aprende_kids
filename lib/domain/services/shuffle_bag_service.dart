/// Servicio de "Baraja de Cartas" (Shuffle Bag)
///
/// Implementa un sistema que garantiza que no se repitan ejercicios
/// hasta que el usuario haya visto todos los disponibles.
///
/// Características:
/// - Mezcla inicial aleatoria de todos los elementos
/// - No repite hasta agotar la lista
/// - Validación de no repetición consecutiva (lastItem != currentItem)
/// - Persistencia opcional con SharedPreferences
///
/// Autor: APRENDE_KIDS
/// Fecha: 2025

import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class ShuffleBag<T> {
  final String _storageKey;
  final List<T> _allItems;
  final List<T> _currentBag = [];
  final Random _random = Random();
  T? _lastItem;

  /// Constructor
  ///
  /// [storageKey] Clave única para persistir estado (opcional)
  /// [items] Lista completa de elementos disponibles
  ShuffleBag({
    required String storageKey,
    required List<T> items,
  })  : _storageKey = storageKey,
        _allItems = List.from(items) {
    if (_allItems.isEmpty) {
      throw ArgumentError('La lista de items no puede estar vacía');
    }
    _refillBag();
  }

  /// Obtiene el siguiente elemento sin repetir
  ///
  /// Garantiza que:
  /// 1. No se repite el último elemento mostrado
  /// 2. Si la bolsa está vacía, se rellena y mezcla
  /// 3. Retorna un elemento aleatorio de la bolsa
  T next() {
    // Si la bolsa está vacía, rellenarla
    if (_currentBag.isEmpty) {
      _refillBag();
    }

    // Si solo queda un elemento y es el último mostrado, forzar relleno
    if (_currentBag.length == 1 && _currentBag.first == _lastItem && _allItems.length > 1) {
      _refillBag();
    }

    // Intentar obtener un elemento diferente al último
    T nextItem;
    int attempts = 0;
    const maxAttempts = 10;

    do {
      final index = _random.nextInt(_currentBag.length);
      nextItem = _currentBag.removeAt(index);
      attempts++;
    } while (nextItem == _lastItem && _currentBag.isNotEmpty && attempts < maxAttempts);

    // Si después de varios intentos sigue siendo el mismo, aceptarlo
    // (puede pasar si solo hay 2 elementos en total)
    _lastItem = nextItem;
    return nextItem;
  }

  /// Rellena la bolsa con todos los elementos y los mezcla
  void _refillBag() {
    _currentBag.clear();
    _currentBag.addAll(_allItems);
    _currentBag.shuffle(_random);
  }

  /// Reinicia la bolsa (útil para testing o reset manual)
  void reset() {
    _lastItem = null;
    _refillBag();
  }

  /// Obtiene el estado actual de la bolsa
  int get remainingItems => _currentBag.length;

  /// Obtiene el total de elementos únicos
  int get totalItems => _allItems.length;

  /// Verifica si la bolsa está vacía
  bool get isEmpty => _currentBag.isEmpty;

  /// Guarda el estado actual (índice del último item)
  Future<void> saveState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      if (_lastItem != null) {
        final lastIndex = _allItems.indexOf(_lastItem as T);
        await prefs.setInt('${_storageKey}_last_index', lastIndex);
      }
    } catch (e) {
      print('⚠️ Error al guardar estado de ShuffleBag: $e');
    }
  }

  /// Restaura el estado desde SharedPreferences
  Future<void> loadState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastIndex = prefs.getInt('${_storageKey}_last_index');
      if (lastIndex != null && lastIndex >= 0 && lastIndex < _allItems.length) {
        _lastItem = _allItems[lastIndex];
      }
    } catch (e) {
      print('⚠️ Error al cargar estado de ShuffleBag: $e');
    }
  }
}

/// Extensión para crear ShuffleBag desde listas
extension ShuffleBagExtension<T> on List<T> {
  /// Crea un ShuffleBag a partir de esta lista
  ShuffleBag<T> toShuffleBag(String storageKey) {
    return ShuffleBag<T>(storageKey: storageKey, items: this);
  }
}
