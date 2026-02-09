import 'goal.dart';

abstract class GoalsRepository {
  Future<List<Goal>> fetchGoals();
  Future<Goal> createGoal({
    required String title,
    required double targetAmount,
    required double currentAmount,
    required DateTime deadline,
    required String imageUrl,
  });

  Future<Goal> updateGoal({
    required String id,
    String? title,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? imageUrl,
  });

  Future<void> deleteGoal(String id);
}
