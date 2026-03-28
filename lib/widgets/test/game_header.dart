import 'package:flutter/material.dart';

/// A reusable header for all game screens, showing the current progress, 
/// a pause button, and an option to end the test early.
class GameHeader extends StatelessWidget implements PreferredSizeWidget {
  final int gameIndex; // 0-4
  final VoidCallback onPause;
  final VoidCallback? onEndEarly;

  const GameHeader({
    super.key,
    required this.gameIndex,
    required this.onPause,
    this.onEndEarly,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = (gameIndex + 1) / 5;

    return AppBar(
      automaticallyImplyLeading: false,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Game ${gameIndex + 1} of 5',
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: theme.colorScheme.surface,
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.pause_circle_outline, size: 32),
          onPressed: onPause,
          color: theme.colorScheme.secondary,
        ),
        if (onEndEarly != null)
          TextButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('End Test Early?'),
                  content: const Text('Are you sure you want to stop the test? Your current progress will not be saved.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Continue'),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                      onPressed: () {
                        Navigator.pop(context); // Close dialog
                        onEndEarly!(); // Execute end early logic
                      },
                      child: const Text('End Early'),
                    ),
                  ],
                ),
              );
            },
            child: Text(
              'End Early',
              style: TextStyle(color: theme.colorScheme.error, fontWeight: FontWeight.bold),
            ),
          ),
        const SizedBox(width: 8),
      ],
      toolbarHeight: 80,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(80);
}
