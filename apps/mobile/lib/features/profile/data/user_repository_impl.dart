import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/api_config.dart';
import '../../../core/services/session_store.dart';
import '../../auth/domain/user.dart';
import '../domain/user_repository.dart';
import '../domain/user_summary.dart';

class UserRepositoryImpl implements UserRepository {
  final String baseUrl;

  UserRepositoryImpl({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.baseUrl;

  @override
  Future<User> fetchProfile() async {
    final token = SessionStore.token;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return _userFromJson(data);
    }
    throw Exception('Failed to load profile: ${response.body}');
  }

  @override
  Future<User> updateProfile({String? username, String? profileImageUrl}) async {
    final token = SessionStore.token;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final payload = <String, dynamic>{};
    if (username != null) payload['username'] = username;
    if (profileImageUrl != null) payload['profileImageUrl'] = profileImageUrl;

    final response = await http.patch(
      Uri.parse('$baseUrl/users/me'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return _userFromJson(data);
    }
    throw Exception('Failed to update profile: ${response.body}');
  }

  @override
  Future<UserSummary> fetchSummary() async {
    final token = SessionStore.token;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/users/me/summary'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final weeklyRaw = (data['weeklyTotals'] as List<dynamic>? ?? [])
          .map((item) => WeeklyTotal(
                date: item['date'] as String? ?? '',
                amount: _toDouble(item['amount']),
              ))
          .toList();
      return UserSummary(
        totalSaved: _toDouble(data['totalSaved']),
        totalTarget: _toDouble(data['totalTarget']),
        progressRatio: _toDouble(data['progressRatio']),
        activeGoals: (data['activeGoals'] ?? 0) as int,
        completedGoals: (data['completedGoals'] ?? 0) as int,
        nextDeadline: data['nextDeadline'] as String?,
        streakCount: (data['streakCount'] ?? 0) as int,
        weeklyTotals: weeklyRaw,
      );
    }
    throw Exception('Failed to load summary: ${response.body}');
  }

  @override
  Future<void> addSavingsEntry({
    required double amount,
    required String entryDate,
    String? note,
  }) async {
    final token = SessionStore.token;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/savings'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'amount': amount,
        'entryDate': entryDate,
        'note': note,
      }),
    );

    if (response.statusCode == 201) {
      return;
    }
    throw Exception('Failed to save savings: ${response.body}');
  }

  User _userFromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      streakCount: (json['streakCount'] ?? 0) as int,
      totalSaved: _toDouble(json['totalSaved']),
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
