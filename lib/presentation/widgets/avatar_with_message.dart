import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app/constants/avatar_mood.dart';
import '../../app/constants/motivational_messages.dart';
import '../bloc/user/user_bloc.dart';
import '../bloc/user/user_state.dart';
import 'avatar_asset.dart';
import 'avatar_message_bubble.dart';

/// Widget que muestra el avatar del usuario con un mensaje motivacional
class AvatarWithMessage extends StatefulWidget {
  final AvatarMood mood;
  final String? customMessage;
  final double avatarSize;
  final bool showMessage;
  final Duration messageDuration;
  final String? userName;

  const AvatarWithMessage({
    super.key,
    required this.mood,
    this.customMessage,
    this.avatarSize = 120,
    this.showMessage = true,
    this.messageDuration = const Duration(seconds: 4),
    this.userName,
  });

  @override
  State<AvatarWithMessage> createState() => _AvatarWithMessageState();
}

class _AvatarWithMessageState extends State<AvatarWithMessage> {
  bool _showBubble = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is! UserLoaded) {
          return const SizedBox.shrink();
        }

        final message = widget.customMessage ??
            MotivationalMessages.getMessage(
              widget.mood,
              userName: widget.userName,
            );

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Mensaje en burbuja
            if (widget.showMessage && _showBubble)
              AvatarMessageBubble(
                message: message,
                duration: widget.messageDuration,
                onDismiss: () {
                  if (mounted) {
                    setState(() {
                      _showBubble = false;
                    });
                  }
                },
                backgroundColor: _getBackgroundColor(),
                textColor: _getTextColor(),
              ),
            if (widget.showMessage && _showBubble) const SizedBox(height: 8),

            // Avatar del usuario
            SizedBox(
              width: widget.avatarSize,
              height: widget.avatarSize,
              child: AvatarAsset(
                userId: state.user.uid,
                size: widget.avatarSize,
                // Agregar animación según el mood
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: _getMoodColor().withValues(alpha: 0.3),
                      blurRadius: 15,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Obtiene el color de fondo de la burbuja según el mood
  Color _getBackgroundColor() {
    switch (widget.mood) {
      case AvatarMood.happy:
      case AvatarMood.celebration:
      case AvatarMood.victory:
        return const Color(0xFFFFF9C4); // Amarillo claro
      case AvatarMood.encouraging:
        return const Color(0xFFFFCDD2); // Rosa claro
      case AvatarMood.thinking:
        return const Color(0xFFE1F5FE); // Azul claro
      case AvatarMood.greeting:
        return const Color(0xFFC8E6C9); // Verde claro
      case AvatarMood.neutral:
      default:
        return Colors.white;
    }
  }

  /// Obtiene el color del texto según el mood
  Color _getTextColor() {
    switch (widget.mood) {
      case AvatarMood.happy:
      case AvatarMood.celebration:
      case AvatarMood.victory:
        return const Color(0xFFF57F17); // Amarillo oscuro
      case AvatarMood.encouraging:
        return const Color(0xFFC62828); // Rojo oscuro
      case AvatarMood.thinking:
        return const Color(0xFF01579B); // Azul oscuro
      case AvatarMood.greeting:
        return const Color(0xFF2E7D32); // Verde oscuro
      case AvatarMood.neutral:
      default:
        return const Color(0xFF424242); // Gris oscuro
    }
  }

  /// Obtiene el color de resplandor del avatar según el mood
  Color _getMoodColor() {
    switch (widget.mood) {
      case AvatarMood.happy:
        return Colors.yellow;
      case AvatarMood.celebration:
      case AvatarMood.victory:
        return Colors.amber;
      case AvatarMood.encouraging:
        return Colors.pink;
      case AvatarMood.thinking:
        return Colors.blue;
      case AvatarMood.greeting:
        return Colors.green;
      case AvatarMood.neutral:
      default:
        return Colors.grey;
    }
  }
}

/// Widget simplificado para mostrar solo el mensaje sin avatar
class MessageOnly extends StatelessWidget {
  final AvatarMood mood;
  final String? customMessage;
  final Duration duration;
  final String? userName;

  const MessageOnly({
    super.key,
    required this.mood,
    this.customMessage,
    this.duration = const Duration(seconds: 4),
    this.userName,
  });

  @override
  Widget build(BuildContext context) {
    final message = customMessage ??
        MotivationalMessages.getMessage(
          mood,
          userName: userName,
        );

    return AvatarMessageBubble(
      message: message,
      duration: duration,
    );
  }
}
