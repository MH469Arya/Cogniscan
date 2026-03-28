import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/test_result.dart';
import '../../providers/test_provider.dart';
import 'game2_attention_leaves.dart';
import 'game3_color_reaction.dart';
import 'game4_task_switching.dart';
import 'game5_speech_challenge.dart';
import 'results_summary_screen.dart';

class GameBetweenScreen extends ConsumerWidget {
  final GameResult result;

  const GameBetweenScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final gameIndex = result.gameIndex;
    final nextIndex = gameIndex + 1;
    final isFinished = nextIndex == 5;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check_circle, size: 80, color: theme.colorScheme.primary),
               ),
               const SizedBox(height: 32),
               Text(
                 'Congratulations!',
                 style: theme.textTheme.displayMedium,
               ),
               const SizedBox(height: 8),
               Text(
                 'You completed ${result.gameName}',
                 style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.secondary),
               ),
               const SizedBox(height: 32),
               Card(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
                   child: Column(
                     children: [
                       Text(
                         '${result.score}',
                         style: theme.textTheme.displayLarge?.copyWith(
                           color: theme.colorScheme.primary,
                           fontSize: 72,
                         ),
                       ),
                       Text('Score', style: theme.textTheme.titleMedium),
                       const SizedBox(height: 16),
                       Text(
                         result.encouragingMessage,
                         style: theme.textTheme.titleMedium?.copyWith(
                           color: theme.colorScheme.secondary,
                           fontStyle: FontStyle.italic,
                         ),
                       ),
                     ],
                   ),
                 ),
               ),
               const SizedBox(height: 48),
               SizedBox(
                 width: double.infinity,
                 height: 60,
                 child: ElevatedButton(
                   onPressed: () {
                     if (isFinished) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const ResultsSummaryScreen()),
                        );
                     } else {
                        ref.read(currentGameIndexProvider.notifier).nextGame();
                        _navigateToNextGame(context, nextIndex);
                     }
                   },
                   child: Text(
                     isFinished ? 'View Results' : 'Continue to Next Game',
                     style: const TextStyle(fontSize: 20),
                   ),
                 ),
               ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToNextGame(BuildContext context, int index) {
    Widget nextScreen;
    switch (index) {
      case 1: nextScreen = const AttentionLeavesGame(); break;
      case 2: nextScreen = const ColorReactionGame(); break;
      case 3: nextScreen = const TaskSwitchingGame(); break;
      case 4: nextScreen = const SpeechChallengeGame(); break;
      default: return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => nextScreen),
    );
  }
}
