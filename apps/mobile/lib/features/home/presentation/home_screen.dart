import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/services/session_store.dart';
import '../../auth/domain/user.dart';
import '../../goals/data/goals_repository_impl.dart';
import '../../goals/domain/goal.dart';
import '../../profile/data/user_repository_impl.dart';
import '../../profile/domain/user_summary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _goalsRepository = GoalsRepositoryImpl();
  final _userRepository = UserRepositoryImpl();

  late Future<List<Goal>> _goalsFuture;
  late Future<User> _profileFuture;
  late Future<UserSummary> _summaryFuture;

  final _goalTitleController = TextEditingController();
  final _targetController = TextEditingController();
  final _currentController = TextEditingController(text: '0');
  final _deadlineController = TextEditingController();
  final _imageController = TextEditingController();

  final _profileNameController = TextEditingController();
  final _profileAvatarController = TextEditingController();
  final _savingsAmountController = TextEditingController();
  final _savingsDateController = TextEditingController();
  final _savingsNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _goalsFuture = _goalsRepository.fetchGoals();
    _profileFuture = _userRepository.fetchProfile();
    _summaryFuture = _userRepository.fetchSummary();
  }

  @override
  void dispose() {
    _goalTitleController.dispose();
    _targetController.dispose();
    _currentController.dispose();
    _deadlineController.dispose();
    _imageController.dispose();
    _profileNameController.dispose();
    _profileAvatarController.dispose();
    _savingsAmountController.dispose();
    _savingsDateController.dispose();
    _savingsNoteController.dispose();
    super.dispose();
  }

  Future<void> _refreshGoals() async {
    setState(() {
      _goalsFuture = _goalsRepository.fetchGoals();
      _summaryFuture = _userRepository.fetchSummary();
    });
  }

  Future<void> _refreshProfile() async {
    setState(() {
      _profileFuture = _userRepository.fetchProfile();
    });
  }

  Future<void> _openEditProfileDialog(User user) async {
    _profileNameController.text = user.username;
    _profileAvatarController.text = user.profileImageUrl ?? '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar perfil'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _profileNameController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _profileAvatarController,
                decoration: const InputDecoration(labelText: 'Avatar URL'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (confirmed != true) return;

    final name = _profileNameController.text.trim();
    final avatar = _profileAvatarController.text.trim();

    if (name.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El nombre no puede estar vacio')),
        );
      }
      return;
    }

    try {
      await _userRepository.updateProfile(
        username: name,
        profileImageUrl: avatar.isEmpty ? null : avatar,
      );
      await _refreshProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error actualizando perfil: $e')),
        );
      }
    }
  }

  Future<void> _openCreateGoalDialog({Goal? goal}) async {
    final isEdit = goal != null;
    _goalTitleController.text = goal?.title ?? '';
    _targetController.text = goal?.targetAmount.toStringAsFixed(0) ?? '';
    _currentController.text = goal?.currentAmount.toStringAsFixed(0) ?? '0';
    _deadlineController.text =
        goal != null ? goal.deadline.toIso8601String().split('T').first : '';
    _imageController.text = goal?.imageUrl ?? '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(isEdit ? 'Editar meta' : 'Nueva meta'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _goalTitleController,
                  decoration: const InputDecoration(labelText: 'Titulo'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _targetController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Objetivo (monto)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _currentController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Actual (monto)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _deadlineController,
                  decoration: const InputDecoration(labelText: 'Deadline (YYYY-MM-DD)'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _imageController,
                  decoration: const InputDecoration(labelText: 'Imagen URL'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(isEdit ? 'Guardar' : 'Crear'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (confirmed != true) return;

    final title = _goalTitleController.text.trim();
    final target = double.tryParse(_targetController.text.trim()) ?? 0;
    final current = double.tryParse(_currentController.text.trim()) ?? 0;
    final deadline = DateTime.tryParse(_deadlineController.text.trim()) ??
        DateTime.now().add(const Duration(days: 30));
    final image = _imageController.text.trim().isEmpty
        ? 'https://images.unsplash.com/photo-1522202176988-66273c2fd55f'
        : _imageController.text.trim();

    if (title.isEmpty || target <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa el titulo y el objetivo')),
        );
      }
      return;
    }

    try {
      if (isEdit) {
        final goalId = goal.id;
        await _goalsRepository.updateGoal(
          id: goalId,
          title: title,
          targetAmount: target,
          currentAmount: current,
          deadline: deadline,
          imageUrl: image,
        );
      } else {
        await _goalsRepository.createGoal(
          title: title,
          targetAmount: target,
          currentAmount: current,
          deadline: deadline,
          imageUrl: image,
        );
      }
      await _refreshGoals();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creando meta: $e')),
        );
      }
    }
  }

  Future<void> _confirmDeleteGoal(Goal goal) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar meta'),
          content: Text('Seguro que deseas eliminar "${goal.title}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (confirm != true) return;
    try {
      await _goalsRepository.deleteGoal(goal.id);
      await _refreshGoals();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error eliminando meta: $e')),
        );
      }
    }
  }

  Future<void> _openAddSavingsDialog() async {
    _savingsAmountController.text = '';
    _savingsDateController.text =
        DateTime.now().toIso8601String().split('T').first;
    _savingsNoteController.text = '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Agregar ahorro'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _savingsAmountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Monto'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _savingsDateController,
                decoration: const InputDecoration(labelText: 'Fecha (YYYY-MM-DD)'),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _savingsNoteController,
                decoration: const InputDecoration(labelText: 'Nota (opcional)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );

    if (!mounted) return;
    if (confirmed != true) return;

    final amount = double.tryParse(_savingsAmountController.text.trim()) ?? 0;
    final date = _savingsDateController.text.trim();
    final note = _savingsNoteController.text.trim();

    if (amount <= 0 || date.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Completa monto y fecha')),
        );
      }
      return;
    }

    try {
      await _userRepository.addSavingsEntry(
        amount: amount,
        entryDate: date,
        note: note.isEmpty ? null : note,
      );
      await _refreshGoals();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error guardando ahorro: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Namaa Dashboard'),
        actions: [
          IconButton(
            tooltip: 'Nueva meta',
            onPressed: _openCreateGoalDialog,
            icon: const Icon(Icons.add),
          ),
          IconButton(
            tooltip: 'Cerrar sesion',
            onPressed: () async {
              await SessionStore.setToken(null);
              if (!context.mounted) return;
              context.go('/login');
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _openCreateGoalDialog,
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<UserSummary>(
              future: _summaryFuture,
              builder: (context, snapshot) {
                final summary = snapshot.data;
                final total = summary?.totalSaved ?? 0;
                return Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF00A896),
                        Color(0xFF028090),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withOpacity(0.12),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FutureBuilder<User>(
                        future: _profileFuture,
                        builder: (context, userSnap) {
                          final user = userSnap.data;
                          return Row(
                            children: [
                              Builder(
                                builder: (context) {
                                  final avatarUrl = user?.profileImageUrl ?? '';
                                  final hasAvatar = avatarUrl.isNotEmpty;
                                  return CircleAvatar(
                                    radius: 24,
                                    backgroundColor: Colors.white24,
                                    backgroundImage:
                                        hasAvatar ? NetworkImage(avatarUrl) : null,
                                    child: hasAvatar
                                        ? null
                                        : const Icon(Icons.person, color: Colors.white),
                                  );
                                },
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hola, ${user?.username ?? 'Namaa'}',
                                      style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      'Racha: ${summary?.streakCount ?? 0} dias',
                                      style: textTheme.bodySmall?.copyWith(
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed:
                                    user == null ? null : () => _openEditProfileDialog(user),
                                icon: const Icon(Icons.edit, color: Colors.white),
                              ),
                              IconButton(
                                onPressed: _openAddSavingsDialog,
                                icon: const Icon(Icons.savings_outlined, color: Colors.white),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tu ahorro total',
                        style: textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '\$ ${total.toStringAsFixed(2)}',
                        style: textTheme.displaySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            FutureBuilder<UserSummary>(
              future: _summaryFuture,
              builder: (context, snapshot) {
                final summary = snapshot.data;
                return Row(
                  children: [
                    Expanded(
                      child: _StatCard(
                        label: 'Progreso total',
                        value:
                            '${((summary?.progressRatio ?? 0) * 100).clamp(0, 100).toStringAsFixed(0)}%',
                        icon: Icons.insights_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Metas activas',
                        value: '${summary?.activeGoals ?? 0}',
                        icon: Icons.flag_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _StatCard(
                        label: 'Completadas',
                        value: '${summary?.completedGoals ?? 0}',
                        icon: Icons.emoji_events_outlined,
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 16),
            FutureBuilder<UserSummary>(
              future: _summaryFuture,
              builder: (context, snapshot) {
                final weekly = snapshot.data?.weeklyTotals ?? const <WeeklyTotal>[];
                return _WeeklyChart(points: weekly);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'Metas activas',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<Goal>>(
              future: _goalsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return _EmptyState(
                    title: 'No pudimos cargar tus metas',
                    subtitle: 'Verifica tu sesion o intenta de nuevo.',
                    icon: Icons.error_outline,
                  );
                }

                final goals = snapshot.data ?? [];
                if (goals.isEmpty) {
                  return const _EmptyState(
                    title: 'Aun no tienes metas',
                    subtitle: 'Crea tu primera meta para empezar.',
                    icon: Icons.emoji_events_outlined,
                  );
                }

                return Column(
                  children: goals
                      .map(
                        (goal) => _GoalCard(
                          title: goal.title,
                          progress: goal.targetAmount == 0
                              ? 0
                              : (goal.currentAmount / goal.targetAmount).clamp(0, 1),
                          current: goal.currentAmount,
                          target: goal.targetAmount,
                          onEdit: () => _openCreateGoalDialog(goal: goal),
                          onDelete: () => _confirmDeleteGoal(goal),
                        ),
                      )
                      .toList(),
                );
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Recomendado hoy',
              style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0F172A).withOpacity(0.06),
                    blurRadius: 18,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0B67F).withOpacity(0.25),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.lightbulb_outline, color: Color(0xFFB45309)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Programa una transferencia automatica para proteger tu meta principal.',
                      style: textTheme.bodyMedium?.copyWith(color: const Color(0xFF475569)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF028090)),
          const SizedBox(height: 8),
          Text(
            value,
            style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _WeeklyChart extends StatelessWidget {
  const _WeeklyChart({required this.points});

  final List<WeeklyTotal> points;

  @override
  Widget build(BuildContext context) {
    final max = points.isNotEmpty
        ? points.map((p) => p.amount).reduce((a, b) => a > b ? a : b)
        : 0;
    final normalizedMax = max <= 0 ? 1 : max;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ahorro semanal',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: points.isEmpty
                ? [
                    const Expanded(
                      child: Text('Sin datos para esta semana'),
                    ),
                  ]
                : points
                    .map(
                      (point) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: 80 * (point.amount / normalizedMax),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00A896),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                point.date.length >= 5 ? point.date.substring(5) : point.date,
                                style: const TextStyle(fontSize: 10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
          ),
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.title,
    required this.progress,
    required this.current,
    required this.target,
    required this.onEdit,
    required this.onDelete,
  });

  final String title;
  final double progress;
  final double current;
  final double target;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
              IconButton(
                tooltip: 'Editar',
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 20),
              ),
              IconButton(
                tooltip: 'Eliminar',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: const Color(0xFFE2E8F0),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF00A896)),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            '\$${current.toStringAsFixed(0)} de \$${target.toStringAsFixed(0)}',
            style: textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color(0xFF00A896).withOpacity(0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: const Color(0xFF028090)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  subtitle,
                  style: textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
