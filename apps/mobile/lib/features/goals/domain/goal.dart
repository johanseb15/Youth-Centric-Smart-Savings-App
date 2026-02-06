/// Modelo base de meta de ahorro.
class Goal {
  const Goal({
    required this.id,
    required this.title,
    required this.targetAmount,
    required this.currentAmount,
    required this.deadline,
    required this.imageUrl,
  });

  final String id;
  final String title;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String imageUrl;
}
