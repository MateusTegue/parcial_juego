import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      // Manejar error si es necesario
    }
  }

  // Obtener puntaje más alto
  static Future<int> getHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getInt(_highScoreKey) ?? 0;
    } catch (e) {
      //
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
      // Manejar error si es necesario
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
      return {
        'gamesPlayed': 0,
        'totalScore': 0,
        'highScore': 0,
        'averageScore': 0,
      };
    }
  }

  static Future<void> saveScoreToFirebase(int score, String playerName) async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Crear el documento con los datos
      final docRef = await firestore.collection('scores').add({
        'playerName': playerName,
        'score': score,
        'timestamp': FieldValue.serverTimestamp(),
        'device': 'flutter_web',
      });

      //
    } catch (e) {
      //
      rethrow;
    }
  }

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
      return [];
    }
  }

  static Future<bool> testFirebaseConnection() async {
    try {
      final firestore = FirebaseFirestore.instance;

      // Intenta hacer una operación simple
      await firestore.collection('test').limit(1).get();
      return true;
    } catch (e) {
      return false;
    }
  }

  // Resetear puntaje (útil para testing)
  static Future<void> resetHighScore() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_highScoreKey);
    } catch (e) {
      // Manejar error si es necesario
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
      // Manejar error si es necesario
    }
  }

  // Verificar si es un nuevo récord
  static Future<bool> isNewHighScore(int score) async {
    final currentHighScore = await getHighScore();
    return score > currentHighScore;
  }
}
