import 'dart:convert';
import 'package:http/http.dart' as http;
import '../domain/user.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final String baseUrl;
  String? _token;

  AuthRepositoryImpl({this.baseUrl = 'http://localhost:3000/api'});

  @override
  Future<User> register(String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      _token = data['access_token'];
      return _userFromJson(data['user']);
    } else {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  @override
  Future<User> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _token = data['access_token'];
      return _userFromJson(data['user']);
    } else {
      throw Exception('Failed to login: ${response.body}');
    }
  }

  @override
  Future<void> logout() async {
    _token = null;
  }

  @override
  Future<User?> getCurrentUser() async {
    // Implementar fetch de usuario actual
    return null;
  }

  @override
  Future<String?> getStoredToken() async {
    return _token;
  }

  @override
  Future<void> saveToken(String token) async {
    _token = token;
  }

  User _userFromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      streakCount: 0,
      totalSaved: 0.0,
      profileImageUrl: json['profileImageUrl'],
      createdAt: DateTime.now(),
    );
  }
}
