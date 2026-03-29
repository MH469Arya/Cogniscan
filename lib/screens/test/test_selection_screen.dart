import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/test_provider.dart';
import 'game1_memory_match.dart';
import 'game2_attention_leaves.dart';
import 'game3_color_reaction.dart';
import 'game4_task_switching.dart';
import 'game5_speech_challenge.dart';

class TestSelectionScreen extends ConsumerWidget {
  const TestSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final games = ref.watch(allGamesMetadata);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Cognitive Test'),
        elevation: 0,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Choose a game to start or follow the sequence to complete the session.',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: games.length,
                  itemBuilder: (context, index) {
                    final game = games[index];
                    return _buildGameCard(context, ref, index, game);
                  },
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: SizedBox(
                   width: double.infinity,
                   height: 60,
                   child: ElevatedButton(
                    onPressed: () => _startGame(context, ref, 0),
                    child: const Text('Start Full Session', style: TextStyle(fontSize: 20)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, WidgetRef ref, int index, GameMetadata game) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.secondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'GAME ${index + 1}',
                    style: TextStyle(
                      color: theme.colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
            const SizedBox(height: 12),
            Text(game.title, style: theme.textTheme.headlineMedium),
            const SizedBox(height: 8),
            Text(
              game.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => _startGame(context, ref, index),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Start Game', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _startGame(BuildContext context, WidgetRef ref, int index) {
    ref.read(currentGameIndexProvider.notifier).setIndex(index);
    Widget nextScreen;
    switch (index) {
      case 0: nextScreen = const MemoryMatchGame(); break;
      case 1: nextScreen = const AttentionLeavesGame(); break;
      case 2: nextScreen = const ColorReactionGame(); break;
      case 3: nextScreen = const TaskSwitchingGame(); break;
      case 4: nextScreen = const SpeechChallengeGame(); break;
      default: return;
    }
    Navigator.push(context, MaterialPageRoute(builder: (_) => nextScreen));
  }
}
