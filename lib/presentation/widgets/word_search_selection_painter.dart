import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Clase para almacenar una línea de selección encontrada
class SelectionLine {
  final Offset startOffset;
  final Offset endOffset;
  final Color color;

  SelectionLine({
    required this.startOffset,
    required this.endOffset,
    required this.color,
  });
}

/// CustomPainter que dibuja las líneas de selección tipo "capsule" fluida
class WordSearchSelectionPainter extends CustomPainter {
  final List<SelectionLine> foundWords; // Palabras encontradas (persistentes)
  final Offset? startOffset; // Selección actual (temporal)
  final Offset? currentOffset; // Selección actual (temporal)
  final Color selectionColor;
  final double strokeWidth;

  WordSearchSelectionPainter({
    required this.foundWords,
    required this.startOffset,
    required this.currentOffset,
    this.selectionColor = Colors.blue,
    this.strokeWidth = 40.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Dibujar TODAS las palabras encontradas (persistentes) en VERDE
    for (final line in foundWords) {
      final paint = Paint()
        ..color = line.color.withValues(alpha: 0.5)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(line.startOffset, line.endOffset, paint);
    }

    // 2. Dibujar la selección ACTUAL (temporal) en AZUL (si existe)
    if (startOffset != null && currentOffset != null) {
      final paint = Paint()
        ..color = selectionColor.withValues(alpha: 0.4)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      canvas.drawLine(startOffset!, currentOffset!, paint);
    }
  }

  @override
  bool shouldRepaint(covariant WordSearchSelectionPainter oldDelegate) {
    return oldDelegate.startOffset != startOffset ||
        oldDelegate.currentOffset != currentOffset ||
        oldDelegate.foundWords.length != foundWords.length;
  }
}

/// Clase auxiliar para calcular la dirección snapped
class SelectionHelper {
  /// Snap a 8 direcciones: horizontal, vertical, y diagonales (0°, 45°, 90°, 135°, 180°, 225°, 270°, 315°)
  static Offset snapToDirection(Offset start, Offset current) {
    final dx = current.dx - start.dx;
    final dy = current.dy - start.dy;

    if (dx == 0 && dy == 0) return start;

    // Calcular ángulo en radianes
    final angle = math.atan2(dy, dx);

    // Calcular distancia
    final distance = math.sqrt(dx * dx + dy * dy);

    // Snap a ángulos de 45 grados (8 direcciones)
    final snappedAngle = (angle / (math.pi / 4)).round() * (math.pi / 4);

    // Calcular nuevo punto final basado en el ángulo snapped
    final snappedDx = math.cos(snappedAngle) * distance;
    final snappedDy = math.sin(snappedAngle) * distance;

    return Offset(start.dx + snappedDx, start.dy + snappedDy);
  }

  /// Calcula qué celdas intersecta la línea desde start hasta end
  static List<Point> getCellsInLine(
    Offset start,
    Offset end,
    double cellSize,
    int gridSize,
  ) {
    final cells = <Point>[];

    // Convertir offsets a coordenadas de grilla
    final startRow = (start.dy / cellSize).floor().clamp(0, gridSize - 1);
    final startCol = (start.dx / cellSize).floor().clamp(0, gridSize - 1);
    final endRow = (end.dy / cellSize).floor().clamp(0, gridSize - 1);
    final endCol = (end.dx / cellSize).floor().clamp(0, gridSize - 1);

    // Algoritmo de Bresenham para línea recta
    int x = startCol;
    int y = startRow;
    final dx = (endCol - startCol).abs();
    final dy = (endRow - startRow).abs();
    final sx = startCol < endCol ? 1 : -1;
    final sy = startRow < endRow ? 1 : -1;
    var err = dx - dy;

    while (true) {
      // Agregar celda actual
      if (x >= 0 && x < gridSize && y >= 0 && y < gridSize) {
        cells.add(Point(x, y));
      }

      // Verificar si llegamos al final
      if (x == endCol && y == endRow) break;

      final e2 = 2 * err;
      if (e2 > -dy) {
        err -= dy;
        x += sx;
      }
      if (e2 < dx) {
        err += dx;
        y += sy;
      }
    }

    return cells;
  }
}

/// Clase simple para representar un punto en la grilla
class Point {
  final int x;
  final int y;

  Point(this.x, this.y);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Point && runtimeType == other.runtimeType && x == other.x && y == other.y;

  @override
  int get hashCode => x.hashCode ^ y.hashCode;
}
