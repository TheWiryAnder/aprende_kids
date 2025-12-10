/// Modelo de datos de usuario
///
/// Representa un usuario (niño) en la aplicación
/// Incluye configuraciones y preferencias
///
/// Autor: [Tu nombre]
/// Fecha: 2025

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String userId;
  final String username;
  final String displayName;
  final String avatarId;
  final int age;
  final DateTime dateCreated;
  final String? parentEmail;
  final UserSettings settings;
  final int coins;
  final int totalScore;
  final int gamesPlayed;

  const UserModel({
    required this.userId,
    required this.username,
    required this.displayName,
    required this.avatarId,
    required this.age,
    required this.dateCreated,
    this.parentEmail,
    required this.settings,
    this.coins = 0,
    this.totalScore = 0,
    this.gamesPlayed = 0,
  });

  /// Crear desde JSON (Firestore)
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      username: json['username'] as String? ?? '',
      displayName: json['displayName'] as String,
      avatarId: json['avatarId'] as String,
      age: json['age'] as int,
      dateCreated: (json['dateCreated'] as Timestamp).toDate(),
      parentEmail: json['parentEmail'] as String?,
      settings: UserSettings.fromJson(json['settings'] as Map<String, dynamic>),
      coins: json['coins'] as int? ?? 0,
      totalScore: json['totalScore'] as int? ?? 0,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
    );
  }

  /// Convertir a JSON (Firestore)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'displayName': displayName,
      'avatarId': avatarId,
      'age': age,
      'dateCreated': Timestamp.fromDate(dateCreated),
      'parentEmail': parentEmail,
      'settings': settings.toJson(),
      'coins': coins,
      'totalScore': totalScore,
      'gamesPlayed': gamesPlayed,
    };
  }

  /// Copiar con modificaciones
  UserModel copyWith({
    String? userId,
    String? username,
    String? displayName,
    String? avatarId,
    int? age,
    DateTime? dateCreated,
    String? parentEmail,
    UserSettings? settings,
    int? coins,
    int? totalScore,
    int? gamesPlayed,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      avatarId: avatarId ?? this.avatarId,
      age: age ?? this.age,
      dateCreated: dateCreated ?? this.dateCreated,
      parentEmail: parentEmail ?? this.parentEmail,
      settings: settings ?? this.settings,
      coins: coins ?? this.coins,
      totalScore: totalScore ?? this.totalScore,
      gamesPlayed: gamesPlayed ?? this.gamesPlayed,
    );
  }

  @override
  List<Object?> get props => [
        userId,
        username,
        displayName,
        avatarId,
        age,
        dateCreated,
        parentEmail,
        settings,
        coins,
        totalScore,
        gamesPlayed,
      ];
}

/// Configuraciones del usuario
class UserSettings extends Equatable {
  final bool soundEnabled;
  final bool musicEnabled;
  final String difficulty;

  const UserSettings({
    this.soundEnabled = true,
    this.musicEnabled = true,
    this.difficulty = 'easy',
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      soundEnabled: json['soundEnabled'] as bool? ?? true,
      musicEnabled: json['musicEnabled'] as bool? ?? true,
      difficulty: json['difficulty'] as String? ?? 'easy',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'soundEnabled': soundEnabled,
      'musicEnabled': musicEnabled,
      'difficulty': difficulty,
    };
  }

  UserSettings copyWith({
    bool? soundEnabled,
    bool? musicEnabled,
    String? difficulty,
  }) {
    return UserSettings(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      musicEnabled: musicEnabled ?? this.musicEnabled,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  @override
  List<Object?> get props => [soundEnabled, musicEnabled, difficulty];
}
