abstract class AuthRepository {
  Future<User> register(String email, String username, String password);
  Future<User> login(String email, String password);
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<String?> getStoredToken();
  Future<void> saveToken(String token);
}
