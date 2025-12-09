#!/usr/bin/env python3
"""
Script para agregar el sistema de video a todos los juegos de APRENDE_KIDS
"""

import os
import re

# Lista de todos los juegos que necesitan actualización
games_to_update = [
    'resta_magica_game.dart',
    'multiplicacion_espacial_game.dart',
    'division_detective_game.dart',
    'geometria_constructora_game.dart',
    'numeros_perdidos_game.dart',
    'completa_patron_game.dart',
    # Lenguaje
    'detectives_ortografia_game.dart',
    'rima_magica_game.dart',
    'sinonimos_antonimos_game.dart',
    'aventura_comprension_game.dart',
    'historias_locas_game.dart',
    'inventor_palabras_game.dart',
    # Ciencias
    'exploradores_cuerpo_game.dart',
    'sistema_solar_game.dart',
    'cadena_alimenticia_game.dart',
    'estados_materia_game.dart',
    'planeta_tierra_game.dart',
    'ecosistemas_mundo_game.dart',
    # Creatividad
    'disenador_monstruos_game.dart',
    'mezcla_colores_game.dart',
    'artista_emojis_game.dart',
    'asociacion_creativa_game.dart',
]

base_path = r'c:\Users\USUARIO\Documents\CLASES 2025-2\INTERACCION HUMANO COMPUTADOR\APRENDE_KIDS\APRENDE_KIDS\juegos_flutter\lib\presentation\screens\games'

def add_import(content):
    """Agregar import del GameVideoWidget si no existe"""
    if "import '../../widgets/game_video_widget.dart';" in content:
        return content

    # Buscar la última línea de import
    import_pattern = r"(import [^;]+;)\n"
    imports = list(re.finditer(import_pattern, content))

    if imports:
        last_import = imports[-1]
        insert_pos = last_import.end()
        content = content[:insert_pos] + "import '../../widgets/game_video_widget.dart';\n" + content[insert_pos:]

    return content

def add_video_type_method(content):
    """Agregar método _getCurrentVideoType si no existe"""
    if '_getCurrentVideoType()' in content:
        return content

    method_code = """
  GameVideoType _getCurrentVideoType() {
    if (_showFeedback) {
      return _isCorrect ? GameVideoType.excelente : GameVideoType.intentalo;
    }
    return GameVideoType.pensando;
  }
"""

    # Buscar el método build y agregar el método antes
    build_pattern = r'(\n  @override\n  Widget build\(BuildContext context\))'
    match = re.search(build_pattern, content)

    if match:
        insert_pos = match.start()
        content = content[:insert_pos] + method_code + content[insert_pos:]

    return content

def update_build_method(content):
    """Actualizar el método build para incluir el video"""

    # Verificar si ya tiene el video integrado
    if 'GameVideoWidget' in content and 'showVideo = screenWidth > 600' in content:
        print("  Ya tiene el video integrado")
        return content

    # Patrón para encontrar el inicio del método build
    build_start = r'@override\s+Widget build\(BuildContext context\)\s*{\s*return Scaffold\('

    if not re.search(build_start, content):
        print("  No se encontró el método build estándar")
        return content

    # Agregar las variables de screenWidth y showVideo al inicio del método build
    content = re.sub(
        r'(@override\s+Widget build\(BuildContext context\)\s*{)',
        r'\1\n    final screenWidth = MediaQuery.of(context).size.width;\n    final showVideo = screenWidth > 600; // Mostrar en tablet y desktop\n',
        content
    )

    # Encontrar y modificar la estructura Expanded que contiene el juego
    # Buscar el patrón: Expanded(child: Center(child: ConstrainedBox o Container
    expanded_pattern = r'(// Área de juego\s+Expanded\(\s+child:\s+Center\()'

    if re.search(expanded_pattern, content):
        # Reemplazar Expanded(child: Center( por Expanded(child: Row(
        content = re.sub(
            expanded_pattern,
            r'// Área de juego\n              Expanded(\n                child: Row(\n                  crossAxisAlignment: CrossAxisAlignment.start,\n                  children: [\n                    // Video en la izquierda (tablet y desktop)\n                    if (showVideo)\n                      Container(\n                        width: 450,\n                        padding: const EdgeInsets.all(20),\n                        child: Column(\n                          children: [\n                            Expanded(\n                              child: LayoutBuilder(\n                                builder: (context, constraints) {\n                                  return GameVideoWidget(\n                                    videoType: _getCurrentVideoType(),\n                                    width: 400,\n                                    height: constraints.maxHeight,\n                                  );\n                                },\n                              ),\n                            ),\n                          ],\n                        ),\n                      ),\n                    // Contenido del juego\n                    Expanded(\n                      child: Center(',
            content
        )

        # Cerrar el Row agregando un ] antes del cierre de Expanded
        # Buscar el patrón de cierre
        content = re.sub(
            r'(\),\s+\),\s+\),\s+\]\s*,\s+\),\s+\),\s+\),\s+\);)',
            r'),\n                  ),\n                ),\n              ],\n            ),\n          ),\n        ],\n      ),\n    );\n  }',
            content
        )

    return content

def process_game_file(filename):
    """Procesar un archivo de juego"""
    filepath = os.path.join(base_path, filename)

    if not os.path.exists(filepath):
        print(f"❌ No existe: {filename}")
        return False

    try:
        with open(filepath, 'r', encoding='utf-8') as f:
            content = f.read()

        original_content = content

        # Aplicar transformaciones
        content = add_import(content)
        content = add_video_type_method(content)
        content = update_build_method(content)

        # Solo escribir si hubo cambios
        if content != original_content:
            with open(filepath, 'w', encoding='utf-8') as f:
                f.write(content)
            print(f"✅ Actualizado: {filename}")
            return True
        else:
            print(f"⏭️  Sin cambios: {filename}")
            return False

    except Exception as e:
        print(f"❌ Error en {filename}: {e}")
        return False

if __name__ == '__main__':
    print("🎮 Actualizando juegos con sistema de video...\n")

    updated = 0
    skipped = 0
    errors = 0

    for game in games_to_update:
        result = process_game_file(game)
        if result:
            updated += 1
        elif result is False:
            errors += 1
        else:
            skipped += 1

    print(f"\n📊 Resumen:")
    print(f"  ✅ Actualizados: {updated}")
    print(f"  ⏭️  Sin cambios: {skipped}")
    print(f"  ❌ Errores: {errors}")
    print(f"  📁 Total: {len(games_to_update)}")
