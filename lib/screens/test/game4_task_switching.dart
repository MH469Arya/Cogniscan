import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:flutter_animate/flutter_animate.dart';
import '../../models/test_result.dart';
import '../../providers/test_provider.dart';
import '../../widgets/test/game_header.dart';
import 'game_between_screen.dart';

class TaskSwitchingGame extends ConsumerStatefulWidget {
  const TaskSwitchingGame({super.key});

  @override
  ConsumerState<TaskSwitchingGame> createState() => _TaskSwitchingGameState();
}

class _TaskSwitchingGameState extends ConsumerState<TaskSwitchingGame> {
  int _phase = 0; // 0: Instruction, 1: Round 1, 2: Round 2, 3: Round 3
  
  final List<String> _allNumbers = ['1', '2', '3', '4', '5', '6', '7', '8', '9'];
  final List<String> _allLetters = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  
  List<String> _gridItems = [];
  int _currentIndex = 0;
  int _errors = 0;
  DateTime? _roundStartTime;
  
  List<int> _roundTimes = []; // Time in ms per round
  List<int> _roundErrors = [];
  int? _lastCorrectIndex; // For animation

  void _startRound(int round) {
    setState(() {
      _phase = round;
      _currentIndex = 0;
      _errors = 0;
      _gridItems = _generateGrid(round);
      _roundStartTime = DateTime.now();
    });
  }

  List<String> _generateGrid(int round) {
     final List<String> items = [];
     if (round == 1) { // Numbers only
        items.addAll(_allNumbers);
        items.shuffle();
     } else if (round == 2) { // Letters only
        items.addAll(_allLetters);
        items.shuffle();
     } else { // Alternate (Number -> Letter -> Number -> Letter)
        final nums = ['1', '2', '3', '4', '5', '6', '7'];
        final letters = ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
        items.addAll(nums);
        items.addAll(letters);
        items.shuffle();
     }
     return items;
  }

  void _onItemTapped(int index) {
      final tappedItem = _gridItems[index];
      bool isCorrect = false;

      // Determine if tapped item is the expected one in the sequence
      if (_phase == 1) { // Numbers only (sorted order for challenge)
          final expected = (List<String>.from(_allNumbers)..sort()).elementAt(_currentIndex);
          isCorrect = tappedItem == expected;
      } else if (_phase == 2) { // Letters only (sorted order)
          final expected = (List<String>.from(_allLetters)..sort()).elementAt(_currentIndex);
          isCorrect = tappedItem == expected;
      } else { // Alternating: 1 -> A -> 2 -> B...
          if (_currentIndex % 2 == 0) { // Should be a number
             final targetNum = (_currentIndex ~/ 2) + 1;
             isCorrect = tappedItem == targetNum.toString();
          } else { // Should be a letter
             final letterIndex = _currentIndex ~/ 2;
             isCorrect = tappedItem == String.fromCharCode('A'.codeUnitAt(0) + letterIndex);
          }
      }

      if (isCorrect) {
          setState(() {
            _currentIndex++;
            _lastCorrectIndex = index;
          });
          // Clear animation index after a short delay
          Future.delayed(const Duration(milliseconds: 400), () {
             if (mounted) setState(() => _lastCorrectIndex = null);
          });
          
          if (_currentIndex == _gridItems.length) {
              _finishRound();
          }
      } else {
          setState(() {
            _errors++;
          });
          // Visual feedback for error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Wait, look for ${getExpectedItemName()}'), duration: const Duration(milliseconds: 500)),
          );
      }
  }

  String getExpectedItemName() {
    if (_phase == 1) return (_currentIndex + 1).toString();
    if (_phase == 2) return String.fromCharCode('A'.codeUnitAt(0) + _currentIndex);
    if (_currentIndex % 2 == 0) {
        return (_currentIndex ~/ 2 + 1).toString();
    } else {
        return String.fromCharCode('A'.codeUnitAt(0) + (_currentIndex ~/ 2));
    }
  }

  void _finishRound() {
    final now = DateTime.now();
    final duration = now.difference(_roundStartTime!).inMilliseconds;
    
    _roundTimes.add(duration);
    _roundErrors.add(_errors);

    if (_phase < 3) {
       // Show feedback before next round
       showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: const Text('Round Completed!'),
            content: Text('Accuracy and focus were key. Ready for the next challenge?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                    Navigator.pop(context);
                    _startRound(_phase + 1);
                },
                child: const Text('Next Round'),
              ),
            ],
          ),
       );
    } else {
       _finishGame();
    }
  }

  void _finishGame() {
    final totalTime = _roundTimes.reduce((a, b) => a + b);
    final totalErrors = _roundErrors.reduce((a, b) => a + b);
    
    final accuracy = 1.0 - (totalErrors / 50.0).clamp(0, 1.0);
    int score = (accuracy * 60 + (30000 / (totalTime + 1)) * 40).round();
    score = score.clamp(0, 100);

    final result = GameResult(
      gameIndex: 3,
      gameName: 'Task Switching',
      score: score,
      accuracy: accuracy,
      timeTakenSeconds: totalTime ~/ 1000,
      details: {
        'errors': totalErrors,
        'roundTimes': _roundTimes,
      },
    );

    ref.read(testSessionProvider.notifier).addGameResult(result);
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameBetweenScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: GameHeader(
        gameIndex: 3,
        onPause: () {},
        onEndEarly: () => Navigator.pop(context),
      ),
      body: _phase == 0 ? _buildInstructionUI(theme) : _buildGameUI(theme),
    );
  }

  Widget _buildInstructionUI(ThemeData theme) {
    return Center(
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
              child: Icon(Icons.sync_alt, size: 80, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 32),
            Text('Task Switching', style: theme.textTheme.displaySmall),
            const SizedBox(height: 16),
            Text(
              'Tap items in sequence! \nRound 1: Numbers (1, 2, 3...) \nRound 2: Letters (A, B, C...) \nRound 3: Alternate (1, A, 2, B...)',
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20, height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () => _startRound(1),
                child: const Text('Start Round 1'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameUI(ThemeData theme) {
    String roundTitle = '';
    if (_phase == 1) roundTitle = 'Numbers: Tap 1 to 9';
    if (_phase == 2) roundTitle = 'Letters: Tap A to G';
    if (_phase == 3) roundTitle = 'Alternating: 1 → A → 2 → B...';

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            children: [
              Text('Round $_phase of 3', style: theme.textTheme.titleMedium),
              const SizedBox(height: 8),
              Text(roundTitle, style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary)),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _gridItems.length,
            itemBuilder: (context, index) {
              final item = _gridItems[index];
              final bool isCorrectPulse = _lastCorrectIndex == index;
              final bool isAlreadyTapped = _isTapped(item);
              
              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: Container(
                  decoration: BoxDecoration(
                    color: isCorrectPulse 
                        ? Colors.green.withOpacity(0.3)
                        : isAlreadyTapped 
                            ? theme.colorScheme.secondary.withOpacity(0.2) 
                            : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isCorrectPulse
                          ? Colors.green
                          : isAlreadyTapped 
                              ? theme.colorScheme.secondary 
                              : theme.colorScheme.primary.withOpacity(0.3),
                      width: isCorrectPulse ? 3 : 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      item,
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: isCorrectPulse
                            ? Colors.green
                            : isAlreadyTapped 
                                ? theme.colorScheme.secondary 
                                : theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ).animate(
                  target: isCorrectPulse ? 1 : 0,
                ).scale(begin: const Offset(1, 1), end: const Offset(1.1, 1.1), duration: 200.ms, curve: Curves.easeOut)
                 .then().scale(begin: const Offset(1.1, 1.1), end: const Offset(1, 1), duration: 200.ms),
              );
            },
          ),
        ),
      ],
    );
  }

  bool _isTapped(String item) {
      if (_phase == 1) { // Numbers
          final currentNum = int.tryParse(item) ?? 10;
          return currentNum <= _currentIndex;
      } else if (_phase == 2) { // Letters
          final itemIdx = item.codeUnitAt(0) - 'A'.codeUnitAt(0);
          return itemIdx < _currentIndex;
      } else { // Alternating: 1 -> A -> 2 -> B...
          bool tapped = false;
          final int val = int.tryParse(item) ?? -1;
          if (val != -1) { // It's a number
              tapped = _currentIndex >= (val * 2 - 1);
          } else { // It's a letter
              int letterIdx = item.codeUnitAt(0) - 'A'.codeUnitAt(0);
              tapped = _currentIndex >= ((letterIdx + 1) * 2);
          }
          return tapped;
      }
  }
}
