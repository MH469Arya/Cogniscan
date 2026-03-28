import 'package:flutter/material.dart';

/// A circular countdown timer for game phases.
class CountdownTimer extends StatelessWidget {
  final int seconds;
  final int totalSeconds;
  final double size;

  const CountdownTimer({
    super.key,
    required this.seconds,
    required this.totalSeconds,
    this.size = 60,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = seconds / totalSeconds;
    
    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 6,
            backgroundColor: theme.colorScheme.surface,
            valueColor: AlwaysStoppedAnimation<Color>(
              seconds < 4 ? theme.colorScheme.error : theme.colorScheme.secondary,
            ),
          ),
          Center(
            child: Text(
              '$seconds',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: seconds < 4 ? theme.colorScheme.error : theme.colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
