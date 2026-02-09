import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/services/session_store.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/presentation/login_screen.dart';
import 'features/home/presentation/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SessionStore.init();
  runApp(const NamaaApp());
}

class NamaaApp extends StatelessWidget {
  const NamaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: SessionStore.isAuthenticated ? '/home' : '/login',
      routes: [
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: '/home',
          name: 'home',
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );

    return MaterialApp.router(
      title: 'Namaa',
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}
