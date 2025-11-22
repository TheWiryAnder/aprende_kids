# Sistema de Avatar con Mensajes Motivacionales

## Descripción General

Sistema diseñado para mejorar la experiencia del usuario infantil mediante mensajes de ánimo y feedback visual contextual. El avatar del niño muestra diferentes estados emocionales y mensajes motivacionales según las acciones que realiza en la plataforma.

## Componentes Principales

### 1. **AvatarMood** (`lib/app/constants/avatar_mood.dart`)
Enum que define los diferentes estados emocionales del avatar:

- `neutral` - Estado por defecto
- `happy` - Cuando acierta respuestas
- `celebration` - Al completar niveles
- `thinking` - Durante el juego
- `encouraging` - Cuando falla (mensaje de ánimo)
- `greeting` - Al iniciar sesión
- `victory` - Al ganar/completar todo

### 2. **MotivationalMessages** (`lib/app/constants/motivational_messages.dart`)
Banco de mensajes organizados por contexto:

```dart
// Uso básico
final message = MotivationalMessages.getMessage(AvatarMood.happy);

// Con nombre personalizado
final message = MotivationalMessages.getMessage(
  AvatarMood.greeting,
  userName: 'Juan',
);
```

**Mensajes disponibles:**
- Bienvenida: 5 variantes
- Respuesta correcta: 10 variantes
- Respuesta incorrecta: 10 variantes de ánimo
- Nivel completado: 5 variantes
- Entre niveles: 5 variantes
- Victoria: 5 variantes
- Pensando: 5 variantes

### 3. **AvatarMessageBubble** (`lib/presentation/widgets/avatar_message_bubble.dart`)
Widget que muestra burbujas de diálogo estilo cómic:

```dart
AvatarMessageBubble(
  message: '¡Excelente trabajo!',
  duration: Duration(seconds: 4),
  backgroundColor: Colors.yellow[100],
  textColor: Colors.orange[900],
)
```

**Características:**
- Animación de entrada (escala + fade)
- Auto-desaparece después del tiempo especificado
- Diseño de burbuja con cola estilo cómic
- Bordes con sombra
- Personalizable (colores, duración)

### 4. **AvatarWithMessage** (`lib/presentation/widgets/avatar_with_message.dart`)
Componente principal que combina avatar + mensaje:

```dart
AvatarWithMessage(
  mood: AvatarMood.greeting,
  userName: 'María',
  avatarSize: 120,
  messageDuration: Duration(seconds: 5),
)
```

**Props:**
- `mood` (requerido) - Estado emocional
- `customMessage` - Mensaje personalizado (opcional)
- `avatarSize` - Tamaño del avatar (default: 120)
- `showMessage` - Mostrar/ocultar burbuja (default: true)
- `messageDuration` - Duración del mensaje (default: 4s)
- `userName` - Nombre para personalizar mensaje

**Efectos visuales según mood:**
- Colores de fondo de burbuja diferentes
- Colores de texto adaptativos
- Resplandor (glow) del avatar según estado emocional

## Integración en Pantallas

### HomeScreen (Bienvenida)

```dart
// En lib/presentation/screens/home/home_screen.dart
Center(
  child: AvatarWithMessage(
    mood: AvatarMood.greeting,
    userName: user.displayName,
    avatarSize: 100,
    messageDuration: const Duration(seconds: 5),
  ),
)
```

**Resultado:** Al entrar a la app, el avatar saluda al niño con mensajes como "¡Hola María! ¿Listo para aprender?"

### GameResultsScreen (Feedback de juegos)

```dart
// En lib/presentation/screens/games/game_results_screen.dart
AvatarWithMessage(
  mood: _getMoodForResult(),
  avatarSize: 120,
  messageDuration: const Duration(seconds: 6),
)

// Método helper
AvatarMood _getMoodForResult() {
  final stars = _calculateStars();
  if (stars >= 3) return AvatarMood.victory;      // "¡GANASTE! ¡Eres un campeón!"
  else if (stars >= 2) return AvatarMood.celebration; // "¡Excelente trabajo!"
  else if (stars >= 1) return AvatarMood.happy;       // "¡Muy bien!"
  else return AvatarMood.encouraging;                 // "¡Casi! Inténtalo de nuevo"
}
```

**Resultado:** Según el desempeño del niño (estrellas obtenidas), muestra mensajes apropiados.

## Cómo Usar en Nuevas Pantallas

### Ejemplo 1: Durante un juego

```dart
// Mostrar mensaje mientras el niño piensa
MessageOnly(
  mood: AvatarMood.thinking,
  duration: Duration(seconds: 3),
)
```

### Ejemplo 2: Al responder correctamente

```dart
// Trigger cuando acierta
setState(() {
  _showCorrectFeedback = true;
});

// En el build
if (_showCorrectFeedback)
  AvatarWithMessage(
    mood: AvatarMood.happy,
    customMessage: '¡Correcto! 2 + 2 = 4',
    messageDuration: Duration(seconds: 2),
  )
```

### Ejemplo 3: Al responder incorrectamente

```dart
AvatarWithMessage(
  mood: AvatarMood.encouraging,
  messageDuration: Duration(seconds: 3),
)
```

## Colores por Estado Emocional

| Mood | Color Fondo | Color Texto | Color Glow |
|------|-------------|-------------|------------|
| happy | Amarillo claro | Amarillo oscuro | Amarillo |
| celebration | Amarillo claro | Amarillo oscuro | Ámbar |
| victory | Amarillo claro | Amarillo oscuro | Ámbar |
| encouraging | Rosa claro | Rojo oscuro | Rosa |
| thinking | Azul claro | Azul oscuro | Azul |
| greeting | Verde claro | Verde oscuro | Verde |
| neutral | Blanco | Gris oscuro | Gris |

## Agregar Nuevos Mensajes

Para agregar mensajes nuevos, editar `lib/app/constants/motivational_messages.dart`:

```dart
static const List<String> _correctAnswerMessages = [
  '¡Excelente!',
  '¡Muy bien!',
  // Agregar aquí nuevos mensajes
  '¡Eres un genio!',
  '¡Perfecto!',
];
```

## Consideraciones de UX para Niños

1. **Mensajes cortos**: Máximo 10-12 palabras
2. **Lenguaje positivo**: Evitar palabras negativas como "error", "mal", "incorrecto"
3. **Variedad**: Mensajes aleatorios evitan repetición y monotonía
4. **Timing**:
   - Bienvenida: 5 segundos
   - Resultados: 6 segundos
   - Feedback rápido: 2-3 segundos
5. **Colores brillantes**: Llamativos pero no estridentes
6. **Animaciones suaves**: Entrada elástica, salida gradual

## Futuras Mejoras Posibles

- [ ] Agregar animaciones de expresiones faciales (boca/ojos)
- [ ] Sonidos cortos al mostrar mensajes
- [ ] Mensajes con íconos/emojis
- [ ] Personalización de mensajes por edad
- [ ] Sistema de logros con mensajes especiales
- [ ] Recordatorios amigables ("Llevas 30 minutos, descansa un poco")
