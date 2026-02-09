import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../core/services/api_config.dart';
import '../../../core/services/session_store.dart';
import '../domain/goal.dart';
import '../domain/goals_repository.dart';

class GoalsRepositoryImpl implements GoalsRepository {
  final String baseUrl;

  GoalsRepositoryImpl({String? baseUrl}) : baseUrl = baseUrl ?? ApiConfig.baseUrl;

  @override
  Future<List<Goal>> fetchGoals() async {
    final token = SessionStore.token;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/goals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((item) => _goalFromJson(item as Map<String, dynamic>)).toList();
    }

    throw Exception('Failed to load goals: ${response.body}');
  }

  @override
  Future<Goal> createGoal({
    required String title,
    required double targetAmount,
    required double currentAmount,
    required DateTime deadline,
    required String imageUrl,
  }) async {
    final token = SessionStore.token;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/goals'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'title': title,
        'targetAmount': targetAmount,
        'currentAmount': currentAmount,
        'deadline': deadline.toIso8601String().split('T').first,
        'imageUrl': imageUrl,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return _goalFromJson(data);
    }

    throw Exception('Failed to create goal: ${response.body}');
  }

  @override
  Future<Goal> updateGoal({
    required String id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? imageUrl,
  }) async {
    final token = SessionStore.token;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final payload = <String, dynamic>{};
    if (title != null) payload['title'] = title;
    if (targetAmount != null) payload['targetAmount'] = targetAmount;
    if (currentAmount != null) payload['currentAmount'] = currentAmount;
    if (deadline != null) payload['deadline'] = deadline.toIso8601String().split('T').first;
    if (imageUrl != null) payload['imageUrl'] = imageUrl;

    final response = await http.patch(
      Uri.parse('$baseUrl/goals/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(payload),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return _goalFromJson(data);
    }

    throw Exception('Failed to update goal: ${response.body}');
  }

  @override
  Future<void> deleteGoal(String id) async {
    final token = SessionStore.token;
    if (token == null || token.isEmpty) {
      throw Exception('Not authenticated');
    }

    final response = await http.delete(
      Uri.parse('$baseUrl/goals/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return;
    }

    throw Exception('Failed to delete goal: ${response.body}');
  }

  Goal _goalFromJson(Map<String, dynamic> json) {
    final target = _toDouble(json['targetAmount']);
    final current = _toDouble(json['currentAmount']);
    return Goal(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      targetAmount: target,
      currentAmount: current,
      deadline: DateTime.parse(json['deadline'] ?? DateTime.now().toIso8601String()),
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  double _toDouble(dynamic value) {
    if (value == null) return 0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
