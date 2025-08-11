import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/navigation.dart';

/// Utilidades para manejar la autenticación en las pantallas
class AuthUtils {
  /// Verifica si el usuario está autenticado y redirige al login si no lo está
  static Future<bool> checkAuthAndRedirect(BuildContext context) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    if (!authService.isAuthenticated) {
      _showAuthDialog(context, 'Sesión expirada', 'Por favor, inicia sesión nuevamente.');
      return false;
    }
    
    // Verificar con el backend
    final isValid = await authService.verifyTokenWithBackend();
    if (!isValid) {
      _showAuthDialog(context, 'Token inválido', 'Tu sesión ha expirado. Por favor, inicia sesión nuevamente.');
      return false;
    }
    
    return true;
  }

  /// Muestra un diálogo de autenticación y redirige al login
  static void _showAuthDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              navigatorKey.currentState?.pushReplacementNamed('/login');
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Maneja errores de autenticación en operaciones
  static void handleAuthError(BuildContext context, dynamic error) {
    if (error.toString().contains('Token') || 
        error.toString().contains('Sesión') ||
        error.toString().contains('401')) {
      final authService = Provider.of<AuthService>(context, listen: false);
      authService.logout();
      _showAuthDialog(context, 'Error de autenticación', 'Por favor, inicia sesión nuevamente.');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  /// Verifica la autenticación antes de ejecutar una operación
  static Future<T?> withAuthCheck<T>(
    BuildContext context,
    Future<T> Function() operation,
  ) async {
    if (!await checkAuthAndRedirect(context)) {
      return null;
    }
    
    try {
      return await operation();
    } catch (e) {
      handleAuthError(context, e);
      return null;
    }
  }
}
