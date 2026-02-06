import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(const NamaaApp());
}

class NamaaApp extends StatelessWidget {
  const NamaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Namaa',
      theme: AppTheme.lightTheme,
      home: const Scaffold(
        body: Center(child: Text('Welcome to Namaa')),
      ),
    );
  }
}
