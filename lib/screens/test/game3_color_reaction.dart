import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../models/test_result.dart';
import '../../providers/test_provider.dart';
import '../../widgets/test/game_header.dart';
import 'game_between_screen.dart';

class ColorReactionGame extends ConsumerStatefulWidget {
  const ColorReactionGame({super.key});

  @override
  ConsumerState<ColorReactionGame> createState() => _ColorReactionGameState();
}

class _ColorReactionGameState extends ConsumerState<ColorReactionGame> {
  int _phase = 0; // 0: Instruction, 1: Game
  int _trialCount = 0;
  final int _maxTrials = 25;
  
  Color? _currentColor;
  final Color _targetColor = const Color(0xFF006064); // Deep Teal
  bool _isShowing = false;
  Timer? _trialTimer;
  Timer? _spawnTimer;

  int _correctTaps = 0;
  int _errors = 0;
  List<int> _reactionTimes = [];
  DateTime? _shapeSpawnTime;

  final List<Color> _colors = [
    const Color(0xFF006064), // Teal (Target)
    const Color(0xFF4DB6AC), // Soft Teal
    const Color(0xFF81D4FA), // Blue
    const Color(0xFFFFF176), // Yellow
    const Color(0xFFE57373), // Red
  ];

  void _startGame() {
    setState(() {
      _phase = 1;
      _trialCount = 0;
      _correctTaps = 0;
      _errors = 0;
      _reactionTimes = [];
    });
    _nextTrial();
  }

  void _nextTrial() {
    if (_trialCount >= _maxTrials) {
      _finishGame();
      return;
    }

    final random = math.Random();
    final delay = 1000 + random.nextInt(2000); // 1-3 seconds

    _spawnTimer = Timer(Duration(milliseconds: delay), () {
      if (!mounted) return;
      setState(() {
        _isShowing = true;
        _currentColor = _colors[random.nextInt(_colors.length)];
        _shapeSpawnTime = DateTime.now();
        _trialCount++;
      });

      // Hide after some time if not tapped
      _trialTimer = Timer(const Duration(milliseconds: 1200), () {
        if (!mounted) return;
        if (_isShowing) {
          setState(() {
            _isShowing = false;
          });
          // If it was the target color and missed, count as error?
          // For now, just move to next
          _nextTrial();
        }
      });
    });
  }

  void _onShapeTapped() {
    if (!_isShowing) return;

    final now = DateTime.now();
    final reactionTime = now.difference(_shapeSpawnTime!).inMilliseconds;
    final isCorrect = _currentColor == _targetColor;

    setState(() {
      _isShowing = false;
      if (isCorrect) {
        _correctTaps++;
        _reactionTimes.add(reactionTime);
      } else {
        _errors++;
      }
    });

    _trialTimer?.cancel();
    _nextTrial();
  }

  void _finishGame() {
    _spawnTimer?.cancel();
    _trialTimer?.cancel();

    final avgReactionTime = _reactionTimes.isEmpty 
        ? 0 
        : _reactionTimes.reduce((a, b) => a + b) / _reactionTimes.length;
    
    // Score based on correct hits and speed
    double accuracy = _correctTaps / (_maxTrials / 3); // assuming roughly 1/3 are target
    accuracy = accuracy.clamp(0, 1.0);
    
    int score = (accuracy * 70 + (500 / (avgReactionTime + 1)) * 30).round();
    score = score.clamp(0, 100);

    final result = GameResult(
      gameIndex: 2,
      gameName: 'Color Reaction',
      score: score,
      accuracy: accuracy,
      timeTakenSeconds: 30, // Approx
      details: {
        'avgReactionTime': avgReactionTime,
        'errors': _errors,
      },
    );

    ref.read(testSessionProvider.notifier).addGameResult(result);
    
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameBetweenScreen(result: result),
      ),
    );
  }

  @override
  void dispose() {
    _spawnTimer?.cancel();
    _trialTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: GameHeader(
        gameIndex: 2,
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
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.touch_app, size: 80, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 32),
            Text('Color Reaction', style: theme.textTheme.displaySmall),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Tap ', style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20)),
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(color: _targetColor, shape: BoxShape.circle),
                ),
                Text(' Teal only!', style: theme.textTheme.bodyLarge?.copyWith(fontSize: 22, fontWeight: FontWeight.bold, color: _targetColor)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'A circle will appear in the center. Tap it ONLY if it is the target color. Be as fast as you can!',
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _startGame,
                child: const Text('Start Test'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameUI(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            'Trial $_trialCount of $_maxTrials',
            style: theme.textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: Center(
            child: GestureDetector(
              onTap: _onShapeTapped,
              child: AnimatedOpacity(
                opacity: _isShowing ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 100),
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: _currentColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}
