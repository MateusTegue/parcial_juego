// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:firebase_firestore/firebase_firestore.dart'; // Uncomment if using Firebase

// class ScoreStorage {
//   static const String _highScoreKey = 'high_score';
//   static const String _gamesPlayedKey = 'games_played';
//   static const String _totalScoreKey = 'total_score';

//   // Guardar puntaje más alto
//   static Future<void> saveHighScore(int score) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final currentHighScore = await getHighScore();

//       // Solo guardar si el nuevo puntaje es mayor
//       if (score > currentHighScore) {
//         await prefs.setInt(_highScoreKey, score);
//       }
//     } catch (e) {
//       print('Error saving high score: $e');
//     }
//   }

//   // Obtener puntaje más alto
//   static Future<int> getHighScore() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       return prefs.getInt(_highScoreKey) ?? 0;
//     } catch (e) {
//       print('Error getting high score: $e');
//       return 0;
//     }
//   }

//   // ⬅️ NUEVO: Guardar estadísticas del juego
//   static Future<void> saveGameStats(int score) async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       // Incrementar juegos jugados
//       int gamesPlayed = prefs.getInt(_gamesPlayedKey) ?? 0;
//       await prefs.setInt(_gamesPlayedKey, gamesPlayed + 1);

//       // Actualizar puntaje total acumulado
//       int totalScore = prefs.getInt(_totalScoreKey) ?? 0;
//       await prefs.setInt(_totalScoreKey, totalScore + score);

//       // Actualizar high score
//       await saveHighScore(score);
//     } catch (e) {
//       print('Error saving game stats: $e');
//     }
//   }

//   // ⬅️ NUEVO: Obtener estadísticas del juego
//   static Future<Map<String, int>> getGameStats() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();

//       final gamesPlayed = prefs.getInt(_gamesPlayedKey) ?? 0;
//       final totalScore = prefs.getInt(_totalScoreKey) ?? 0;
//       final highScore = await getHighScore();
//       final averageScore = gamesPlayed > 0
//           ? (totalScore / gamesPlayed).round()
//           : 0;

//       return {
//         'gamesPlayed': gamesPlayed,
//         'totalScore': totalScore,
//         'highScore': highScore,
//         'averageScore': averageScore,
//       };
//     } catch (e) {
//       print('Error getting game stats: $e');
//       return {
//         'gamesPlayed': 0,
//         'totalScore': 0,
//         'highScore': 0,
//         'averageScore': 0,
//       };
//     }
//   }

//   // ⬅️ NUEVO: Guardar puntaje en Firebase (opcional)
//   static Future<void> saveScoreToFirebase(int score, String playerName) async {
//     try {
//       // Uncomment and implement if using Firebase Firestore
//       /*
//       final firestore = FirebaseFirestore.instance;
//       await firestore.collection('scores').add({
//         'playerName': playerName,
//         'score': score,
//         'timestamp': FieldValue.serverTimestamp(),
//       });
//       */

//       // For now, just print (remove this when implementing Firebase)
//       print('Score saved to Firebase: $score for player $playerName');
//     } catch (e) {
//       print('Error saving to Firebase: $e');
//       rethrow; // Re-throw so GameController can handle it
//     }
//   }

//   // Resetear puntaje (útil para testing)
//   static Future<void> resetHighScore() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_highScoreKey);
//     } catch (e) {
//       print('Error resetting high score: $e');
//     }
//   }

//   // ⬅️ NUEVO: Resetear todas las estadísticas
//   static Future<void> resetAllStats() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       await prefs.remove(_highScoreKey);
//       await prefs.remove(_gamesPlayedKey);
//       await prefs.remove(_totalScoreKey);
//     } catch (e) {
//       print('Error resetting all stats: $e');
//     }
//   }

//   // Verificar si es un nuevo récord
//   static Future<bool> isNewHighScore(int score) async {
//     final currentHighScore = await getHighScore();
//     return score > currentHighScore;
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // ✅ Descomenta esta línea

class ScoreStorage {
  static const String _highScoreKey = 'high_score';
  static const String _gamesPlayedKey = 'games_played';
  static const String _totalScoreKey = 'total_score';

  // Guardar puntaje más alto
  static Future<void> saveHighScore(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentHighScore = await getHighScore();

      // Solo guardar si el nuevo puntaje es mayor
      if (score > currentHighScore) {
        await prefs.setInt(_highScoreKey, score);
      }
    } catch (e) {
      print('Error saving high score: $e');
    }
  }

  // Obtener puntaje más alto
  static Future<int> getHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_highScoreKey) ?? 0;
    } catch (e) {
      print('Error getting high score: $e');
      return 0;
    }
  }

  // Guardar estadísticas del juego
  static Future<void> saveGameStats(int score) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Incrementar juegos jugados
      int gamesPlayed = prefs.getInt(_gamesPlayedKey) ?? 0;
      await prefs.setInt(_gamesPlayedKey, gamesPlayed + 1);

      // Actualizar puntaje total acumulado
      int totalScore = prefs.getInt(_totalScoreKey) ?? 0;
      await prefs.setInt(_totalScoreKey, totalScore + score);

      // Actualizar high score
      await saveHighScore(score);
    } catch (e) {
      print('Error saving game stats: $e');
    }
  }

  // Obtener estadísticas del juego
  static Future<Map<String, int>> getGameStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final gamesPlayed = prefs.getInt(_gamesPlayedKey) ?? 0;
      final totalScore = prefs.getInt(_totalScoreKey) ?? 0;
      final highScore = await getHighScore();
      final averageScore = gamesPlayed > 0
          ? (totalScore / gamesPlayed).round()
          : 0;

      return {
        'gamesPlayed': gamesPlayed,
        'totalScore': totalScore,
        'highScore': highScore,
        'averageScore': averageScore,
      };
    } catch (e) {
      print('Error getting game stats: $e');
      return {
        'gamesPlayed': 0,
        'totalScore': 0,
        'highScore': 0,
        'averageScore': 0,
      };
    }
  }

  // ✅ IMPLEMENTACIÓN REAL DE FIREBASE
  static Future<void> saveScoreToFirebase(int score, String playerName) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Crear el documento con los datos
      final docRef = await firestore.collection('scores').add({
        'playerName': playerName,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
        'device': 'flutter_web', // Para identificar la plataforma
      });

      print('✅ Score guardado en Firebase exitosamente! ID: ${docRef.id}');
      print('   Jugador: $playerName, Score: $score');
    } catch (e) {
      print('❌ Error guardando en Firebase: $e');
      rethrow;
    }
  }

  // ✅ NUEVO: Obtener scores desde Firebase
  static Future<List<Map<String, dynamic>>> getTopScoresFromFirebase({
    int limit = 10,
  }) async {
    try {
      final firestore = FirebaseFirestore.instance;

      final querySnapshot = await firestore
          .collection('scores')
          .orderBy('score', descending: true)
          .limit(limit)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'playerName': data['playerName'] ?? 'Anónimo',
          'score': data['score'] ?? 0,
          'timestamp': data['timestamp'],
        };
      }).toList();
    } catch (e) {
      print('Error obteniendo scores de Firebase: $e');
      return [];
    }
  }

  // ✅ NUEVO: Verificar conexión con Firebase
  static Future<bool> testFirebaseConnection() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Intenta hacer una operación simple
      await firestore.collection('test').limit(1).get();
      print('✅ Conexión con Firebase exitosa');
      return true;
    } catch (e) {
      print('❌ Error de conexión con Firebase: $e');
      return false;
    }
  }

  // Resetear puntaje (útil para testing)
  static Future<void> resetHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_highScoreKey);
    } catch (e) {
      print('Error resetting high score: $e');
    }
  }

  // Resetear todas las estadísticas
  static Future<void> resetAllStats() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_highScoreKey);
      await prefs.remove(_gamesPlayedKey);
      await prefs.remove(_totalScoreKey);
    } catch (e) {
      print('Error resetting all stats: $e');
    }
  }

  // Verificar si es un nuevo récord
  static Future<bool> isNewHighScore(int score) async {
    final currentHighScore = await getHighScore();
    return score > currentHighScore;
  }
}
