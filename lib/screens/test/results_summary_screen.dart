import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../models/test_result.dart';
import '../../providers/test_provider.dart';
import '../../providers/app_providers.dart';
import '../../models/user_profile.dart';

class ResultsSummaryScreen extends ConsumerWidget {
  const ResultsSummaryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final session = ref.watch(testSessionProvider);
    final results = session.gameResults;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results Summary'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () => _finishAndReturnHome(context, ref, session),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              children: [
                _buildOverallScore(theme, session.overallScore),
                const SizedBox(height: 32),
                _buildChartSection(theme, results),
                const SizedBox(height: 32),
                _buildInsightsList(theme, results),
                const SizedBox(height: 48),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: ElevatedButton(
                    onPressed: () => _finishAndReturnHome(context, ref, session),
                    child: const Text('Return to Home', style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOverallScore(ThemeData theme, int score) {
      return Column(
        children: [
          Text(
            'Overall Cognitive Score',
            style: theme.textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: score / 100.0,
                  strokeWidth: 12,
                  backgroundColor: theme.colorScheme.surface,
                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                ),
              ),
              Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                    Text(
                      '$score',
                      style: theme.textTheme.displayLarge?.copyWith(
                         color: theme.colorScheme.primary,
                         fontSize: 56,
                      ),
                    ),
                    Text('out of 100', style: theme.textTheme.titleMedium),
                 ],
              ),
            ],
          ),
        ],
      );
  }

  Widget _buildChartSection(ThemeData theme, List<GameResult> results) {
    return Column(
        children: [
          Text('Your Performance Radar', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          Container(
            height: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
               color: theme.colorScheme.surface,
               borderRadius: BorderRadius.circular(25),
            ),
            child: RadarChart(
               RadarChartData(
                  radarShape: RadarShape.circle,
                  ticksTextStyle: const TextStyle(color: Colors.transparent),
                  gridBorderData: BorderSide(color: theme.colorScheme.secondary.withOpacity(0.2), width: 1),
                  borderData: FlBorderData(show: false),
                  titlePositionPercentageOffset: 0.1,
                  titleTextStyle: theme.textTheme.labelLarge,
                  dataSets: [
                     RadarDataSet(
                        fillColor: theme.colorScheme.primary.withOpacity(0.3),
                        borderColor: theme.colorScheme.primary,
                        entryRadius: 3,
                        dataEntries: results.isEmpty 
                            ? List.generate(5, (_) => const RadarEntry(value: 0))
                            : results.map((r) => RadarEntry(value: r.score.toDouble())).toList(),
                     ),
                  ],
                  getTitle: (index, angle) {
                     if (results.isEmpty) return const RadarChartTitle(text: '');
                     return RadarChartTitle(text: results[index].gameName);
                  },
               ),
            ),
          ),
        ],
    );
  }

  Widget _buildInsightsList(ThemeData theme, List<GameResult> results) {
     return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Key Insights', style: theme.textTheme.headlineSmall),
          const SizedBox(height: 16),
          ...results.map((r) => Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
               leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.2),
                  child: Text('${r.gameIndex + 1}', style: TextStyle(color: theme.colorScheme.secondary, fontWeight: FontWeight.bold)),
               ),
               title: Text(r.gameName, style: const TextStyle(fontWeight: FontWeight.bold)),
               subtitle: Text(r.insightLabel),
               trailing: Text('${r.score}', style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.primary)),
            ),
          )),
        ],
     );
  }

  void _finishAndReturnHome(BuildContext context, WidgetRef ref, TestSession session) {
      if (session.gameResults.isNotEmpty) {
           // Mock update the global user score in the provider
           final oldUser = ref.read(userProvider);
           if (oldUser != null) {
              ref.read(userProvider.notifier).setUser(
                 UserProfile(
                    id: oldUser.id,
                    name: oldUser.name,
                    age: oldUser.age,
                    email: oldUser.email,
                    avatarUrl: oldUser.avatarUrl,
                    currentScore: session.overallScore,
                 )
              );
           }
      }
      ref.read(testSessionProvider.notifier).resetSession();
      Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
