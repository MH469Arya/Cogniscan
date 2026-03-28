import 'package:flutter/material.dart';
import 'login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildHero(context, theme, size),
          _buildProblem(context, theme),
          _buildSolution(context, theme),
          _buildHowItWorks(context, theme),
          _buildFeatures(context, theme),
          _buildCTA(context, theme),
          _buildFooter(context, theme),
        ],
      ),
    );
  }

  Widget _buildHero(BuildContext context, ThemeData theme, Size size) {
    return SliverToBoxAdapter(
      child: Container(
        height: size.height * 0.9,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 60),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary.withOpacity(0.05),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Healthcare + AI'.toUpperCase(),
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Detect Cognitive Decline Before It’s Too Late',
              textAlign: TextAlign.center,
              style: theme.textTheme.displayLarge?.copyWith(
                fontSize: 40,
                color: theme.colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Cogniscan uses AI to analyze speech, facial expressions, and cognitive behavior—enabling early detection and timely intervention.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.hintColor,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Designed for real-world use, even in low-resource environments.',
                style: TextStyle(
                  color: theme.colorScheme.secondary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 48),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: const Text('Get Started', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
                    side: BorderSide(color: theme.colorScheme.primary, width: 2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  ),
                  child: Text('Login', style: TextStyle(color: theme.colorScheme.primary, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProblem(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(40),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.2),
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
            image: AssetImage('assets/images/bg/bg1.png'),
            fit: BoxFit.cover,
            opacity: 0.1, // So text is readable
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'The Problem We’re Solving', 
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineLarge,
            ),
            const SizedBox(height: 24),
            Text(
              'Cognitive health is often ignored until it becomes a crisis. Current diagnostic barriers leave millions without a path to early treatment.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
            ),
            const SizedBox(height: 40),
            // Centered Problem Points
            const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   _ProblemPoint(text: 'Dementia is detected too late'),
                   _ProblemPoint(text: 'Traditional methods are slow and manual'),
                   _ProblemPoint(text: 'Lack of access in low-resource rural areas'),
                   _ProblemPoint(text: 'Caregivers miss early warning signs'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Text(
              '"By the time symptoms are visible, intervention opportunities are limited."',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSolution(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
        child: Column(
          children: [
            Text('Meet Cogniscan', style: theme.textTheme.displayMedium),
            const SizedBox(height: 16),
            Text(
              'A multimodal AI system that evaluates cognitive health using behavioral signals.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor, fontSize: 20),
            ),
            const SizedBox(height: 48),
            Row(
              children: [
                Expanded(child: _SolutionCard(number: '01', title: 'Early Detection', description: 'Spots subtle patterns before symptoms.', theme: theme)),
                const SizedBox(width: 16),
                Expanded(child: _SolutionCard(number: '02', title: 'Continuous', description: 'Dynamic view of cognitive health.', theme: theme)),
              ],
            ),
            const SizedBox(height: 16),
            _SolutionCard(number: '03', title: 'Accessible', description: 'Works anywhere with minimal internet.', theme: theme, isFullWidth: true),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorks(BuildContext context, ThemeData theme) {
    return SliverPadding(
      padding: const EdgeInsets.all(24),
      sliver: SliverList(
        delegate: SliverChildListDelegate([
          Center(child: Text('How It Works', style: theme.textTheme.displayMedium)),
          const SizedBox(height: 48),
          _HowItWorksCard(icon: Icons.mic, title: 'Speech Analysis', description: 'Detects hesitation and memory gaps.', color: theme.colorScheme.primary),
          _HowItWorksCard(icon: Icons.face, title: 'Facial Recognition', description: 'Identifies micro-signals of stress.', color: theme.colorScheme.secondary),
          _HowItWorksCard(icon: Icons.psychology, title: 'Task Monitoring', description: 'Tracks reaction speed and accuracy.', color: theme.colorScheme.primary),
          _HowItWorksCard(icon: Icons.bar_chart, title: 'AI Risk Scoring', description: 'Aggregates signals into a health score.', color: theme.colorScheme.secondary),
        ]),
      ),
    );
  }

  Widget _buildFeatures(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(40),
        color: theme.colorScheme.primary, // Dark Teal from theme
        child: Column(
          children: [
            Text('Built for Impact', style: theme.textTheme.displayMedium?.copyWith(color: Colors.white)),
            const SizedBox(height: 48),
            _FeatureRow(icon: Icons.offline_bolt, title: 'Low-Resource Tech', text: 'Works on basic hardware/bandwidth.', color: theme.colorScheme.primary),
            _FeatureRow(icon: Icons.notifications_active, title: 'Caregiver Alerts', text: 'Instant risk notifications.', color: theme.colorScheme.secondary),
            _FeatureRow(icon: Icons.lock, title: 'Privacy Focused', text: 'Secure data handling.', color: Colors.tealAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildCTA(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(48),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Column(
          children: [
            const Text(
              'Start Early. Act Smarter.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
              child: const Text('Try Cogniscan Free', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
        child: Column(
          children: [
            const Divider(),
            const SizedBox(height: 16),
            Text('© 2026 Cogniscan AI. All rights reserved.', style: theme.textTheme.bodySmall),
          ],
        ),
      ),
    );
  }
}

class _ProblemPoint extends StatelessWidget {
  final String text;
  const _ProblemPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Center-able in a Column
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
        ],
      ),
    );
  }
}

class _SolutionCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;
  final ThemeData theme;
  final bool isFullWidth;

  const _SolutionCard({
    required this.number,
    required this.title,
    required this.description,
    required this.theme,
    this.isFullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isFullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.surface),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(number, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: theme.colorScheme.primary.withOpacity(0.1))),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(description, style: TextStyle(color: theme.hintColor)),
        ],
      ),
    );
  }
}

class _HowItWorksCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _HowItWorksCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [BoxShadow(color: color.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(15)),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(description, style: const TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String text;
  final Color color;

  const _FeatureRow({required this.icon, required this.title, required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text(text, style: TextStyle(color: Colors.white.withOpacity(0.7))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
