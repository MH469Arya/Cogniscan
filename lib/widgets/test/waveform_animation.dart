import 'package:flutter/material.dart';
import 'dart:math' as math;

/// Animated waveforms for Game 5 to show voice activity.
class WaveformAnimation extends StatefulWidget {
  final bool isListening;

  const WaveformAnimation({super.key, required this.isListening});

  @override
  State<WaveformAnimation> createState() => _WaveformAnimationState();
}

class _WaveformAnimationState extends State<WaveformAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final int _barCount = 15;
  final List<double> _heights = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();

    for (int i = 0; i < _barCount; i++) {
        _heights.add(math.Random().nextDouble());
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      height: 100,
      width: double.infinity,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(_barCount, (index) {
                final double currentHeight = widget.isListening
                      ? 20 + (60 * (0.4 + 0.6 * math.sin(_controller.value * 2 * math.pi + (index * 0.5))).abs())
                      : 10.0;
                
              return Container(
                width: 8,
                height: currentHeight,
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: widget.isListening ? 0.8 : 0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}
