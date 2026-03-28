import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  const TestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Cognitive Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_esports, 
                size: 120, 
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                'Cognitive test questions and games will be added here later.',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineMedium,
              ),
              const SizedBox(height: 48),
              SizedBox(
                width: double.infinity,
                height: 80,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.secondary,
                    textStyle: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    // Logic to start the test
                  },
                  child: const Text('Start Test'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
