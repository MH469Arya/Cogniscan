class GameResult {
  final int gameIndex; // 0–4
  final String gameName;
  final int score; // 0–100
  final double accuracy; // 0.0–1.0
  final int timeTakenSeconds;
  final Map<String, dynamic> details; // game-specific extra data

  const GameResult({
    required this.gameIndex,
    required this.gameName,
    required this.score,
    required this.accuracy,
    required this.timeTakenSeconds,
    this.details = const {},
  });

  String get encouragingMessage {
    if (score >= 85) return '🌟 Excellent work!';
    if (score >= 70) return '👏 Great job!';
    if (score >= 55) return '💪 Good effort!';
    return '🌱 Keep practicing!';
  }

  String get insightLabel {
    switch (gameIndex) {
      case 0:
        return score >= 75 ? 'Good memory' : 'Memory needs practice';
      case 1:
        return score >= 75 ? 'Sharp attention' : 'Attention needs practice';
      case 2:
        return score >= 75 ? 'Fast reactions' : 'Processing speed low';
      case 3:
        return score >= 75 ? 'Flexible thinking' : 'Task switching needs work';
      case 4:
        return score >= 75 ? 'Clear speech' : 'Speech fluency practice';
      default:
        return '';
    }
  }
}

class TestSession {
  final List<GameResult> gameResults;
  final DateTime timestamp;

  const TestSession({
    required this.gameResults,
    required this.timestamp,
  });

  int get overallScore {
    if (gameResults.isEmpty) return 0;
    final total = gameResults.fold<int>(0, (sum, r) => sum + r.score);
    return (total / gameResults.length).round();
  }

  bool get isComplete => gameResults.length == 5;

  static TestSession empty() => TestSession(
        gameResults: const [],
        timestamp: DateTime.now(),
      );
}
