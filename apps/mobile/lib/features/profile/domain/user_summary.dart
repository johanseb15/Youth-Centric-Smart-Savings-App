class UserSummary {
  const UserSummary({
    required this.totalSaved,
    required this.totalTarget,
    required this.progressRatio,
    required this.activeGoals,
    required this.completedGoals,
    required this.nextDeadline,
    required this.streakCount,
    required this.weeklyTotals,
  });

  final double totalSaved;
  final double totalTarget;
  final double progressRatio;
  final int activeGoals;
  final int completedGoals;
  final String? nextDeadline;
  final int streakCount;
  final List<WeeklyTotal> weeklyTotals;
}

class WeeklyTotal {
  const WeeklyTotal({required this.date, required this.amount});

  final String date;
  final double amount;
}
