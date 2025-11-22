import 'dart:math';
import 'avatar_mood.dart';

/// Clase que contiene mensajes motivacionales para diferentes contextos
class MotivationalMessages {
  static final _random = Random();

  /// Mensajes de bienvenida al iniciar sesión
  static const List<String> _greetingMessages = [
    '¡Hola! ¿Listo para aprender?',
    '¡Bienvenido de nuevo! ¿Comenzamos?',
    '¡Qué bueno verte! Hoy aprenderemos mucho',
    '¡Hola! Tengo juegos geniales para ti',
    '¡Bienvenido! ¿Qué quieres aprender hoy?',
  ];

  /// Mensajes cuando responde correctamente
  static const List<String> _correctAnswerMessages = [
    '¡Excelente!',
    '¡Muy bien!',
    '¡Eres increíble!',
    '¡Perfecto!',
    '¡Lo lograste!',
    '¡Genial!',
    '¡Súper!',
    '¡Fantástico!',
    '¡Correcto!',
    '¡Bien hecho!',
  ];

  /// Mensajes cuando responde incorrectamente
  static const List<String> _incorrectAnswerMessages = [
    '¡Casi! Inténtalo de nuevo',
    'No te rindas, ¡tú puedes!',
    'La práctica hace al maestro',
    '¡Sigue intentando!',
    'Cada error es una oportunidad de aprender',
    '¡No pasa nada! Vuelve a intentarlo',
    '¡Ánimo! Lo harás mejor la próxima',
    'Suerte para la próxima',
    '¡Casi lo tienes!',
    'Inténtalo otra vez, ¡sé que puedes!',
  ];

  /// Mensajes cuando completa un nivel
  static const List<String> _levelCompleteMessages = [
    '¡Felicidades! Pasaste al siguiente nivel',
    '¡Nivel completado! ¡Eres asombroso!',
    '¡Lo lograste! Siguiente nivel desbloqueado',
    '¡Increíble! Ya dominaste este nivel',
    '¡Excelente trabajo! Avancemos al siguiente',
  ];

  /// Mensajes de ánimo entre niveles
  static const List<String> _betweenLevelsMessages = [
    '¡Vas muy bien! ¿Continuamos?',
    '¡Estás aprendiendo mucho! ¿Seguimos?',
    '¡Qué bien lo estás haciendo! ¿Listo para más?',
    '¡Eres genial! ¿Probamos el siguiente?',
    '¡Sigue así! ¿Jugamos otro?',
  ];

  /// Mensajes de victoria (cuando completa todos los niveles)
  static const List<String> _victoryMessages = [
    '¡GANASTE! ¡Eres un campeón!',
    '¡VICTORIA! ¡Lo completaste todo!',
    '¡INCREÍBLE! ¡Terminaste el juego!',
    '¡FELICIDADES! ¡Eres un maestro!',
    '¡WOW! ¡Qué inteligente eres!',
  ];

  /// Mensajes mientras piensa/está en el juego
  static const List<String> _thinkingMessages = [
    '¡Tómate tu tiempo!',
    '¡Piensa bien!',
    'Puedes hacerlo...',
    '¡Concéntrate!',
    '¿Cuál será la respuesta?',
  ];

  /// Mensajes neutrales/generales
  static const List<String> _neutralMessages = [
    '¡Estoy aquí para ayudarte!',
    '¿En qué te puedo ayudar?',
    '¡Aprender es divertido!',
    '¡Vamos a jugar!',
  ];

  /// Obtiene un mensaje aleatorio según el estado de ánimo
  static String getMessage(AvatarMood mood, {String? userName}) {
    List<String> messages;

    switch (mood) {
      case AvatarMood.greeting:
        messages = _greetingMessages;
        break;
      case AvatarMood.happy:
        messages = _correctAnswerMessages;
        break;
      case AvatarMood.encouraging:
        messages = _incorrectAnswerMessages;
        break;
      case AvatarMood.celebration:
        messages = _levelCompleteMessages;
        break;
      case AvatarMood.thinking:
        messages = _thinkingMessages;
        break;
      case AvatarMood.victory:
        messages = _victoryMessages;
        break;
      case AvatarMood.neutral:
      default:
        messages = _neutralMessages;
        break;
    }

    String message = messages[_random.nextInt(messages.length)];

    // Si se proporciona el nombre del usuario, personalizar el mensaje
    if (userName != null && mood == AvatarMood.greeting) {
      message = message.replaceFirst('¡Hola!', '¡Hola $userName!');
    }

    return message;
  }

  /// Obtiene un mensaje específico (útil para testing o contextos específicos)
  static String getSpecificMessage(AvatarMood mood, int index) {
    List<String> messages;

    switch (mood) {
      case AvatarMood.greeting:
        messages = _greetingMessages;
        break;
      case AvatarMood.happy:
        messages = _correctAnswerMessages;
        break;
      case AvatarMood.encouraging:
        messages = _incorrectAnswerMessages;
        break;
      case AvatarMood.celebration:
        messages = _levelCompleteMessages;
        break;
      case AvatarMood.thinking:
        messages = _thinkingMessages;
        break;
      case AvatarMood.victory:
        messages = _victoryMessages;
        break;
      case AvatarMood.neutral:
      default:
        messages = _neutralMessages;
        break;
    }

    return messages[index % messages.length];
  }
}
