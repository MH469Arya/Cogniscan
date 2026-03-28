class UserProfile {
  final String id;
  final String name;
  final int age;
  final String email;
  final int currentScore;
  final String avatarUrl;

  UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.email,
    required this.currentScore,
    required this.avatarUrl,
  });

  // Mock initial user
  static UserProfile get mockUser => UserProfile(
    id: 'u_123',
    name: 'Sarth',
    age: 72,
    email: 'sarth@gmail.com',
    currentScore: 82,
    avatarUrl: 'https://i.pravatar.cc/150?u=sarth',
  );
}
