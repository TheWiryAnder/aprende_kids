# Juego de Clasificación de Emojis (Emoji Sorting Game)

## Fecha: 2025-12-07

---

## Descripción General

Juego educativo de **clasificación de emojis** donde los niños deben organizar emojis en columnas según su categoría correcta mediante **drag and drop** (arrastrar y soltar).

---

## Características Implementadas

### 1. Tres Niveles de Dificultad

#### Nivel Básico ⭐
- **2 categorías** diferentes
- **6 emojis totales** (3 por categoría)
- Ideal para niños de 4-6 años
- Ejemplo: Frutas 🍎 y Vehículos 🚗

#### Nivel Intermedio ⭐⭐
- **3 categorías** diferentes
- **9 emojis totales** (3 por categoría)
- Ideal para niños de 6-8 años
- Ejemplo: Frutas 🍎, Vehículos 🚗, Deportes ⚽

#### Nivel Avanzado ⭐⭐⭐
- **4 categorías** diferentes
- **12 emojis totales** (3 por categoría)
- Ideal para niños de 8-10 años
- Ejemplo: Frutas 🍎, Vehículos 🚗, Deportes ⚽, Animales 🦁

### 2. Base de Datos de Categorías

El juego incluye **8 categorías diferentes** con emojis variados:

1. **Frutas** 🍎
   - Emojis: 🍌, 🍇, 🍉, 🍊, 🍓, 🍒, 🥝, 🍑

2. **Vehículos** 🚗
   - Emojis: ✈️, 🛵, 🚁, 🚂, 🚢, 🚲, 🏍️, 🚜

3. **Deportes** ⚽
   - Emojis: 🏀, 🎾, 🏐, 🏈, ⚾, 🏓, 🏸, 🥊

4. **Animales** 🦁
   - Emojis: 🐶, 🐱, 🐭, 🐹, 🐰, 🦊, 🐻, 🐼

5. **Comida** 🍕
   - Emojis: 🍔, 🌭, 🥪, 🌮, 🍝, 🍜, 🍲, 🥗

6. **Naturaleza** 🌳
   - Emojis: 🌺, 🌻, 🌷, 🌹, 🌸, 🌼, 🌵, 🍃

7. **Clima** ☀️
   - Emojis: 🌧️, ⛈️, 🌩️, ❄️, ☁️, 🌈, ⭐, 🌙

8. **Instrumentos** 🎸
   - Emojis: 🎹, 🥁, 🎺, 🎻, 🪕, 🎷, 🪘, 🎤

### 3. Sistema de Drag and Drop

**Tecnología**: Flutter `Draggable` y `DragTarget`

**Flujo de interacción**:
1. Usuario toca/clickea un emoji del banco
2. Arrastra el emoji sobre una columna de categoría
3. Al soltar:
   - Si es **correcto**: ✅ Emoji se coloca en la columna
   - Si es **incorrecto**: ❌ Emoji vuelve al banco

**Características técnicas**:
- `Draggable<String>`: Widget que envuelve cada emoji
- `DragTarget<String>`: Widget que recibe el emoji
- `onWillAcceptWithDetails`: Valida si el emoji pertenece a la categoría
- `onAcceptWithDetails`: Ejecuta la lógica cuando se suelta correctamente
- `feedback`: Versión ampliada del emoji durante el arrastre
- `childWhenDragging`: Versión opaca que queda en el banco

### 4. UI y Diseño

#### Columnas de Categorías
Cada columna muestra:
- **Título**: `Emoji + Nombre` (ej: "🍎 Frutas")
- **Barra de progreso**: Indicador visual de completitud
- **Contador**: "2/3" (emojis colocados / total)
- **Área de drop**: Contenedor para emojis colocados
- **Feedback hover**: Borde verde cuando se arrastra sobre ella

#### Banco de Emojis
- Título: "Emojis para Clasificar" con ícono 🤚
- Layout: `Wrap` que se adapta al ancho
- Diseño responsive
- Emojis mezclados aleatoriamente
- Tamaño: 70x70 px

#### Paleta de Colores
- **Fondo**: Gradiente Teal (turquesa)
- **Columnas**: Blanco con sombras
- **Hover correcto**: Verde claro
- **Emojis colocados**: Teal claro
- **Feedback**: Verde (correcto), Naranja (incorrecto)

### 5. Sistema de Validación

```dart
bool isCorrectEmoji(String emoji) {
  return correctEmojis.contains(emoji);
}
```

**Validaciones**:
1. Verificar si emoji pertenece a categoría
2. Remover del banco si es correcto
3. Agregar a lista de emojis colocados
4. Mostrar feedback visual (SnackBar)
5. Verificar victoria (todas las categorías completas)

### 6. Feedback Visual

**Correcto** ✅:
- SnackBar verde: "¡Correcto! ✨"
- Emoji se coloca en la columna
- Contador se actualiza
- Barra de progreso avanza

**Incorrecto** ❌:
- SnackBar naranja: "Intenta de nuevo 🤔"
- Emoji vuelve al banco
- Sin penalización

**Victoria** 🎉:
- Diálogo modal: "¡Felicitaciones! 🎉"
- Mensaje: "¡Clasificaste todos los emojis correctamente!"
- Opciones: "Salir" o "Jugar de Nuevo"

### 7. Responsive Design

**Desktop (>600px)**:
- Columnas en fila horizontal
- Banco centrado debajo
- Layout espacioso

**Móvil (<600px)**:
- Columnas apiladas verticalmente
- Banco en scroll horizontal
- Diseño compacto

---

## Arquitectura del Código

### Modelos de Datos

**`emoji_sorting_model.dart`**:
```dart
class EmojiSortingModel {
  final EmojiSortingLevel level;
  final List<EmojiCategory> categories;
  final List<String> shuffledEmojis;
}

class EmojiCategory {
  final String name;
  final String emoji;
  final List<String> correctEmojis;
  final List<String> placedEmojis;

  bool isCorrectEmoji(String emoji);
  bool isComplete();
  double get progress;
}

enum EmojiSortingLevel {
  basico,    // 2 categorías, 6 emojis
  intermedio, // 3 categorías, 9 emojis
  avanzado,   // 4 categorías, 12 emojis
}
```

### Servicios

**`emoji_sorting_generator.dart`**:
```dart
class EmojiSortingGenerator {
  EmojiSortingModel generate(EmojiSortingLevel level) {
    // 1. Seleccionar categorías aleatorias
    // 2. Seleccionar emojis aleatorios de cada categoría
    // 3. Mezclar todos los emojis
    // 4. Retornar modelo completo
  }
}
```

### Pantallas

**`emoji_sorting_level_selector.dart`**:
- Selector de nivel con 3 tarjetas
- Navegación a la pantalla de juego
- Diseño atractivo con íconos y estrellas

**`emoji_sorting_game.dart`**:
- Pantalla principal del juego
- Sistema de drag and drop
- Gestión de estado local
- Validación y feedback

---

## Flujo de Navegación

```
HomeScreen
  → Click en "Clasifica y Gana" (tarjeta turquesa)
  → EmojiSortingLevelSelector
    → Seleccionar nivel (Básico/Intermedio/Avanzado)
    → EmojiSortingGame
      → Jugar
      → Victoria → Diálogo
        → "Jugar de Nuevo" → Nueva partida
        → "Salir" → Volver al selector
```

---

## Rutas Configuradas

| Ruta | Pantalla | Descripción |
|------|----------|-------------|
| `/emoji-sorting` | EmojiSortingLevelSelector | Selector de niveles |

---

## Archivos Creados

### Modelos
- [`lib/domain/models/emoji_sorting_model.dart`](lib/domain/models/emoji_sorting_model.dart)

### Servicios
- [`lib/domain/services/emoji_sorting_generator.dart`](lib/domain/services/emoji_sorting_generator.dart)

### Pantallas
- [`lib/presentation/screens/games/emoji_sorting_game.dart`](lib/presentation/screens/games/emoji_sorting_game.dart)
- [`lib/presentation/screens/games/emoji_sorting_level_selector.dart`](lib/presentation/screens/games/emoji_sorting_level_selector.dart)

### Modificados
- [`lib/app/routes.dart`](lib/app/routes.dart:213) - Agregada ruta `/emoji-sorting`
- [`lib/presentation/screens/home/home_screen.dart`](lib/presentation/screens/home/home_screen.dart:235) - Click funcional en tarjeta

---

## Cómo Jugar

### Para el Usuario
1. Desde el **HomeScreen**, hacer click en "Clasifica y Gana" (tarjeta turquesa)
2. Elegir nivel de dificultad:
   - ⭐ Básico: 2 categorías
   - ⭐⭐ Intermedio: 3 categorías
   - ⭐⭐⭐ Avanzado: 4 categorías
3. Observar las columnas de categorías en la parte superior
4. Ver los emojis mezclados en el banco inferior
5. **Arrastrar** cada emoji desde el banco hacia su columna correcta
6. Observar el feedback visual (verde=correcto, naranja=incorrecto)
7. Completar todas las categorías para ganar

### Ejemplo de Juego (Nivel Básico)

**Categorías mostradas**:
- 🍎 Frutas
- 🚗 Vehículos

**Banco mezclado**:
🍌 ✈️ 🍇 🛵 🍉 🚁

**Objetivo**:
- Arrastrar 🍌, 🍇, 🍉 → Columna "Frutas"
- Arrastrar ✈️, 🛵, 🚁 → Columna "Vehículos"

---

## Testing Recomendado

### Test 1: Drag and Drop Básico
1. Iniciar juego en nivel básico
2. Arrastrar un emoji correcto a su categoría
3. **Verificar**: Emoji se coloca, contador aumenta, SnackBar verde

### Test 2: Validación Incorrecta
1. Arrastrar un emoji a categoría incorrecta
2. **Verificar**: Emoji vuelve al banco, SnackBar naranja

### Test 3: Completar Juego
1. Clasificar todos los emojis correctamente
2. **Verificar**: Diálogo de victoria aparece

### Test 4: Responsive
1. Probar en desktop (>600px)
2. Probar en móvil (<600px)
3. **Verificar**: Layout se adapta correctamente

### Test 5: Diferentes Niveles
1. Probar nivel básico (2 categorías)
2. Probar nivel intermedio (3 categorías)
3. Probar nivel avanzado (4 categorías)
4. **Verificar**: Número correcto de categorías y emojis

---

## Estado del Build

✅ **Análisis exitoso**: `flutter analyze` - 0 errores
✅ **Build exitoso**: `flutter build web --release`
✅ **Listo para testing**: Implementación completa y funcional

---

## Funcionalidades Destacadas

✅ **Drag and Drop nativo de Flutter** - Sin librerías externas
✅ **8 categorías diferentes** - Gran variedad de contenido
✅ **Sistema de niveles progresivos** - De 2 a 4 categorías
✅ **Generación aleatoria** - Cada partida es diferente
✅ **Feedback inmediato** - Verde para correcto, naranja para incorrecto
✅ **Barra de progreso** - Indicador visual por categoría
✅ **Diseño responsive** - Funciona en desktop y móvil
✅ **Animaciones suaves** - Experiencia fluida
✅ **Sin penalizaciones** - Aprendizaje sin presión

---

## Próximas Mejoras Sugeridas

1. **Sonidos de feedback** al colocar correctamente
2. **Animaciones de celebración** al completar categorías
3. **Sistema de puntuación** basado en tiempo
4. **Más categorías** (países, profesiones, etc.)
5. **Modo multijugador** local
6. **Hints/pistas** visuales
7. **Estadísticas** de progreso

---

**Desarrollado por**: Claude Code
**Framework**: Flutter Web
**Fecha**: 2025-12-07
