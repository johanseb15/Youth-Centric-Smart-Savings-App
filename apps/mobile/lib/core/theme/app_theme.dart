import 'package:flutter/material.dart';

/// Tema principal de Namaa con identidad visual definida.
class AppTheme {
  const AppTheme._();

  /// Colores principales
  static const Color _primary = Color(0xFF00A896); // Verde Crecimiento
  static const Color _secondary = Color(0xFF028090); // Azul Confianza
  static const Color _accent = Color(0xFFF0B67F); // Amarillo Recompensa        
  static const Color _background = Color(0xFFF8FAFC); // Fondo blanco roto      
  static const Color _surface = Color(0xFFFFFFFF);
  static const Color _error = Color(0xFFEF4444);

  /// ThemeData personalizado para toda la app
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Plus Jakarta Sans',

      // Colores base
      colorScheme: const ColorScheme.light(
        primary: _primary,
        secondary: _secondary,
        tertiary: _accent,
        surface: _surface,
        error: _error,
      ),

      scaffoldBackgroundColor: _background,

      // AppBar personalizado
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: _background,
        foregroundColor: Color(0xFF1E293B),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Plus Jakarta Sans',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),

      // Botones con bordes redondeados
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: _primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),    
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          elevation: 0,
          foregroundColor: _primary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),    
          side: const BorderSide(color: _primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            fontFamily: 'Plus Jakarta Sans',
          ),
        ),
      ),

      // Cards con sombras sutiles
      cardTheme: CardTheme(
        elevation: 0,
        color: _surface,
        shadowColor: Colors.black.withOpacity(0.05),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),        
      ),

      // Input fields
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: _error, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14)
,                                                                                     ),

      // Bottom Navigation Bar
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        backgroundColor: _surface,
        selectedItemColor: _primary,
        unselectedItemColor: Color(0xFF94A3B8),
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}

/// Widget del logo de Namaa con degradado circular
class NamaaLogo extends StatelessWidget {
  const NamaaLogo({
    super.key,
    this.size = 80,
    this.showText = false,
  });

  final double size;
  final bool showText;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00A896), // Primary
                Color(0xFF028090), // Secondary
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF00A896).withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              'N',
              style: TextStyle(
                fontSize: size * 0.5,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 16),
          const Text(
            'Namaa',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
              fontFamily: 'Plus Jakarta Sans',
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Grow your savings',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              fontFamily: 'Plus Jakarta Sans',
            ),
          ),
        ],
      ],
    );
  }
}
