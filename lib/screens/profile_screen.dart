import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/app_providers.dart';
import 'login_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final theme = Theme.of(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: Text('Not logged in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          Center(
            child: CircleAvatar(
              radius: 60,
              backgroundColor: theme.colorScheme.secondary,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              user.name,
              style: theme.textTheme.displayMedium,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              '${user.age} years old • ${user.email}',
              style: theme.textTheme.titleLarge?.copyWith(color: theme.colorScheme.secondary),
            ),
          ),
          const SizedBox(height: 48),
          
          _buildSettingsTile(context, Icons.notifications_active, 'Notifications', () {}),
          _buildSettingsTile(context, Icons.medical_services, 'Caregiver Contacts', () {}),
          _buildSettingsTile(context, Icons.privacy_tip, 'Privacy Settings', () {}),
          _buildSettingsTile(context, Icons.help, 'Help & Support', () {}),
          
          const SizedBox(height: 32),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.scaffoldBackgroundColor,
              foregroundColor: theme.colorScheme.error,
              side: BorderSide(color: theme.colorScheme.error),
            ),
            onPressed: () {
              ref.read(authProvider.notifier).logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
        title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
