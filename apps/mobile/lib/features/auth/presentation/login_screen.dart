import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../data/auth_repository_impl.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authRepository = AuthRepositoryImpl();
  bool _isLoading = false;
  bool _showHero = false;
  bool _showCard = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 120), () {
      if (mounted) {
        setState(() => _showHero = true);
      }
    });
    Future.delayed(const Duration(milliseconds: 260), () {
      if (mounted) {
        setState(() => _showCard = true);
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = await _authRepository.login(
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        context.go('/home');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF7F9FC),
                    Color(0xFFE9F7F4),
                    Color(0xFFFDF2E4),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: -120,
            top: -120,
            child: _BlurCircle(
              size: 280,
              color: const Color(0xFF00A896).withOpacity(0.15),
            ),
          ),
          Positioned(
            right: -140,
            bottom: -140,
            child: _BlurCircle(
              size: 320,
              color: const Color(0xFFF0B67F).withOpacity(0.2),
            ),
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 980;
              return Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1100),
                    child: isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: _buildHero(textTheme)),
                              const SizedBox(width: 40),
                              Expanded(child: _buildLoginCard(textTheme)),
                            ],
                          )
                        : Column(
                            children: [
                              _buildHero(textTheme),
                              const SizedBox(height: 32),
                              _buildLoginCard(textTheme),
                            ],
                          ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHero(TextTheme textTheme) {
    return AnimatedOpacity(
      opacity: _showHero ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        offset: _showHero ? Offset.zero : const Offset(0, 0.06),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: Colors.white.withOpacity(0.6)),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.08),
                blurRadius: 30,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const NamaaLogo(size: 72, showText: true),
              const SizedBox(height: 24),
              Text(
                'Ahorra con intención,\ncelebra cada avance.',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Namaa convierte tus metas en un viaje claro: objetivos, progreso y recompensas en un solo lugar.',
                style: textTheme.titleMedium?.copyWith(
                  color: const Color(0xFF475569),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              _FeatureRow(
                icon: Icons.emoji_events_outlined,
                title: 'Metas visibles',
                subtitle: 'Divide tus objetivos en hitos alcanzables.',
              ),
              const SizedBox(height: 12),
              _FeatureRow(
                icon: Icons.insights_outlined,
                title: 'Progreso diario',
                subtitle: 'Visualiza tu racha y evolución en segundos.',
              ),
              const SizedBox(height: 12),
              _FeatureRow(
                icon: Icons.volunteer_activism_outlined,
                title: 'Recompensas reales',
                subtitle: 'Celebra cada aporte con micro-logros.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginCard(TextTheme textTheme) {
    return AnimatedOpacity(
      opacity: _showCard ? 1 : 0,
      duration: const Duration(milliseconds: 500),
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        offset: _showCard ? Offset.zero : const Offset(0, 0.08),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF0F172A).withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Inicia sesión',
                style: textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vuelve a tu dashboard y sigue creciendo tu ahorro.',
                style: textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.mail_outline),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Entrar'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: null,
                child: const Text('Crear cuenta (próximamente)'),
              ),
              const SizedBox(height: 12),
              Text(
                'Al continuar aceptas los términos y políticas de privacidad.',
                style: textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF94A3B8),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  const _FeatureRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF00A896).withOpacity(0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFF028090)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
    );
  }
}
