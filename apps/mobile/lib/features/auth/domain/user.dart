/// Modelo de usuario para la app Namaa
class User {
  const User({
    required this.id,
    required this.email,
    required this.username,
    required this.streakCount,
    required this.totalSaved,
    required this.profileImageUrl,
    required this.createdAt,
  });

  final String id;
  final String email;
  final String username;
  final int streakCount;
  final double totalSaved;
  final String? profileImageUrl;
  final DateTime createdAt;

  /// Retorna una copia con ciertos campos actualizados
  User copyWith({
    String? id,
    String? email,
    String? username,
    int? streakCount,
    double? totalSaved,
    String? profileImageUrl,
    DateTime? createdAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      streakCount: streakCount ?? this.streakCount,
      totalSaved: totalSaved ?? this.totalSaved,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
