import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'dart:math' as math;
import '../../models/test_result.dart';
import '../../providers/test_provider.dart';
import '../../widgets/test/game_header.dart';
import 'game_between_screen.dart';

class AttentionLeavesGame extends ConsumerStatefulWidget {
  const AttentionLeavesGame({super.key});

  @override
  ConsumerState<AttentionLeavesGame> createState() => _AttentionLeavesGameState();
}

class _AttentionLeavesGameState extends ConsumerState<AttentionLeavesGame> {
  int _phase = 0; // 0: Instruction, 1: Game
  String _mode = 'Pointing'; // 'Pointing' or 'Moving'
  Timer? _modeTimer;
  Timer? _moveTimer;
  Timer? _gameTimer;

  // Directions: 0: Left, 1: Up, 2: Right, 3: Down
  final List<Offset> _directionVectors = [
    const Offset(-1, 0),  // Left
    const Offset(0, -1),  // Up
    const Offset(1, 0),   // Right
    const Offset(0, 1),   // Down
  ];

  // Single shared state — all leaves mirror these
  int _pointingDirection = 2; // visual rotation of ALL leaves
  int _movingDirection = 2;   // movement direction of ALL leaves

  // Group center (normalized 0–1)
  double _groupX = 0.5;
  double _groupY = 0.5;

  // Fixed relative offsets for 5 leaves from the group center (normalized)
  final List<Offset> _relativeOffsets = const [
    Offset(0.0,  0.0),   // center
    Offset(-0.22, -0.20), // top-left
    Offset(0.22, -0.20),  // top-right
    Offset(-0.22,  0.20), // bottom-left
    Offset(0.22,  0.20),  // bottom-right
  ];

  int _correctTaps = 0;
  int _totalTaps = 0;
  int _secondsLeft = 40;

  static const double _step = 0.15; // movement per tick

  @override
  void initState() {
    super.initState();
    final r = math.Random();
    _pointingDirection = r.nextInt(4);
    _movingDirection = r.nextInt(4);
  }

  void _startGame() {
    setState(() {
      _phase = 1;
      _groupX = 0.5;
      _groupY = 0.5;
      _secondsLeft = 40;
    });

    // Switch mode every 8 seconds
    _modeTimer = Timer.periodic(const Duration(seconds: 8), (_) {
      setState(() {
        _mode = _mode == 'Pointing' ? 'Moving' : 'Pointing';
      });
    });

    // Move the entire group in the shared _movingDirection every 1.5s
    _moveTimer = Timer.periodic(const Duration(milliseconds: 1500), (_) {
      final r = math.Random();
      setState(() {
        final dx = _directionVectors[_movingDirection].dx;
        final dy = _directionVectors[_movingDirection].dy;

        _groupX += dx * _step;
        _groupY += dy * _step;

        // Wrap the group center if it goes out of bounds
        if (_groupX < 0.1) _groupX = 0.85;
        if (_groupX > 0.90) _groupX = 0.1;
        if (_groupY < 0.1) _groupY = 0.85;
        if (_groupY > 0.90) _groupY = 0.1;

        // Change directions every ~3 ticks
        if (r.nextInt(3) == 0) {
          _pointingDirection = r.nextInt(4);
          _movingDirection = r.nextInt(4);
        }
      });
    });

    // Countdown timer
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() => _secondsLeft--);
      if (_secondsLeft <= 0) {
        timer.cancel();
        _finishGame();
      }
    });
  }

  void _onDirectionPressed(int tappedDirection) {
    if (_phase != 1) return;

    final correctAnswer =
        _mode == 'Pointing' ? _pointingDirection : _movingDirection;

    setState(() {
      _totalTaps++;
      if (tappedDirection == correctAnswer) _correctTaps++;
    });

    // Immediately change directions after answer
    final r = math.Random();
    setState(() {
      _pointingDirection = r.nextInt(4);
      _movingDirection = r.nextInt(4);
    });
  }

  void _finishGame() {
    _modeTimer?.cancel();
    _moveTimer?.cancel();
    _gameTimer?.cancel();

    final accuracy = _totalTaps > 0 ? _correctTaps / _totalTaps : 0.0;
    final score = (accuracy * 100).round();

    final result = GameResult(
      gameIndex: 1,
      gameName: 'Attention Leaves',
      score: score,
      accuracy: accuracy,
      timeTakenSeconds: 40,
    );

    ref.read(testSessionProvider.notifier).addGameResult(result);

    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameBetweenScreen(result: result)),
    );
  }

  @override
  void dispose() {
    _modeTimer?.cancel();
    _moveTimer?.cancel();
    _gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: GameHeader(
        gameIndex: 1,
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
                color: theme.colorScheme.secondary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/game2/leaf.png',
                width: 80, height: 80,
                errorBuilder: (_, __, ___) =>
                    Icon(Icons.eco, size: 80, color: theme.colorScheme.secondary),
              ),
            ),
            const SizedBox(height: 32),
            Text('Attention Leaves', style: theme.textTheme.displaySmall),
            const SizedBox(height: 16),
            Text(
              '• POINTING: All leaves point the same way.\n  Tap where they are pointing!\n\n'
              '• MOVING: All leaves move together.\n  Tap where they are going!',
              style: theme.textTheme.bodyLarge
                  ?.copyWith(fontSize: 18, height: 1.7),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _startGame,
                child: const Text('Start Game!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGameUI(ThemeData theme) {
    final isPointing = _mode == 'Pointing';
    return Column(
      children: [
        // ── Mode Banner ──────────────────────────────
        AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          color: isPointing
              ? theme.colorScheme.primary.withOpacity(0.1)
              : theme.colorScheme.secondary.withOpacity(0.1),
          child: Column(
            children: [
              Text(
                isPointing ? '🍃 POINTING MODE' : '🍃 MOVING MODE',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: isPointing
                      ? theme.colorScheme.primary
                      : theme.colorScheme.secondary,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                isPointing
                    ? 'Tap where the leaves are POINTING'
                    : 'Tap where the leaves are MOVING',
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                '⏱ $_secondsLeft s  |  ✅ $_correctTaps / $_totalTaps',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
        ),

        // ── Leaf Playing Field ───────────────────────
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const leafSize = 72.0;
              return Stack(
                children: _relativeOffsets.map((offset) {
                  final left = (_groupX + offset.dx) *
                          (constraints.maxWidth - leafSize);
                  final top = (_groupY + offset.dy) *
                          (constraints.maxHeight - leafSize);

                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 1400),
                    curve: Curves.easeInOut,
                    left: left.clamp(0.0, constraints.maxWidth - leafSize),
                    top: top.clamp(0.0, constraints.maxHeight - leafSize),
                    child: AnimatedRotation(
                      // All leaves rotate to the SAME angle simultaneously
                      turns: _pointingDirection / 4.0,
                      duration: const Duration(milliseconds: 400),
                      child: Image.asset(
                        'assets/images/game2/leaf.png',
                        width: leafSize,
                        height: leafSize,
                        fit: BoxFit.contain,
                        errorBuilder: (context, _, __) => Icon(
                          Icons.eco,
                          size: leafSize,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),

        // ── Direction Buttons ────────────────────────
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          color: theme.colorScheme.surface,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _dirBtn(Icons.arrow_back,     0, theme),
              _dirBtn(Icons.arrow_upward,   1, theme),
              _dirBtn(Icons.arrow_forward,  2, theme),
              _dirBtn(Icons.arrow_downward, 3, theme),
            ],
          ),
        ),
      ],
    );
  }

  Widget _dirBtn(IconData icon, int direction, ThemeData theme) {
    return SizedBox(
      width: 72, height: 72,
      child: ElevatedButton(
        onPressed: () => _onDirectionPressed(direction),
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero,
          backgroundColor: theme.colorScheme.secondary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        child: Icon(icon, size: 34, color: Colors.white),
      ),
    );
  }
}
