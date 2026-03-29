import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../../models/test_result.dart';
import '../../providers/test_provider.dart';
import '../../widgets/test/game_header.dart';
import 'game_between_screen.dart';

class SpeechChallengeGame extends ConsumerStatefulWidget {
  const SpeechChallengeGame({super.key});

  @override
  ConsumerState<SpeechChallengeGame> createState() =>
      _SpeechChallengeGameState();
}

class _SpeechChallengeGameState extends ConsumerState<SpeechChallengeGame> {
  int _phase = 0;       // 0: ready, 1: recording, 2: processing/done
  int _sentenceIndex = 0;
  bool _isRecording = false;
  String _transcription = '';
  int _countdown = 30;
  Timer? _timer;
  Timer? _transcriptTimer;
  int _correctSentences = 0;
  int _totalSentences = 0;

  // PageController for the slide-left carousel
  final PageController _pageController = PageController();

  final AudioRecorder _recorder = AudioRecorder();

  // ── Sentences ───────────────────────────────────────────────
  final List<String> _sentences = [
    'The sun rises in the east and sets in the west.',
    'She sells sea shells by the seashore.',
    'A rolling stone gathers no moss over time.',
    'The quick brown fox jumps over the lazy dog.',
  ];

  // Mock chunked transcription for each sentence (simulates live STT)
  final List<List<String>> _mockTranscriptions = [
    ['The sun', 'The sun rises', 'The sun rises in the east', 'The sun rises in the east and sets in the west.'],
    ['She sells', 'She sells sea shells', 'She sells sea shells by the seashore.'],
    ['A rolling stone', 'A rolling stone gathers no moss', 'A rolling stone gathers no moss over time.'],
    ['The quick brown fox', 'The quick brown fox jumps over', 'The quick brown fox jumps over the lazy dog.'],
  ];

  @override
  void dispose() {
    _recorder.dispose();
    _timer?.cancel();
    _transcriptTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  // ── Recording ───────────────────────────────────────────────
  Future<void> _startRecording() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Microphone permission is required.')),
        );
      }
      return;
    }

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/speech_$_sentenceIndex.m4a';
    await _recorder.start(const RecordConfig(), path: path);

    setState(() {
      _isRecording = true;
      _phase = 1;
      _transcription = '';
      _countdown = 10;
    });

    _startCountdown();
    _simulateLiveTranscription();
  }

  void _startCountdown() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        t.cancel();
        _stopRecording();
      }
    });
  }

  void _simulateLiveTranscription() {
    _transcriptTimer?.cancel();
    final chunks = _mockTranscriptions[_sentenceIndex];
    int i = 0;
    _transcriptTimer = Timer.periodic(const Duration(milliseconds: 700), (t) {
      if (!mounted) { t.cancel(); return; }
      if (i < chunks.length) {
        setState(() => _transcription = chunks[i]);
        i++;
      } else {
        t.cancel();
      }
    });
  }

  Future<void> _stopRecording() async {
    _timer?.cancel();
    _transcriptTimer?.cancel();
    await _recorder.stop();

    // Simple accuracy check (mock)
    final expected = _sentences[_sentenceIndex].toLowerCase();
    final got = _transcription.toLowerCase();
    final words = expected.split(' ');
    final isCorrect = got.isNotEmpty &&
        (got.contains(words.first) || got.contains(words.last.replaceAll('.', '')));

    if (isCorrect) _correctSentences++;
    _totalSentences++;

    if (!mounted) return;
    setState(() {
      _isRecording = false;
      _phase = 0;
    });

    await Future.delayed(const Duration(milliseconds: 300));

    if (!mounted) return;
    if (_sentenceIndex < _sentences.length - 1) {
      // Slide to next sentence (left scroll)
      await _pageController.animateToPage(
        _sentenceIndex + 1,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
      if (mounted) {
        setState(() {
          _sentenceIndex++;
          _transcription = '';
        });
      }
    } else {
      _processResults();
    }
  }

  void _processResults() {
    setState(() => _phase = 2);
    Future.delayed(const Duration(seconds: 2), _finishGame);
  }

  void _finishGame() {
    final accuracy = _totalSentences > 0 ? _correctSentences / _totalSentences : 0.0;
    final score = (accuracy * 100).round();

    final result = GameResult(
      gameIndex: 4,
      gameName: 'Speech Challenge',
      score: score,
      accuracy: accuracy,
      timeTakenSeconds: _sentences.length * 10,
      details: {'sentencesCorrect': _correctSentences},
    );

    ref.read(testSessionProvider.notifier).addGameResult(result);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => GameBetweenScreen(result: result)),
    );
  }

  // ── Build ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: GameHeader(
        gameIndex: 4,
        onPause: () {},
        onEndEarly: () => Navigator.pop(context),
      ),
      body: _phase == 2 ? _buildProcessing(theme) : _buildMainUI(theme),
    );
  }

  Widget _buildMainUI(ThemeData theme) {
    return SafeArea(
      child: Column(
        children: [
          // ── Top: counter + instruction ──────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Column(
              children: [
                // Counter pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${_sentenceIndex + 1} out of ${_sentences.length}',
                    style: TextStyle(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Read aloud the following sentence',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.hintColor,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // ── Sentence Carousel (slides left) ─────────────────
          SizedBox(
            height: 140,
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(), // programmatic only
              itemCount: _sentences.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.07),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: theme.colorScheme.primary.withValues(alpha: 0.18),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        _sentences[index],
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                          height: 1.4,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 28),

          // ── Progress dots ────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_sentences.length, (i) {
              final done = i < _sentenceIndex;
              final current = i == _sentenceIndex;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: current ? 22 : 9,
                height: 9,
                decoration: BoxDecoration(
                  color: done
                      ? Colors.green
                      : current
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }),
          ),

          const SizedBox(height: 32),

          // ── Mic Button (centered) ────────────────────────────
          GestureDetector(
            onTap: _isRecording ? _stopRecording : _startRecording,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _isRecording ? 112 : 96,
              height: _isRecording ? 112 : 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isRecording
                    ? theme.colorScheme.error
                    : theme.colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: (_isRecording
                            ? theme.colorScheme.error
                            : theme.colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: _isRecording ? 32 : 14,
                    spreadRadius: _isRecording ? 8 : 0,
                  ),
                ],
              ),
              child: Icon(
                _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                size: 48,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Timer / hint text
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: _isRecording
                ? Text(
                    '⏱  $_countdown s  •  tap to stop',
                    key: const ValueKey('timer'),
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : Text(
                    'Tap mic to start recording',
                    key: const ValueKey('hint'),
                    style: TextStyle(color: theme.hintColor),
                  ),
          ),

          const SizedBox(height: 24),

          // ── Live transcription box ───────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 90, maxHeight: 130),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: _isRecording
                      ? theme.colorScheme.primary.withValues(alpha: 0.35)
                      : Colors.transparent,
                  width: 2,
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _transcription.isEmpty
                    ? Row(
                        key: const ValueKey('ph'),
                        children: [
                          Icon(Icons.text_fields_rounded,
                              color: theme.hintColor.withValues(alpha: 0.35),
                              size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'Your speech will appear here…',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.hintColor.withValues(alpha: 0.5),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      )
                    : Text(
                        _transcription,
                        key: ValueKey(_transcription),
                        style: theme.textTheme.bodyLarge
                            ?.copyWith(height: 1.5),
                      ),
              ),
            ),
          ),

          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildProcessing(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: theme.colorScheme.primary),
          const SizedBox(height: 28),
          const Text('Analysing speech…', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Checking clarity and accuracy.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor)),
        ],
      ),
    );
  }
}
