import 'package:flutter/material.dart';

/// Servicio para manejar el tema de la aplicación
class ThemeService extends ChangeNotifier {
  int _currentThemeIndex = 0;
  
  // Lista de temas disponibles
  final List<Map<String, dynamic>> _themes = [
    {
      'name': 'Morado',
      'primary': Color(0xFF4A148C),
      'secondary': Color(0xFF6A1B9A),
      'accent': Color(0xFF8E24AA),
      'gradient': [
        Color(0xFF4A148C),
        Color(0xFF6A1B9A),
        Color(0xFF8E24AA),
        Color(0xFFAB47BC),
        Color(0xFFBA68C8),
      ],
    },
    {
      'name': 'Azul',
      'primary': Color(0xFF1565C0),
      'secondary': Color(0xFF1976D2),
      'accent': Color(0xFF2196F3),
      'gradient': [
        Color(0xFF1565C0),
        Color(0xFF1976D2),
        Color(0xFF2196F3),
        Color(0xFF42A5F5),
        Color(0xFF64B5F6),
      ],
    },
    {
      'name': 'Verde',
      'primary': Color(0xFF2E7D32),
      'secondary': Color(0xFF388E3C),
      'accent': Color(0xFF4CAF50),
      'gradient': [
        Color(0xFF2E7D32),
        Color(0xFF388E3C),
        Color(0xFF4CAF50),
        Color(0xFF66BB6A),
        Color(0xFF81C784),
      ],
    },
    {
      'name': 'Naranja',
      'primary': Color(0xFFE65100),
      'secondary': Color(0xFFF57C00),
      'accent': Color(0xFFFF9800),
      'gradient': [
        Color(0xFFE65100),
        Color(0xFFF57C00),
        Color(0xFFFF9800),
        Color(0xFFFFB74D),
        Color(0xFFFFCC02),
      ],
    },
    {
      'name': 'Rosa',
      'primary': Color(0xFFC2185B),
      'secondary': Color(0xFFE91E63),
      'accent': Color(0xFFF06292),
      'gradient': [
        Color(0xFFC2185B),
        Color(0xFFE91E63),
        Color(0xFFF06292),
        Color(0xFFF8BBD9),
        Color(0xFFFCE4EC),
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
