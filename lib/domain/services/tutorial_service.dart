/// Servicio para gestionar el tutorial de primera vez
///
/// Maneja la persistencia local usando SharedPreferences para
/// determinar si el usuario ya ha visto el tutorial introductorio
///
/// Autor: APRENDE_KIDS
/// Fecha: 2025

import 'package:shared_preferences/shared_preferences.dart';

class TutorialService {
  static const String _tutorialKey = 'has_seen_tutorial';

  /// Verifica si el usuario ya ha visto el tutorial
  Future<bool> hasSeenTutorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_tutorialKey) ?? false;
    } catch (e) {
      print('❌ Error al verificar tutorial: $e');
      return false;
    }
  }

  /// Marca el tutorial como completado
  Future<void> markTutorialAsCompleted() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_tutorialKey, true);
      print('✅ Tutorial marcado como completado');
    } catch (e) {
      print('❌ Error al guardar estado del tutorial: $e');
    }
  }

  /// Reinicia el tutorial (útil para testing o si el usuario quiere verlo de nuevo)
  Future<void> resetTutorial() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_tutorialKey, false);
      print('🔄 Tutorial reiniciado');
    } catch (e) {
      print('❌ Error al reiniciar tutorial: $e');
    }
  }
}
