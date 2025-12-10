import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'flappy_game.dart';

class PipeManager extends Component with HasGameRef<FlappyGame> {
  final Random _random = Random();
  double _timeSinceLastPipe = 0;
  final double _spawnInterval = 1.5;

  @override
  void update(double dt) {
    super.update(dt);
    _timeSinceLastPipe += dt;

    if (_timeSinceLastPipe > _spawnInterval) {
      _spawnPipePair();
      _timeSinceLastPipe = 0;
    }
  }

  void reset() {

    gameRef.children.whereType<Pipe>().forEach((p) => p.removeFromParent());
    _timeSinceLastPipe = 0;
  }

  void _spawnPipePair() {
    const double pipeGap = 160; 
    final double pipeX = gameRef.size.x;

    final double groundHeight = 50;
    final double playAreaHeight = gameRef.size.y - groundHeight;

    final double maxTopHeight = playAreaHeight - pipeGap - 50; 
    final double pipeTopHeight = 50 + _random.nextDouble() * (maxTopHeight - 50);


    gameRef.add(Pipe(
      isTop: true,
      position: Vector2(pipeX, pipeTopHeight),
      height: pipeTopHeight + 50, 
    ));

    final double bottomPipeHeight = gameRef.size.y - (pipeTopHeight + pipeGap) + 50;
    
    gameRef.add(Pipe(
      isTop: false,
      position: Vector2(pipeX, pipeTopHeight + pipeGap),
      height: bottomPipeHeight,
    ));
  }
}

class Pipe extends SpriteComponent with HasGameRef<FlappyGame> {
  final bool isTop;
  final double speed = 200;
  bool passedBird = false;

  Pipe({required this.isTop, required Vector2 position, required double height}) 
      : super(position: position, size: Vector2(70, height)) {
        if (isTop) {
          anchor = Anchor.bottomLeft;
        } else {
          anchor = Anchor.topLeft;
        }
      }

  @override
  Future<void> onLoad() async {
    sprite = await gameRef.loadSprite(isTop ? 't-pipe.png' : 'b-pipe.png');

    add(RectangleHitbox.relative(
      Vector2(0.4, 0.95), 
      parentSize: size,
      position: Vector2(size.x * 0.3, 0), 
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    x -= speed * dt;

    if (!passedBird && x + width < gameRef.bird.x) {
      passedBird = true;
      if (isTop) gameRef.incrementScore(); 
    }

    if (x < -width) removeFromParent();
  }
}