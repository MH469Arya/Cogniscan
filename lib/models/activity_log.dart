class ActivityLog {
  final String id;
  final DateTime date;
  final String testName;
  final int score;
  final String status;

  ActivityLog({
    required this.id,
    required this.date,
    required this.testName,
    required this.score,
    required this.status,
  });

  static List<ActivityLog> get mockLogs => [
    ActivityLog(
      id: 'a_1',
      date: DateTime.now().subtract(const Duration(days: 1)),
      testName: 'Morning Cognitive Check',
      score: 85,
      status: 'excellent',
    ),
    ActivityLog(
      id: 'a_2',
      date: DateTime.now().subtract(const Duration(days: 3)),
      testName: 'Speech Pattern Analysis',
      score: 78,
      status: 'good',
    ),
    ActivityLog(
      id: 'a_3',
      date: DateTime.now().subtract(const Duration(days: 5)),
      testName: 'Memory Recall Game',
      score: 81,
      status: 'good',
    ),
    ActivityLog(
      id: 'a_4',
      date: DateTime.now().subtract(const Duration(days: 7)),
      testName: 'Facial Expression Sync',
      score: 88,
      status: 'excellent',
    ),
  ];
}
