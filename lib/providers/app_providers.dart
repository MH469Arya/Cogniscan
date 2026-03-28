import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../models/activity_log.dart';

// Provides the current user profile
class UserNotifier extends Notifier<UserProfile?> {
  @override
  UserProfile? build() => null;

  void setUser(UserProfile? user) {
    state = user;
  }
}

final userProvider = NotifierProvider<UserNotifier, UserProfile?>(() {
  return UserNotifier();
});

// Provides the activity history
final activityLogsProvider = Provider<List<ActivityLog>>((ref) {
  return ActivityLog.mockLogs;
});

// Provides the mock trend data for the chart (last 30 days scores)
final trendDataProvider = Provider<List<double>>((ref) {
  return [
    75.0, 76.5, 76.0, 78.0, 77.5, 79.0, 80.0, 79.5, 81.0, 82.0,
    81.5, 83.0, 82.5, 84.0, 83.5, 84.5, 85.0, 84.0, 86.0, 85.5,
    87.0, 86.5, 88.0, 87.5, 88.5, 89.0, 88.0, 89.5, 90.0, 82.0
  ];
});

class AuthNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    if (email == 'sarth@gmail.com' && password == 'sarth123') {
      ref.read(userProvider.notifier).setUser(UserProfile.mockUser);
      state = true;
      return true;
    }
    return false;
  }

  void logout() {
    ref.read(userProvider.notifier).setUser(null);
    state = false;
  }
}

final authProvider = NotifierProvider<AuthNotifier, bool>(() {
  return AuthNotifier();
});

// Insight scores
final speechScoreProvider = Provider<int>((ref) => 85);
final facialScoreProvider = Provider<int>((ref) => 88);
final tasksScoreProvider = Provider<int>((ref) => 78);
