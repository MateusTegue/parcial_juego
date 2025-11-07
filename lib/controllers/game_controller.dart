// import 'dart:async';
// import 'package:flutter/material.dart';
// import '../models/snake.dart';
// import '../models/food.dart';
// import '../models/direction.dart';
// import '../utils/score_storage.dart'; // ⬅️ IMPORTAR

// class GameController extends ChangeNotifier {
//   static const int gridWidth = 20;
//   static const int gridHeight = 20;
//   static const int gameSpeed = 300;

//   Snake snake = Snake();
//   Food food = Food(gridWidth, gridHeight);
//   Timer? gameTimer;
//   bool isPlaying = false;
//   bool isGameOver = false;
//   int score = 0;
//   int highScore = 0; // ⬅️ NUEVO
//   bool isNewRecord = false; // ⬅️ NUEVO

//   // ⬅️ NUEVO: Constructor que carga el high score
//   GameController() {
//     _loadHighScore();
//   }

//   // ⬅️ NUEVO: Cargar puntaje más alto al iniciar
//   Future<void> _loadHighScore() async {
//     highScore = await ScoreStorage.getHighScore();
//     notifyListeners();
//   }

//   void startGame() {
//     snake = Snake();
//     food = Food(gridWidth, gridHeight);
//     score = 0;
//     isPlaying = true;
//     isGameOver = false;
//     isNewRecord = false; // ⬅️ NUEVO

//     gameTimer?.cancel();
//     gameTimer = Timer.periodic(Duration(milliseconds: gameSpeed), (timer) {
//       _gameLoop();
//     });
//     notifyListeners();
//   }

//   void _gameLoop() {
//     if (!isPlaying) return;

//     snake.move();

//     // Verificar si comió la comida
//     if (snake.body.first[0] == food.x && snake.body.first[1] == food.y) {
//       snake.grow();
//       food.generateNewPosition(gridWidth, gridHeight);
//       score += 10;

//       // ⬅️ NUEVO: Verificar si superó el récord durante el juego
//       if (score > highScore) {
//         highScore = score;
//         isNewRecord = true;
//       }
//     }

//     // Verificar colisiones
//     if (snake.checkCollisionWithWall(gridWidth, gridHeight) ||
//         snake.checkCollisionWithSelf()) {
//       gameOver();
//     }

//     notifyListeners();
//   }

//   void changeDirection(Direction direction) {
//     if (isPlaying && !isGameOver) {
//       snake.changeDirection(direction);
//     }
//   }

//   // ⬅️ MODIFICADO: Guardar puntaje al terminar
//   Future<void> gameOver() async {
//     isPlaying = false;
//     isGameOver = true;
//     gameTimer?.cancel();

//     // Guardar si es un nuevo récord
//     await ScoreStorage.saveHighScore(score);

//     // Recargar el high score por si acaso
//     highScore = await ScoreStorage.getHighScore();

//     notifyListeners();
//   }

//   void pauseGame() {
//     isPlaying = false;
//     gameTimer?.cancel();
//     notifyListeners();
//   }

//   void resumeGame() {
//     if (!isGameOver) {
//       isPlaying = true;
//       gameTimer = Timer.periodic(Duration(milliseconds: gameSpeed), (timer) {
//         _gameLoop();
//       });
//       notifyListeners();
//     }
//   }

//   @override
//   void dispose() {
//     gameTimer?.cancel();
//     super.dispose();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import '../models/snake.dart';
import '../models/food.dart';
import '../models/direction.dart';
import '../utils/score_storage.dart'; // ⬅️ NUEVO

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
  int highScore = 0; // ⬅️ NUEVO

  GameController() {
    _loadHighScore(); // ⬅️ NUEVO: Cargar high score al iniciar
  }

  // ⬅️ NUEVO: Cargar high score
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

      // ⬅️ NUEVO: Actualizar high score en tiempo real
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

  // ⬅️ ACTUALIZADO: Guardar puntaje al terminar
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

  // ⬅️ NUEVO: Obtener estadísticas
  Future<Map<String, int>> getStats() async {
    return await ScoreStorage.getGameStats();
  }

  // Agregar al GameController
  Future<void> testFirebase() async {
    print('🔍 Probando conexión con Firebase...');

    final isConnected = await ScoreStorage.testFirebaseConnection();
    if (isConnected) {
      print('✅ Firebase conectado correctamente');

      // Probar guardado
      await ScoreStorage.saveScoreToFirebase(999, 'TestPlayer');

      // Ver top scores
      final topScores = await ScoreStorage.getTopScoresFromFirebase(limit: 5);
      print('🏆 Top scores: $topScores');
    } else {
      print('❌ Firebase no está conectado');
    }
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }
}
