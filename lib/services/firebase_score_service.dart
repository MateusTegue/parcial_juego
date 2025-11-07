import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseScoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _leaderboardCollection = 'leaderboard';

  static Future<void> saveScore({
    required int score,
    required String playerName,
  }) async {
    try {
      await _firestore.collection(_leaderboardCollection).add({
        'score': score,
        'playerName': playerName,
        'timestamp': FieldValue.serverTimestamp(),
        'device': 'mobile',
      });
    } catch (e) {
      // Manejar error si es necesario
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> getTopScores({
    int limit = 10,
  }) async {
    try {
      final snapshot = await _firestore
          .collection(_leaderboardCollection)
          .orderBy('score', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'score': data['score'] ?? 0,
          'playerName': data['playerName'] ?? 'Anonymous',
          'timestamp': data['timestamp'] as Timestamp?,
        };
      }).toList();
    } catch (e) {
      // Manejar error si es necesario
      return [];
    }
  }

  /// Obtener el top 100 del leaderboard
  static Future<List<Map<String, dynamic>>> getTop100Scores() async {
    return await getTopScores(limit: 100);
  }

  static Future<int> getHighestScore() async {
    try {
      final snapshot = await _firestore
          .collection(_leaderboardCollection)
          .orderBy('score', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return 0;

      return snapshot.docs.first.data()['score'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  // ==================== ESTADÍSTICAS DEL JUGADOR ====================

  /// Obtener puntajes de un jugador específico
  static Future<List<Map<String, dynamic>>> getPlayerScores(
    String playerName,
  ) async {
    try {
      final snapshot = await _firestore
          .collection(_leaderboardCollection)
          .where('playerName', isEqualTo: playerName)
          .orderBy('score', descending: true)
          .limit(20)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'score': data['score'] ?? 0,
          'timestamp': data['timestamp'] as Timestamp?,
        };
      }).toList();
    } catch (e) {
      return [];
    }
  }

  /// Obtener el mejor puntaje de un jugador
  static Future<int> getPlayerHighScore(String playerName) async {
    try {
      final snapshot = await _firestore
          .collection(_leaderboardCollection)
          .where('playerName', isEqualTo: playerName)
          .orderBy('score', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return 0;

      return snapshot.docs.first.data()['score'] ?? 0;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> getPlayerRank(String playerName) async {
    try {
      final playerScore = await getPlayerHighScore(playerName);
      if (playerScore == 0) return 0;

      final snapshot = await _firestore
          .collection(_leaderboardCollection)
          .where('score', isGreaterThan: playerScore)
          .get();

      // La posición es la cantidad de jugadores con mayor score + 1
      return snapshot.docs.length + 1;
    } catch (e) {
      return 0;
    }
  }

  static Future<Map<String, dynamic>> getGlobalStats() async {
    try {
      final snapshot = await _firestore
          .collection(_leaderboardCollection)
          .get();

      if (snapshot.docs.isEmpty) {
        return {
          'totalGames': 0,
          'totalPlayers': 0,
          'averageScore': 0,
          'highestScore': 0,
        };
      }

      final scores = snapshot.docs
          .map((doc) => doc.data()['score'] as int)
          .toList();
      final playerNames = snapshot.docs
          .map((doc) => doc.data()['playerName'] as String)
          .toSet();

      final totalScore = scores.reduce((a, b) => a + b);
      final averageScore = totalScore ~/ scores.length;
      final highestScore = scores.reduce((a, b) => a > b ? a : b);

      return {
        'totalGames': snapshot.docs.length,
        'totalPlayers': playerNames.length,
        'averageScore': averageScore,
        'highestScore': highestScore,
      };
    } catch (e) {
      return {
        'totalGames': 0,
        'totalPlayers': 0,
        'averageScore': 0,
        'highestScore': 0,
      };
    }
  }

  static Stream<List<Map<String, dynamic>>> getTopScoresStream({
    int limit = 10,
  }) {
    return _firestore
        .collection(_leaderboardCollection)
        .orderBy('score', descending: true)
        .limit(limit)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              'score': data['score'] ?? 0,
              'playerName': data['playerName'] ?? 'Anonymous',
              'timestamp': data['timestamp'] as Timestamp?,
            };
          }).toList();
        });
  }

  static Future<bool> isNewPersonalRecord(
    String playerName,
    int newScore,
  ) async {
    final currentHighScore = await getPlayerHighScore(playerName);
    return newScore > currentHighScore;
  }

  /// Verificar si es un nuevo récord global
  static Future<bool> isNewGlobalRecord(int newScore) async {
    final currentHighest = await getHighestScore();
    return newScore > currentHighest;
  }

  /// Limpiar datos antiguos (opcional - usar con cuidado)
  static Future<void> deleteOldScores({int daysOld = 90}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final snapshot = await _firestore
          .collection(_leaderboardCollection)
          .where('timestamp', isLessThan: Timestamp.fromDate(cutoffDate))
          .get();

      final batch = _firestore.batch();
      for (var doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      // Manejar error si es necesario
    }
  }
}
