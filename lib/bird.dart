import 'dart:math'; // ✅ ADDED THIS MISSING IMPORT
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/particles.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart';
import 'flappy_game.dart';
import 'pipe_manager.dart';

class Bird extends SpriteGroupComponent<BirdState> with HasGameRef<FlappyGame>, CollisionCallbacks {
  double velocity = 0;
  final double gravity = 900;
  final double jumpStrength = -350;

  Bird() : super(size: Vector2(50, 40), position: Vector2(100, 300));

  // lib/bird.dart

  @override
  Future<void> onLoad() async {
    final spriteMid = await gameRef.loadSprite('bird_mid.png');
    final spriteUp = await gameRef.loadSprite('bird_top.png'); 
    final spriteDown = await gameRef.loadSprite('bird_bottom.png');

    sprites = {
      BirdState.middle: spriteMid,
      BirdState.up: spriteUp,
      BirdState.down: spriteDown,
    };
    current = BirdState.middle;

    add(CircleHitbox(
      radius: 6, 
      position: Vector2(17, 12), 
    ));
  }

  void fly() {
    velocity = jumpStrength;
    current = BirdState.up;
    gameRef.add(
      ParticleSystemComponent(
        position: position + Vector2(10, size.y),
        particle: Particle.generate(
          count: 5,
          lifespan: 0.5,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 100),
            speed: Vector2.random(Random()) * 100 - Vector2(50, 0),
            child: CircleParticle(
              radius: 2,
              paint: Paint()..color = Colors.white.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }

  void reset() {
    position = Vector2(100, gameRef.size.y / 2);
    velocity = 0;
    angle = 0;
    current = BirdState.middle;
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    velocity += gravity * dt;
    y += velocity * dt;

    angle = (velocity / 500).clamp(-0.5, 0.5);

    if (velocity < -100) current = BirdState.up;
    else if (velocity > 100) current = BirdState.down;
    else current = BirdState.middle;

    if (y > gameRef.size.y - height || y < 0) {
      gameRef.gameOver();
    }
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Pipe) {
      gameRef.gameOver();
    }
  }
}

enum BirdState { up, middle, down }