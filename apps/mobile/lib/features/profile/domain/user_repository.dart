import '../../auth/domain/user.dart';
import 'user_summary.dart';

abstract class UserRepository {
  Future<User> fetchProfile();
  Future<User> updateProfile({String? username, String? profileImageUrl});
  Future<UserSummary> fetchSummary();
  Future<void> addSavingsEntry({
    required double amount,
    required String entryDate,
    String? note,
  });
}
