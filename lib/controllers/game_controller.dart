import 'dart:async';
import 'package:flutter/material.dart';
import '../models/snake.dart';
import '../models/food.dart';
import '../models/direction.dart';
import '../utils/score_storage.dart';

class GameController extends ChangeNotifier {
  static const int gridWidth = 20;
  static const int gridHeight = 20;
  static const int gameSpeed = 300;

  Snake snake = Snake();
  Food food = Food(gridWidth, gridHeight);
  Timer? gameTimer;
  bool isPlaying = false;
  bool isGameOver = false;
  int score = 0;
  int highScore = 0;

  GameController() {
    _loadHighScore();
  }

  Future<void> _loadHighScore() async {
    highScore = await ScoreStorage.getHighScore();
    notifyListeners();
  }

  void startGame() {
    snake = Snake();
    food = Food(gridWidth, gridHeight);
    score = 0;
    isPlaying = true;
    isGameOver = false;

    gameTimer?.cancel();
    gameTimer = Timer.periodic(Duration(milliseconds: gameSpeed), (timer) {
      _gameLoop();
    });
    notifyListeners();
  }

  void _gameLoop() {
    if (!isPlaying) return;

    snake.move();

    // Verificar si comió la comida
    if (snake.body.first[0] == food.x && snake.body.first[1] == food.y) {
      snake.grow();
      food.generateNewPosition(gridWidth, gridHeight);
      score += 10;

      if (score > highScore) {
        highScore = score;
      }
    }

    // Verificar colisiones
    if (snake.checkCollisionWithWall(gridWidth, gridHeight) ||
        snake.checkCollisionWithSelf()) {
      gameOver();
    }

    notifyListeners();
  }

  void changeDirection(Direction direction) {
    if (isPlaying && !isGameOver) {
      snake.changeDirection(direction);
    }
  }

  Future<void> gameOver() async {
    isPlaying = false;
    isGameOver = true;
    gameTimer?.cancel();

    // Guardar estadísticas localmente
    await ScoreStorage.saveGameStats(score);

    // Guardar en Firebase (opcional, si el usuario está logueado)
    try {
      await ScoreStorage.saveScoreToFirebase(score, 'MateusTegue');
    } catch (e) {
      print('Error guardando en Firebase: $e');
    }

    // Recargar high score
    await _loadHighScore();

    notifyListeners();
  }

  void pauseGame() {
    isPlaying = false;
    gameTimer?.cancel();
    notifyListeners();
  }

  void resumeGame() {
    if (!isGameOver) {
      isPlaying = true;
      gameTimer = Timer.periodic(Duration(milliseconds: gameSpeed), (timer) {
        _gameLoop();
      });
      notifyListeners();
    }
  }

  Future<Map<String, int>> getStats() async {
    return await ScoreStorage.getGameStats();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }
}
