import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../app/constants/avatar_mood.dart';
import '../../app/constants/motivational_messages.dart';
import '../../domain/models/avatar_model.dart';
import '../../domain/services/avatar_service.dart';
import 'avatar_widget.dart';
import 'avatar_message_bubble.dart';

/// Widget overlay que muestra el avatar con mensaje superpuesto sobre todo el contenido
class AvatarMessageOverlay {
  static OverlayEntry? _currentOverlay;

  /// Muestra el overlay con avatar y mensaje
  static void show(
    BuildContext context, {
    required AvatarMood mood,
    String? customMessage,
    String? userName,
    Duration duration = const Duration(seconds: 2),
    double avatarSize = 140,
  }) {
    // Si ya hay un overlay, removerlo
    dismiss();

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final message = customMessage ??
        MotivationalMessages.getMessage(
          mood,
          userName: userName,
        );

    _currentOverlay = OverlayEntry(
      builder: (context) => _AvatarMessageOverlayWidget(
        message: message,
        mood: mood,
        userId: user.uid,
        duration: duration,
        avatarSize: avatarSize,
        onDismiss: dismiss,
      ),
    );

    Overlay.of(context).insert(_currentOverlay!);
  }

  /// Oculta el overlay actual
  static void dismiss() {
    _currentOverlay?.remove();
    _currentOverlay = null;
  }
}

class _AvatarMessageOverlayWidget extends StatefulWidget {
  final String message;
  final AvatarMood mood;
  final String userId;
  final Duration duration;
  final double avatarSize;
  final VoidCallback onDismiss;

  const _AvatarMessageOverlayWidget({
    required this.message,
    required this.mood,
    required this.userId,
    required this.duration,
    required this.avatarSize,
    required this.onDismiss,
  });

  @override
  State<_AvatarMessageOverlayWidget> createState() =>
      _AvatarMessageOverlayWidgetState();
}

class _AvatarMessageOverlayWidgetState
    extends State<_AvatarMessageOverlayWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Iniciar animación de entrada
    _controller.forward();

    // Auto-ocultar después del tiempo especificado
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.reverse().then((_) {
          widget.onDismiss();
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withValues(alpha: 0.3), // Fondo semi-transparente
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Center(
              child: StreamBuilder<AvatarModel?>(
                stream: AvatarService().avatarStream(widget.userId),
                builder: (context, snapshot) {
                  return Container(
                    constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.9,
                      maxHeight: MediaQuery.of(context).size.height * 0.6,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Burbuja de mensaje
                        AvatarMessageBubble(
                          message: widget.message,
                          duration: widget.duration,
                          backgroundColor: _getBackgroundColor(),
                          textColor: _getTextColor(),
                        ),
                        const SizedBox(height: 16),

                        // Avatar con resplandor
                        if (snapshot.hasData && snapshot.data != null)
                          _buildAvatar(snapshot.data!),
                        if (!snapshot.hasData || snapshot.data == null)
                          _buildPlaceholderAvatar(),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAvatar(AvatarModel avatar) {
    return Container(
      width: widget.avatarSize,
      height: widget.avatarSize + 50, // Aumentar altura para el avatar completo
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _getMoodColor().withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: AvatarWidget(
        avatar: avatar,
        size: widget.avatarSize,
        animate: true,
      ),
    );
  }

  Widget _buildPlaceholderAvatar() {
    return Container(
      width: widget.avatarSize,
      height: widget.avatarSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _getMoodColor().withValues(alpha: 0.2),
        boxShadow: [
          BoxShadow(
            color: _getMoodColor().withValues(alpha: 0.5),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Icon(
        _getMoodIcon(),
        size: widget.avatarSize * 0.5,
        color: _getMoodColor(),
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (widget.mood) {
      case AvatarMood.happy:
      case AvatarMood.celebration:
      case AvatarMood.victory:
        return const Color(0xFFFFF9C4);
      case AvatarMood.encouraging:
        return const Color(0xFFFFCDD2);
      case AvatarMood.thinking:
        return const Color(0xFFE1F5FE);
      case AvatarMood.greeting:
        return const Color(0xFFC8E6C9);
      case AvatarMood.neutral:
      default:
        return Colors.white;
    }
  }

  Color _getTextColor() {
    switch (widget.mood) {
      case AvatarMood.happy:
      case AvatarMood.celebration:
      case AvatarMood.victory:
        return const Color(0xFFF57F17);
      case AvatarMood.encouraging:
        return const Color(0xFFC62828);
      case AvatarMood.thinking:
        return const Color(0xFF01579B);
      case AvatarMood.greeting:
        return const Color(0xFF2E7D32);
      case AvatarMood.neutral:
      default:
        return const Color(0xFF424242);
    }
  }

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

  IconData _getMoodIcon() {
    switch (widget.mood) {
      case AvatarMood.happy:
      case AvatarMood.celebration:
        return Icons.sentiment_very_satisfied;
      case AvatarMood.victory:
        return Icons.emoji_events;
      case AvatarMood.encouraging:
        return Icons.sentiment_satisfied;
      case AvatarMood.thinking:
        return Icons.psychology;
      case AvatarMood.greeting:
        return Icons.waving_hand;
      case AvatarMood.neutral:
      default:
        return Icons.sentiment_neutral;
    }
  }
}
