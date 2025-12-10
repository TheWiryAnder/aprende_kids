/// Servicio para gestionar estadísticas y monedas del usuario
///
/// Maneja la actualización de monedas, puntos y estadísticas
/// cuando el usuario completa juegos
///
/// Autor: APRENDE_KIDS
/// Fecha: 2025

import 'package:cloud_firestore/cloud_firestore.dart';

class UserStatsService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Actualiza las monedas y estadísticas del usuario al completar un juego
  ///
  /// [userId] - ID del usuario
  /// [coinsEarned] - Monedas ganadas en este juego
  /// [scoreEarned] - Puntos ganados en este juego
  Future<void> updateUserStatsAfterGame({
    required String userId,
    required int coinsEarned,
    required int scoreEarned,
  }) async {
    try {
      final userRef = _firestore.collection('users').doc(userId);

      // Usar transacción para garantizar consistencia
      await _firestore.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists) {
          throw Exception('Usuario no encontrado');
        }

        // Incrementar monedas, puntos totales y juegos jugados
        transaction.update(userRef, {
          'coins': FieldValue.increment(coinsEarned),
          'totalScore': FieldValue.increment(scoreEarned),
          'gamesPlayed': FieldValue.increment(1),
        });
      });

      print('✅ Estadísticas actualizadas: +$coinsEarned monedas, +$scoreEarned puntos');
    } catch (e) {
      print('❌ Error al actualizar estadísticas del usuario: $e');
      rethrow;
    }
  }

  /// Obtiene las monedas actuales del usuario
  Future<int> getUserCoins(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return 0;
      }

      final data = userDoc.data() as Map<String, dynamic>;
      return data['coins'] as int? ?? 0;
    } catch (e) {
      print('❌ Error al obtener monedas del usuario: $e');
      return 0;
    }
  }

  /// Obtiene las estadísticas completas del usuario
  Future<Map<String, int>> getUserStats(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        return {
          'coins': 0,
          'totalScore': 0,
          'gamesPlayed': 0,
        };
      }

      final data = userDoc.data() as Map<String, dynamic>;
      return {
        'coins': data['coins'] as int? ?? 0,
        'totalScore': data['totalScore'] as int? ?? 0,
        'gamesPlayed': data['gamesPlayed'] as int? ?? 0,
      };
    } catch (e) {
      print('❌ Error al obtener estadísticas del usuario: $e');
      return {
        'coins': 0,
        'totalScore': 0,
        'gamesPlayed': 0,
      };
    }
  }

  /// Stream para escuchar cambios en las monedas del usuario en tiempo real
  Stream<int> watchUserCoins(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) return 0;
      final data = snapshot.data() as Map<String, dynamic>;
      return data['coins'] as int? ?? 0;
    });
  }

  /// Stream para escuchar cambios en las estadísticas del usuario
  Stream<Map<String, int>> watchUserStats(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .snapshots()
        .map((snapshot) {
      if (!snapshot.exists) {
        return {
          'coins': 0,
          'totalScore': 0,
          'gamesPlayed': 0,
        };
      }

      final data = snapshot.data() as Map<String, dynamic>;
      return {
        'coins': data['coins'] as int? ?? 0,
        'totalScore': data['totalScore'] as int? ?? 0,
        'gamesPlayed': data['gamesPlayed'] as int? ?? 0,
      };
    });
  }
}
