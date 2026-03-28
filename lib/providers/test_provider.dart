import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/test_result.dart';

/// Notifier to manage the current test session's game results
class TestSessionNotifier extends Notifier<TestSession> {
  @override
  TestSession build() => TestSession.empty();

  void addGameResult(GameResult result) {
    final updatedResults = List<GameResult>.from(state.gameResults);
    
    // If we already have a result for this game index, update it
    final existingIndex = updatedResults.indexWhere((r) => r.gameIndex == result.gameIndex);
    if (existingIndex != -1) {
      updatedResults[existingIndex] = result;
    } else {
      updatedResults.add(result);
      // Sort by index to keep them in order
      updatedResults.sort((a, b) => a.gameIndex.compareTo(b.gameIndex));
    }

    state = TestSession(
      gameResults: updatedResults,
      timestamp: state.timestamp,
    );
  }

  void resetSession() {
    state = TestSession.empty();
  }
}

/// Provider for the overall test session
final testSessionProvider = NotifierProvider<TestSessionNotifier, TestSession>(() {
  return TestSessionNotifier();
});

/// Notifier for the current game index in the test sequence
class CurrentGameIndexNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void setIndex(int index) => state = index;
  void nextGame() => state++;
  void reset() => state = 0;
}

/// Provider for the current game index (0-4)
final currentGameIndexProvider = NotifierProvider<CurrentGameIndexNotifier, int>(() {
  return CurrentGameIndexNotifier();
});

/// Simple model for game metadata used in the selection screen
class GameMetadata {
  final String title;
  final String description;
  final String route;

  const GameMetadata({
    required this.title,
    required this.description,
    required this.route,
  });
}

/// List of all 5 available games
final allGamesMetadata = Provider<List<GameMetadata>>((ref) {
  return const [
    GameMetadata(
      title: 'Memory Match',
      description: 'Remember and find the items you saw earlier.',
      route: '/game1',
    ),
    GameMetadata(
      title: 'Attention Leaves',
      description: 'Follow the leaves as they move and point.',
      route: '/game2',
    ),
    GameMetadata(
      title: 'Color Reaction',
      description: 'Tap as quickly as you can when the target color appears.',
      route: '/game3',
    ),
    GameMetadata(
      title: 'Task Switching',
      description: 'Switch between numbers and letters as fast as possible.',
      route: '/game4',
    ),
    GameMetadata(
      title: 'Speech Challenge',
      description: 'Practice your naming and recall skills aloud.',
      route: '/game5',
    ),
  ];
});
