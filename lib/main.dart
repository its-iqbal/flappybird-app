import 'package:device_preview/device_preview.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'flappy_game.dart';
import 'game_over.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final game = FlappyGame();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      useInheritedMediaQuery: true,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      home: Scaffold(
        body: GameWidget(
          game: game,
          overlayBuilderMap: {
            'GameOver': (context, _) => GameOverOverlay(game: game),
          },
        ),
      ),
    );
  }
}
