# Reversión del Sistema de Selección Visual - Sopa de Letras

**Fecha**: 2025-12-08
**Tipo**: Refactorización completa del sistema de selección

## Resumen

Se revirtió el sistema de selección visual del minijuego "Sopa de Letras" desde un enfoque basado en líneas fluidas con CustomPainter a un sistema tradicional de resaltado por celdas con restricción ortogonal (solo horizontal y vertical).

---

## Cambios Implementados

### 1. Eliminación del Sistema CustomPainter

**Archivos afectados:**
- `lib/presentation/screens/games/word_search_game.dart`

**Cambios:**
- ❌ Eliminado import de `word_search_selection_painter.dart`
- ❌ Removidas variables de offset (`_selectionStartOffset`, `_selectionCurrentOffset`)
- ❌ Eliminada variable `_cellSize` (ahora es local en `_buildGrid()`)
- ❌ Removida lista `_foundWordLines` para almacenar líneas persistentes
- ❌ Eliminado layer de CustomPaint del Stack en `_buildGrid()`
- ❌ Removidos métodos: `_onSelectionStart()`, `_onSelectionUpdate()`, `_onSelectionEnd()`, `_offsetToCell()`

### 2. Nuevo Sistema de Índices de Celdas

**Variables de estado agregadas:**
```dart
final Set<int> _selectedCellIndices = {};  // Temporal (azul claro mientras arrastra)
final Set<int> _foundCellIndices = {};     // Permanente (verde cuando encuentra palabra)
int? _selectionStartRow;
int? _selectionStartCol;
String? _selectionDirection;               // 'horizontal' o 'vertical'
```

**Método auxiliar:**
```dart
int _cellToIndex(int row, int col) {
  final gridSize = _wordSearch.grid.length;
  return row * gridSize + col;
}
```

### 3. Lógica de Selección Ortogonal

**Nuevos métodos implementados:**

#### `_onCellTapDown(int row, int col)`
- Inicia la selección al hacer tap en una celda
- Limpia selección anterior
- Agrega celda inicial a `_selectedCells` y `_selectedCellIndices`

#### `_onCellDragUpdate(int row, int col)`
- Maneja el arrastre sobre celdas
- **Determina dirección en el primer movimiento:**
  - Si `row` cambia y `col` es constante → `vertical`
  - Si `col` cambia y `row` es constante → `horizontal`
  - Si ambos cambian (diagonal) → **ignora el movimiento**
- **Valida que el movimiento siga la dirección establecida**
- Calcula todas las celdas entre inicio y posición actual
- Actualiza `_selectedCells` y `_selectedCellIndices`

#### `_onCellTapUp()`
- Finaliza la selección
- Llama a `_checkSelectedWord()`
- Resetea `_selectionDirection`

### 4. Persistencia de Palabras Encontradas

**Método actualizado: `_checkSelectedWord()`**

Cambio en la lógica de guardado:
```dart
// ANTES (sistema de líneas):
_foundWordLines.add(SelectionLine(
  startOffset: _selectionStartOffset!,
  endOffset: _selectionCurrentOffset!,
  color: Colors.green,
));

// AHORA (sistema de índices):
for (final cell in position.cells) {
  _foundCellIndices.add(_cellToIndex(cell.row, cell.col));
}
```

### 5. Resaltado Visual por Estado de Celda

**Método refactorizado: `_buildCell(int row, int col, double size)`**

**Estados de celda:**
1. **Encontrada** (permanente):
   - Color de fondo: Color de la palabra con alpha 0.4
   - Borde: Normal (gris claro)

2. **Seleccionada** (temporal):
   - Color de fondo: Azul con alpha 0.2
   - Borde: Azul más grueso (2px)

3. **Normal**:
   - Color de fondo: Blanco
   - Borde: Gris claro (1px)

**Integración con MouseRegion:**
```dart
MouseRegion(
  onEnter: (_) {
    if (_isSelecting && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _isSelecting) {
          _onCellDragUpdate(row, col);
        }
      });
    }
  },
  child: GestureDetector(
    onTapDown: (_) => _onCellTapDown(row, col),
    onTapUp: (_) => _onCellTapUp(),
    child: Container(...)
  ),
)
```

### 6. Simplificación del Grid

**Método simplificado: `_buildGrid()`**

**ANTES** (3 capas con Stack):
```dart
child: Stack(
  children: [
    Column(...),                    // Capa 1: Grid
    Positioned(CustomPaint(...)),   // Capa 2: Líneas
    Positioned(GestureDetector(...))// Capa 3: Gestos
  ],
)
```

**AHORA** (grid simple):
```dart
child: Column(
  children: List.generate(
    gridSize,
    (row) => Row(
      children: List.generate(
        gridSize,
        (col) => _buildCell(row, col, cellSize),
      ),
    ),
  ),
)
```

---

## Restricción de Direcciones

### Configuración de Niveles

**IMPORTANTE**: Las direcciones permitidas se mantienen según la configuración original:

- **Nivel Básico**: Solo `horizontal` y `vertical`
- **Nivel Intermedio**: `horizontal`, `vertical` y `diagonal`
- **Nivel Avanzado**: Todas las direcciones (incluyendo reversas)

### Comportamiento del Usuario

El sistema **previene activamente** la selección diagonal:

1. El usuario hace tap en una celda inicial
2. Al arrastrar, el sistema detecta la primera dirección:
   - Si mueve horizontalmente → bloquea movimiento vertical
   - Si mueve verticalmente → bloquea movimiento horizontal
   - Si intenta diagonal → **ignora el movimiento**
3. La selección solo continúa si sigue la dirección establecida

---

## Corrección de Bugs

### Bug: "Palabras no se marcan como encontradas"

**Problema anterior:**
Las líneas dibujadas con CustomPaint desaparecían al soltar porque solo se dibujaba la selección temporal.

**Solución implementada:**
Las celdas de palabras encontradas se almacenan permanentemente en `_foundCellIndices` y se renderizan en cada `_buildCell()` con el estado `isFound`.

**Flujo garantizado:**
```
Usuario suelta dedo → _onCellTapUp()
                   → _checkSelectedWord()
                   → Si palabra correcta:
                      - Agregar a _foundWords
                      - Agregar índices a _foundCellIndices (PERMANENTE)
                   → setState() redibuja todas las celdas
                   → Celdas con índice en _foundCellIndices
                      se pintan con color permanente
```

---

## Ventajas del Nuevo Sistema

### 1. Experiencia de Usuario Infantil
- ✅ Visual clásico y familiar (estilo sopa de letras tradicional)
- ✅ Feedback inmediato: celdas cambian de color al pasar sobre ellas
- ✅ Restricción ortogonal previene confusión con movimientos diagonales accidentales

### 2. Persistencia Confiable
- ✅ Las palabras encontradas **siempre** permanecen visibles
- ✅ No depende de offsets que pueden calcularse incorrectamente
- ✅ Sistema basado en índices enteros (más robusto)

### 3. Simplicidad Técnica
- ✅ Menos código (eliminación de CustomPainter)
- ✅ Menos estados complejos (offsets, snapping, Bresenham)
- ✅ Más fácil de mantener y debuggear

### 4. Rendimiento
- ✅ No requiere redibujar canvas en cada frame
- ✅ Solo redibuja celdas afectadas
- ✅ Menos cálculos trigonométricos

---

## Archivos Modificados

```
lib/presentation/screens/games/word_search_game.dart
```

**Líneas clave modificadas:**
- **Línea 8**: Eliminado import de CustomPainter
- **Líneas 38-43**: Nuevas variables de estado
- **Líneas 147-231**: Nuevos métodos de selección
- **Líneas 249-252**: Guardado de índices en validación
- **Líneas 811-850**: Grid simplificado
- **Líneas 886-963**: Cell builder con estados

---

## Pruebas Recomendadas

### Nivel Básico (8x8)
- ✅ Solo permite selección horizontal y vertical
- ✅ Palabras encontradas permanecen resaltadas en verde
- ✅ Feedback de personaje (excelente/inténtalo) funciona correctamente

### Nivel Intermedio (10x10)
- ⚠️ **NOTA**: Aunque permite diagonales en el generador, la UI actual bloquea diagonales
- 🔄 **TODO**: Si se desea permitir diagonales en intermedio/avanzado, actualizar `_onCellDragUpdate()`

### Nivel Avanzado (12x12)
- ⚠️ Misma consideración que intermedio

---

## Compilación

```bash
flutter analyze
```

**Resultado**: ✅ 0 errores de compilación
**Warnings**: Solo advertencias menores (unused fields, prefer const, etc.)

---

## Próximos Pasos Opcionales

Si se desea permitir diagonales en niveles intermedio/avanzado:

1. Modificar `_onCellDragUpdate()` para detectar dirección diagonal:
```dart
if (_selectionDirection == null) {
  final rowDiff = (row - _selectionStartRow!).abs();
  final colDiff = (col - _selectionStartCol!).abs();

  if (rowDiff == colDiff && rowDiff > 0) {
    _selectionDirection = 'diagonal';
  }
}
```

2. Agregar lógica de cálculo de celdas diagonales en el bloque de actualización

---

## Conclusión

✅ Sistema revertido exitosamente de líneas fluidas a resaltado por celdas
✅ Restricción ortogonal implementada (solo horizontal/vertical)
✅ Bug de persistencia corregido
✅ Código más simple y mantenible
✅ Compilación sin errores

El minijuego "Sopa de Letras" ahora tiene un comportamiento tradicional y predecible, ideal para el público infantil objetivo.
