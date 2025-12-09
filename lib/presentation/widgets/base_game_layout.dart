import 'package:flutter/material.dart';
import 'game_video_widget.dart';

/// Layout base para todos los minijuegos con video de feedback
class BaseGameLayout extends StatelessWidget {
  final Widget gameContent;
  final Widget header;
  final GameVideoType currentVideoType;
  final Gradient? backgroundGradient;

  const BaseGameLayout({
    super.key,
    required this.gameContent,
    required this.header,
    required this.currentVideoType,
    this.backgroundGradient,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final showVideo = screenWidth > 600; // Mostrar en tablet y desktop

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient ??
              const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF667eea),
                  Color(0xFF764ba2),
                ],
              ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              header,
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Video en la izquierda (tablet y desktop)
                    if (showVideo)
                      Container(
                        width: 450,
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Expanded(
                              child: LayoutBuilder(
                                builder: (context, constraints) {
                                  return GameVideoWidget(
                                    videoType: currentVideoType,
                                    width: 400,
                                    height: constraints.maxHeight,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Contenido del juego
                    Expanded(
                      child: Center(
                        child: gameContent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
