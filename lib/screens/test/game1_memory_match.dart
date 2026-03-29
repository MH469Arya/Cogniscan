import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../models/test_result.dart';
import '../../providers/test_provider.dart';
import '../../widgets/test/game_header.dart';
import '../../widgets/test/countdown_timer.dart';
import 'game_between_screen.dart';

class MemoryMatchGame extends ConsumerStatefulWidget {
  const MemoryMatchGame({super.key});

  @override
  ConsumerState<MemoryMatchGame> createState() => _MemoryMatchGameState();
}

class _MemoryMatchGameState extends ConsumerState<MemoryMatchGame> {
  int _phase = 0; // 0: Instruction, 1: Show Items, 2: Match Grid
  int _countdown = 10;
  Timer? _timer;
  
  final List<Map<String, dynamic>> _allPossibleItems = [
     {'icon': Icons.apple, 'label': 'Apple', 'image': 'assets/images/game1/apple.png'},
     {'icon': Icons.directions_bus, 'label': 'Bus', 'image': 'assets/images/game1/bus.png'},
     {'icon': Icons.house, 'label': 'House', 'image': 'assets/images/game1/house.png'},
     {'icon': Icons.star, 'label': 'Star', 'image': 'assets/images/game1/star.png'},
     {'icon': Icons.icecream, 'label': 'Ice Cream', 'image': 'assets/images/game1/icecream.png'},
     {'icon': Icons.beach_access, 'label': 'Umbrella', 'image': 'assets/images/game1/umbrella.png'},
     {'icon': Icons.brightness_2, 'label': 'Moon', 'image': 'assets/images/game1/moon.png'},
     {'icon': Icons.pets, 'label': 'Dog', 'image': 'assets/images/game1/dog.png'},
     {'icon': Icons.flight, 'label': 'Plane', 'image': 'assets/images/game1/plane.png'},
     {'icon': Icons.camera_alt, 'label': 'Camera', 'image': 'assets/images/game1/camera.png'},
     {'icon': Icons.music_note, 'label': 'Music', 'image': 'assets/images/game1/music.png'},
     {'icon': Icons.local_fire_department, 'label': 'Fire', 'image': 'assets/images/game1/fire.png'},
     {'icon': Icons.anchor, 'label': 'Anchor', 'image': 'assets/images/game1/anchor.png'},
     {'icon': Icons.laptop, 'label': 'Laptop', 'image': 'assets/images/game1/laptop.png'},
  ];

  late List<Map<String, dynamic>> _targetItems;
  late List<Map<String, dynamic>> _gridItems;
  final List<int> _selectedIndices = [];
  int _correctTaps = 0;
  int _falseTaps = 0;
  DateTime? _startTime;

  @override
  void initState() {
    super.initState();
    _startInstruction();
  }

  void _startInstruction() {
      // Pick 8 targets
      final shuffled = List<Map<String, dynamic>>.from(_allPossibleItems)..shuffle();
      _targetItems = shuffled.take(8).toList();

      // Create a grid of 16 (8 targets + 8 distractors)
      final distractors = shuffled.skip(8).take(8).toList();
      _gridItems = List<Map<String, dynamic>>.from(_targetItems)..addAll(distractors);
      _gridItems.shuffle();
  }

  void _startShowItems() {
    setState(() => _phase = 1);
    _countdown = 10;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        _timer?.cancel();
        _startMatchGrid();
      }
    });
  }

  void _startMatchGrid() {
    setState(() => _phase = 2);
    _startTime = DateTime.now();
  }

  void _onItemTapped(int index) {
    if (_selectedIndices.contains(index)) return;

    final tappedItem = _gridItems[index];
    final isCorrect = _targetItems.any((target) => target['label'] == tappedItem['label']);

    setState(() {
      _selectedIndices.add(index);
      if (isCorrect) {
        _correctTaps++;
      } else {
        _falseTaps++;
      }
    });

    if (_correctTaps == _targetItems.length) {
      _finishGame();
    }
  }

  void _finishGame() {
    final endTime = DateTime.now();
    final durationSeconds = endTime.difference(_startTime!).inSeconds;
    
    final accuracy = _correctTaps / (_correctTaps + _falseTaps);
    // Score formula combining accuracy and speed
    int score = (accuracy * 80 + (40 / (durationSeconds + 1)) * 20).round();
    score = score.clamp(0, 100);

    final result = GameResult(
      gameIndex: 0,
      gameName: 'Memory Match',
      score: score,
      accuracy: accuracy,
      timeTakenSeconds: durationSeconds,
      details: {'falseTaps': _falseTaps},
    );

    ref.read(testSessionProvider.notifier).addGameResult(result);
    
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => GameBetweenScreen(result: result),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: GameHeader(
        gameIndex: 0,
        onPause: () {},
        onEndEarly: () => Navigator.pop(context),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          image: const DecorationImage(
            image: AssetImage('assets/images/bg/game_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.2, // Subtle background
          ),
        ),
        child: _buildPhaseContent(theme),
      ),
    );
  }

  Widget _buildPhaseContent(ThemeData theme) {
    if (_phase == 0) {
      return _buildInstructionUI(theme);
    } else if (_phase == 1) {
      return _buildShowItemsUI(theme);
    } else {
      return _buildMatchGridUI(theme);
    }
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
                color: theme.colorScheme.secondary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.psychology, size: 80, color: theme.colorScheme.secondary),
            ),
            const SizedBox(height: 32),
            Text('Memory Match', style: theme.textTheme.displaySmall),
            const SizedBox(height: 16),
            Text(
              'We will show you 8 items. Remember them correctly, then find them in a larger grid!',
              style: theme.textTheme.bodyLarge?.copyWith(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _startShowItems,
                child: const Text('I\'m Ready!'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShowItemsUI(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0),
          child: Column(
            children: [
              Text('Memorize these items', style: theme.textTheme.headlineMedium),
              const SizedBox(height: 16),
              CountdownTimer(seconds: _countdown, totalSeconds: 10, size: 80),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.5,
            ),
            itemCount: _targetItems.length,
            itemBuilder: (context, index) {
              final item = _targetItems[index];
              return Container(
                clipBehavior: Clip.antiAlias,
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: theme.colorScheme.primary.withValues(alpha: 0.3)),
                ),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildItemContent(item, theme, size: 80, isWholeCard: true),
                    // Glassy overlay for text label
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        color: Colors.black.withValues(alpha: 0.5),
                        child: Text(
                          item['label'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMatchGridUI(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: Text(
            'Find the original items! ($_correctTaps / ${_targetItems.length})',
            style: theme.textTheme.headlineSmall,
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: _gridItems.length,
            itemBuilder: (context, index) {
              final item = _gridItems[index];
              final isSelected = _selectedIndices.contains(index);
              final isCorrectMatch = isSelected && _targetItems.any((t) => t['label'] == item['label']);
              final isWrongMatch = isSelected && !isCorrectMatch;

              return GestureDetector(
                onTap: () => _onItemTapped(index),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: isCorrectMatch 
                        ? Colors.green.withValues(alpha: 0.1) 
                        : isWrongMatch 
                            ? theme.colorScheme.error.withValues(alpha: 0.1)
                            : theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isCorrectMatch 
                          ? Colors.green 
                          : isWrongMatch 
                              ? theme.colorScheme.error 
                              : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Base Image/Icon
                      Opacity(
                        opacity: isSelected ? 0.3 : 1.0,
                        child: _buildItemContent(item, theme, size: 80, isWholeCard: true),
                      ),
                      // Feedback Overlay
                      if (isCorrectMatch)
                        const Center(
                          child: Icon(Icons.check_circle, color: Colors.green, size: 48),
                        ),
                      if (isWrongMatch)
                        const Center(
                          child: Icon(Icons.cancel, color: Colors.red, size: 48),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildItemContent(Map<String, dynamic> item, ThemeData theme, {double size = 32, Color? color, bool isWholeCard = false}) {
    return Padding(
      padding: EdgeInsets.all(isWholeCard ? 0.0 : 4.0),
      child: Image.asset(
        item['image'],
        width: size,
        height: size,
        fit: isWholeCard ? BoxFit.cover : BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if image not found
          return Icon(
            item['icon'],
            size: size,
            color: color ?? theme.colorScheme.primary,
          );
        },
      ),
    );
  }
}
