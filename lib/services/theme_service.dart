import 'package:flutter/material.dart';

/// Servicio para manejar el tema de la aplicación
class ThemeService extends ChangeNotifier {
  int _currentThemeIndex = 0;
  
  // Lista de temas disponibles
  final List<Map<String, dynamic>> _themes = [
    {
      'name': 'Morado',
      'primary': const Color(0xFF4A148C),
      'secondary': const Color(0xFF6A1B9A),
      'accent': const Color(0xFF8E24AA),
      'gradient': [
        const Color(0xFF4A148C),
        const Color(0xFF6A1B9A),
        const Color(0xFF8E24AA),
        const Color(0xFFAB47BC),
        const Color(0xFFBA68C8),
      ],
    },
    {
      'name': 'Azul',
      'primary': const Color(0xFF1565C0),
      'secondary': const Color(0xFF1976D2),
      'accent': const Color(0xFF2196F3),
      'gradient': [
        const Color(0xFF1565C0),
        const Color(0xFF1976D2),
        const Color(0xFF2196F3),
        const Color(0xFF42A5F5),
        const Color(0xFF64B5F6),
      ],
    },
    {
      'name': 'Verde',
      'primary': const Color(0xFF2E7D32),
      'secondary': const Color(0xFF388E3C),
      'accent': const Color(0xFF4CAF50),
      'gradient': [
        const Color(0xFF2E7D32),
        const Color(0xFF388E3C),
        const Color(0xFF4CAF50),
        const Color(0xFF66BB6A),
        const Color(0xFF81C784),
      ],
    },
    {
      'name': 'Naranja',
      'primary': const Color(0xFFE65100),
      'secondary': const Color(0xFFF57C00),
      'accent': const Color(0xFFFF9800),
      'gradient': [
        const Color(0xFFE65100),
        const Color(0xFFF57C00),
        const Color(0xFFFF9800),
        const Color(0xFFFFB74D),
        const Color(0xFFFFCC02),
      ],
    },
    {
      'name': 'Rosa',
      'primary': const Color(0xFFC2185B),
      'secondary': const Color(0xFFE91E63),
      'accent': const Color(0xFFF06292),
      'gradient': [
        const Color(0xFFC2185B),
        const Color(0xFFE91E63),
        const Color(0xFFF06292),
        const Color(0xFFF8BBD9),
        const Color(0xFFFCE4EC),
      ],
    },
  ];

  /// Obtiene el tema actual
  Map<String, dynamic> get currentTheme => _themes[_currentThemeIndex];
  
  /// Obtiene el índice del tema actual
  int get currentThemeIndex => _currentThemeIndex;
  
  /// Obtiene todos los temas disponibles
  List<Map<String, dynamic>> get themes => _themes;

  /// Cambia el tema actual
  void setTheme(int index) {
    if (index >= 0 && index < _themes.length) {
      _currentThemeIndex = index;
      notifyListeners();
    }
  }

  /// Obtiene el color primario del tema actual
  Color get primaryColor => currentTheme['primary'];
  
  /// Obtiene el color secundario del tema actual
  Color get secondaryColor => currentTheme['secondary'];
  
  /// Obtiene el color de acento del tema actual
  Color get accentColor => currentTheme['accent'];
  
  /// Obtiene los colores del gradiente del tema actual
  List<Color> get gradientColors => List<Color>.from(currentTheme['gradient']);
}
