import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame/parallax.dart'; 
import 'package:flame_audio/flame_audio.dart'; 
import 'package:flutter/material.dart';
import 'bird.dart';
import 'pipe_manager.dart';

class FlappyGame extends FlameGame with TapCallbacks, HasCollisionDetection {
  late Bird bird;
  late TextComponent scoreText;
  late PipeManager pipeManager;
  late ParallaxComponent background;

  double score = 0;
  bool isGameOver = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    background = await loadParallaxComponent(
      [
        ParallaxImageData('bg.jpg'), 
        ParallaxImageData('bg.jpg'),
        ParallaxImageData('bg.jpg'),
      ],
      baseVelocity: Vector2(10, 0),
      velocityMultiplierDelta: Vector2(1.5, 0),
    );
    add(background);

    pipeManager = PipeManager();
    add(pipeManager);

    bird = Bird();
    add(bird);

    scoreText = TextComponent(
      text: '0',
      position: Vector2(size.x / 2, 60),
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 60,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: [
            Shadow(offset: Offset(3, 3), blurRadius: 0, color: Colors.black26),
            Shadow(offset: Offset(0, 0), blurRadius: 15, color: Colors.blueAccent),
          ],
        ),
      ),
    );
    add(scoreText);
  }

  @override
  void onTapDown(TapDownEvent event) {
    if (isGameOver) return;
    bird.fly();
  }

  void incrementScore() {
    score += 1;
    scoreText.text = score.floor().toString();
  }

  void gameOver() {
    if (isGameOver) return;
    isGameOver = true;
    pauseEngine();
    overlays.add('GameOver');
  }

  void resetGame() {
    score = 0;
    scoreText.text = '0';
    isGameOver = false;
    
    bird.reset();
    pipeManager.reset();
    
    overlays.remove('GameOver');
    resumeEngine();
  }
}