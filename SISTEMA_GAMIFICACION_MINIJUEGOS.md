# Sistema de Gamificación para Minijuegos

## Fecha: 2025-12-07

---

## Descripción General

Implementación completa del **sistema de gamificación** (temporizador, monedas y GIFs de avatar) en los dos minijuegos principales:
- **Sopa de Letras** (Word Search)
- **Clasifica y Gana** (Emoji Sorting)

Este sistema replica la experiencia de los módulos principales del curso, proporcionando feedback visual constante y recompensas basadas en el desempeño.

---

## Características Implementadas

### 1. Sistema de Temporizador (Timer)

#### Cuenta Regresiva Visual
- **Ubicación**: Header del juego (esquina superior derecha)
- **Formato**: MM:SS (minutos:segundos)
- **Actualización**: Cada 1 segundo
- **Feedback Visual Dinámico**:
  - `> 60 segundos`: Fondo blanco, texto teal
  - `31-60 segundos`: Fondo naranja claro, texto naranja oscuro
  - `≤ 30 segundos`: Fondo rojo claro, texto rojo oscuro (urgencia)

#### Tiempos por Nivel

**Word Search (Sopa de Letras)**:
```dart
WordSearchLevel.basico:     120 segundos (2 minutos)
WordSearchLevel.intermedio: 240 segundos (4 minutos)
WordSearchLevel.avanzado:   300 segundos (5 minutos)
```

**Emoji Sorting (Clasifica y Gana)**:
```dart
EmojiSortingLevel.basico:    90 segundos (1.5 minutos)
EmojiSortingLevel.intermedio: 150 segundos (2.5 minutos)
EmojiSortingLevel.avanzado:   180 segundos (3 minutos)
```

#### Lógica de Timer
```dart
void _initializeTimer() {
  final config = LevelConfig.configs[widget.level]!;
  _timeLimit = config.timeLimit;
  _timeRemaining = _timeLimit;

  _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
    if (_gameEnded) {
      timer.cancel();
      return;
    }

    setState(() {
      if (_timeRemaining > 0) {
        _timeRemaining--;
      } else {
        _gameEnded = true;
        timer.cancel();
        _showTimeoutDialog();
      }
    });
  });
}
```

### 2. Sistema de Monedas (Coins)

#### Fórmula de Cálculo
```dart
static int calculateCoins(int timeRemaining, int timeLimit) {
  if (timeRemaining <= 0) return 10; // Mínimo por completar

  // Fórmula: más tiempo restante = más monedas
  // Máximo 50, mínimo 10
  final percentage = timeRemaining / timeLimit;
  final coins = (10 + (40 * percentage)).round();
  return coins.clamp(10, 50);
}
```

#### Ejemplos de Recompensas

**Nivel Básico Word Search (2 minutos)**:
- Completado en 10 segundos restantes → `10 + (40 * 10/120) = 13 monedas`
- Completado en 60 segundos restantes → `10 + (40 * 60/120) = 30 monedas`
- Completado en 120 segundos restantes → `10 + (40 * 120/120) = 50 monedas` ⭐

**Nivel Avanzado Emoji Sorting (3 minutos)**:
- Completado en 30 segundos restantes → `10 + (40 * 30/180) = 17 monedas`
- Completado en 90 segundos restantes → `10 + (40 * 90/180) = 30 monedas`
- Completado en 180 segundos restantes → `10 + (40 * 180/180) = 50 monedas` ⭐

#### Visualización de Monedas
- **Ubicación**: Diálogo de victoria
- **Diseño**:
  - Emoji 💰 + Texto "X Monedas"
  - Tamaño grande (24px) con color amber
  - Tiempo restante mostrado debajo

### 3. Sistema de GIFs de Avatar

#### Estados del Juego con GIFs

**Durante el Juego** (Pensando):
- **GIF**: `pensando.gif`
- **Ubicación**: Esquina inferior derecha
- **Tamaño**: 80x80 px
- **Diseño**: Contenedor blanco con sombra
- **Condición**: Solo visible si `!_gameEnded`

**Victoria** (Celebración):
- **GIF**: `excelente.gif`
- **Ubicación**: Centro del diálogo modal
- **Tamaño**: 200x200 px
- **Acompañamiento**:
  - Mensaje: "¡Felicitaciones! 🎊"
  - Cantidad de monedas ganadas
  - Tiempo restante

**Timeout** (Ánimo):
- **GIF**: `intentalo.gif`
- **Ubicación**: Centro del diálogo modal
- **Tamaño**: 200x200 px
- **Acompañamiento**:
  - Mensaje: "¡Se acabó el tiempo!"
  - Progreso alcanzado
  - Botón "Reintentar"

#### Implementación de GIFs
```dart
// GIF durante el juego
if (!_gameEnded)
  Positioned(
    bottom: 16,
    right: 16,
    child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(8),
      child: const GameVideoWidget(
        videoType: GameVideoType.pensando,
        width: 80,
        height: 80,
      ),
    ),
  ),
```

### 4. Control de Estado del Juego

#### Variable `_gameEnded`
```dart
bool _gameEnded = false;
```

**Propósito**: Prevenir interacciones después de que el juego termina

**Usos**:
1. Detener el timer cuando termina el juego
2. Ocultar el GIF de "pensando"
3. Prevenir drag & drop después de victoria/timeout
4. Evitar múltiples diálogos de victoria

#### Ejemplo de Uso en Emoji Sorting
```dart
void _onEmojiDrop(String emoji, int categoryIndex) {
  if (_gameEnded) return; // No permitir interacción

  // ... lógica de validación ...

  if (_checkVictory() && !_gameEnded) {
    setState(() => _gameEnded = true);
    _gameTimer?.cancel();
    Future.delayed(const Duration(milliseconds: 500), _showVictoryDialog);
  }
}
```

---

## Modificaciones en Archivos

### Modelos de Datos

#### 1. `lib/domain/models/word_search_model.dart`

**Cambios**:
- Agregado campo `timeLimit` a `LevelConfig`
- Agregado método estático `calculateCoins()`

```dart
class LevelConfig {
  final int gridSize;
  final List<WordDirection> allowedDirections;
  final int minWords;
  final int maxWords;
  final int timeLimit; // NUEVO ⭐

  static const Map<WordSearchLevel, LevelConfig> configs = {
    WordSearchLevel.basico: LevelConfig(
      gridSize: 8,
      allowedDirections: [horizontal, vertical],
      minWords: 3,
      maxWords: 5,
      timeLimit: 120, // NUEVO ⭐
    ),
    // ... otros niveles
  };

  // NUEVO: Método de cálculo de monedas ⭐
  static int calculateCoins(int timeRemaining, int timeLimit) {
    if (timeRemaining <= 0) return 10;
    final percentage = timeRemaining / timeLimit;
    final coins = (10 + (40 * percentage)).round();
    return coins.clamp(10, 50);
  }
}
```

#### 2. `lib/domain/models/emoji_sorting_model.dart`

**Cambios**: Idénticos a word_search_model.dart
- Campo `timeLimit` (90s, 150s, 180s)
- Método `calculateCoins()`

### Pantallas de Juego

#### 3. `lib/presentation/screens/games/word_search_game.dart`

**Nuevas Importaciones**:
```dart
import 'dart:async';
import '../../widgets/game_video_widget.dart';
```

**Nuevos Campos**:
```dart
late int _timeRemaining;
late int _timeLimit;
Timer? _gameTimer;
bool _gameEnded = false;
```

**Nuevos Métodos**:
- `_initializeTimer()` - Inicializa y maneja el temporizador
- `_formatTime(int seconds)` - Formatea segundos a MM:SS
- `_showTimeoutDialog()` - Diálogo cuando se acaba el tiempo

**Métodos Modificados**:
- `_buildHeader()` - Agregado display del timer con colores dinámicos
- `_showVictoryDialog()` - Ahora muestra monedas y GIF de celebración
- `_showWordFoundFeedback()` - Previene victoria después de timeout
- `build()` - Agregado Stack con GIF de pensando

#### 4. `lib/presentation/screens/games/emoji_sorting_game.dart`

**Cambios**: Idénticos a word_search_game.dart
- Mismas importaciones
- Mismos campos de timer
- Mismos métodos de gestión de tiempo
- Diálogos actualizados con GIFs y monedas
- `_onEmojiDrop()` verifica `_gameEnded` antes de permitir drop

---

## Flujo de Usuario

### Flujo de Victoria

```
1. Usuario completa el juego
   ↓
2. Se detecta victoria (_checkVictory() == true)
   ↓
3. Se marca _gameEnded = true
   ↓
4. Se cancela el timer
   ↓
5. Se oculta el GIF de "pensando"
   ↓
6. Se calcula monedas ganadas (basado en tiempo restante)
   ↓
7. Se muestra diálogo con:
   - GIF de "excelente.gif" (200x200)
   - Mensaje de felicitaciones
   - Cantidad de monedas 💰
   - Tiempo restante
   - Botones: "Salir" / "Jugar de Nuevo"
   ↓
8. Usuario elige:
   - "Salir" → Vuelve al selector de niveles
   - "Jugar de Nuevo" → Reinicia juego (_gameEnded = false, nuevo timer)
```

### Flujo de Timeout

```
1. Timer llega a 0 segundos
   ↓
2. Se marca _gameEnded = true
   ↓
3. Se cancela el timer
   ↓
4. Se oculta el GIF de "pensando"
   ↓
5. Se muestra diálogo con:
   - GIF de "intentalo.gif" (200x200)
   - Mensaje "¡Se acabó el tiempo!"
   - Progreso alcanzado (X de Y palabras/emojis)
   - Mensaje de ánimo "¡Inténtalo de nuevo! 💪"
   - Botones: "Salir" / "Reintentar"
   ↓
6. Usuario elige:
   - "Salir" → Vuelve al selector de niveles
   - "Reintentar" → Reinicia juego con tiempo completo
```

---

## Diseño de UI

### Header del Juego

**Componentes** (izquierda a derecha):
1. Botón de retroceso (⬅)
2. Título del juego
3. **Timer** (con colores dinámicos):
   - Icono de reloj ⏱
   - Tiempo en formato MM:SS
   - Fondo que cambia según urgencia
4. Contador de progreso (X/Y)

**Layout Responsive**:
- Desktop: Todos en una fila horizontal
- Móvil: Header se adapta, timer y progreso se mantienen visibles

### Diálogos Modales

**Estructura**:
```
┌─────────────────────────────────┐
│   [GIF de Avatar 200x200]       │
│                                  │
│   Título Grande (28px)           │
│   Mensaje Secundario (18px)      │
│                                  │
│  ┌─────────────────────────┐    │
│  │  💰  X Monedas          │    │
│  │  Tiempo: MM:SS          │    │
│  └─────────────────────────┘    │
│                                  │
│  [ Salir ]  [ Jugar de Nuevo ]  │
└─────────────────────────────────┘
```

**Colores**:
- **Victoria**: Gradiente Teal/Purple (según juego)
- **Timeout**: Gradiente Naranja
- **Botones**: Blanco con transparencia / Blanco sólido

### GIF de Pensando (Esquina)

**Diseño**:
```
┌───────────────────────┐
│                       │
│         [Juego]       │
│                       │
│                 ┌───┐ │
│                 │GIF│ │ ← 80x80 px
│                 └───┘ │
└───────────────────────┘
  16px desde borde
```

---

## Testing Recomendado

### Test 1: Timer Básico
1. Iniciar cualquier nivel
2. **Verificar**:
   - Timer inicia en tiempo correcto (90s, 120s, etc.)
   - Cuenta regresiva funciona (cada segundo)
   - Color cambia en 60s (naranja) y 30s (rojo)
   - GIF de "pensando" visible en esquina

### Test 2: Victoria Rápida (Máximas Monedas)
1. Completar juego rápidamente
2. **Verificar**:
   - Timer se detiene
   - GIF de "pensando" desaparece
   - Diálogo muestra GIF de "excelente"
   - Monedas cercanas a 50 (tiempo alto restante)
   - Tiempo restante correcto

### Test 3: Victoria Lenta (Mínimas Monedas)
1. Completar juego justo antes del timeout
2. **Verificar**:
   - Monedas cercanas a 10 (poco tiempo restante)
   - Fórmula correcta aplicada

### Test 4: Timeout
1. Dejar que el timer llegue a 00:00
2. **Verificar**:
   - Diálogo de timeout aparece
   - GIF de "intentalo" se muestra
   - Progreso correcto (X de Y)
   - No se otorgan monedas
   - Botón "Reintentar" funciona

### Test 5: Interacción Después de Terminar
1. Completar juego o timeout
2. Intentar interactuar (drag & drop / selección)
3. **Verificar**:
   - No se permite interacción (`_gameEnded` previene)
   - No aparecen diálogos duplicados

### Test 6: "Jugar de Nuevo"
1. Completar juego
2. Presionar "Jugar de Nuevo"
3. **Verificar**:
   - `_gameEnded` se resetea a false
   - Timer reinicia al tiempo completo
   - GIF de "pensando" reaparece
   - Juego totalmente funcional

---

## Fórmula de Monedas - Análisis

### Distribución de Recompensas

Para un límite de 120 segundos (2 minutos):

| Tiempo Restante | Porcentaje | Monedas | Categoría |
|-----------------|------------|---------|-----------|
| 120s (100%)     | 100%       | 50      | Excelente ⭐⭐⭐ |
| 96s (80%)       | 80%        | 42      | Muy Bien ⭐⭐ |
| 60s (50%)       | 50%        | 30      | Bien ⭐ |
| 30s (25%)       | 25%        | 20      | Regular |
| 10s (8%)        | 8%         | 13      | Completado |
| 0s              | 0%         | 10      | Mínimo |

### Ventajas de la Fórmula

1. **Lineal y Predecible**: Relación directa tiempo-monedas
2. **Incentivo Claro**: Más rápido = más recompensa
3. **Garantiza Mínimo**: Siempre 10 monedas por completar
4. **Techo Justo**: Máximo 50 monedas (alcanzable pero desafiante)
5. **Sin Penalización Extrema**: Incluso lento obtiene recompensa

---

## Próximas Mejoras Sugeridas

### 1. Integración con Firebase
```dart
// Guardar monedas y experiencia en Firestore
Future<void> _saveGameReward(int coins) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({
      'coins': FieldValue.increment(coins),
      'experience': FieldValue.increment(coins * 2), // 2 XP por moneda
    });
  }
}
```

### 2. Sonidos de Feedback
- Tick del timer en últimos 10 segundos
- Sonido de victoria con monedas
- Sonido de timeout

### 3. Animación de Monedas
- Contador animado que sube desde 0 hasta cantidad final
- Partículas de monedas cayendo
- Efecto de brillo

### 4. Tabla de Récords
- Guardar mejor tiempo por nivel
- Mostrar en selector de niveles
- Comparar con otros jugadores

### 5. Logros
- "Velocista": Completar en tiempo perfecto 5 veces
- "Coleccionista": Acumular 500 monedas de minijuegos
- "Imparable": Completar 10 juegos sin timeout

---

## Estado del Build

✅ **Flutter Analyze**: 0 errores, solo warnings pre-existentes
✅ **Compilación Web**: Exitosa
✅ **Integración GIF**: Completa
✅ **Timer**: Funcionando correctamente
✅ **Monedas**: Fórmula implementada

---

## Archivos Modificados

### Modelos
- [`lib/domain/models/word_search_model.dart`](lib/domain/models/word_search_model.dart) - Timer y coins
- [`lib/domain/models/emoji_sorting_model.dart`](lib/domain/models/emoji_sorting_model.dart) - Timer y coins

### Pantallas de Juego
- [`lib/presentation/screens/games/word_search_game.dart`](lib/presentation/screens/games/word_search_game.dart) - Sistema completo
- [`lib/presentation/screens/games/emoji_sorting_game.dart`](lib/presentation/screens/games/emoji_sorting_game.dart) - Sistema completo

### Widgets (Sin cambios, solo usados)
- [`lib/presentation/widgets/game_video_widget.dart`](lib/presentation/widgets/game_video_widget.dart) - GIFs de feedback

---

**Desarrollado por**: Claude Code
**Framework**: Flutter Web
**Fecha de Implementación**: 2025-12-07
**Versión**: 1.0.0

---

## Resumen Ejecutivo

Se implementó exitosamente un sistema de gamificación completo que incluye:

✅ **Timer dinámico** con feedback visual de urgencia
✅ **Sistema de monedas** basado en desempeño (10-50 monedas)
✅ **GIFs de avatar** en 3 estados (pensando, victoria, timeout)
✅ **Diálogos modales** con gradientes y diseño atractivo
✅ **Control de estado** para prevenir bugs de interacción
✅ **Responsive design** que funciona en desktop y móvil

El sistema está listo para integración con Firebase y expansión a más minijuegos de la plataforma APRENDE_KIDS.
