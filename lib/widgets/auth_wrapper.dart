import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../utils/navigation.dart';

/// Widget wrapper que maneja automáticamente la validación de autenticación
/// Redirige al login si el usuario no está autenticado
class AuthWrapper extends StatefulWidget {
  final Widget child;
  final bool requireAuth;

  const AuthWrapper({
    Key? key,
    required this.child,
    this.requireAuth = true,
  }) : super(key: key);

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  bool _isChecking = true;
  AuthService? _authRef;
  VoidCallback? _authListener;

  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
    // Configurar listener tras el primer frame para tener acceso al context
    WidgetsBinding.instance.addPostFrameCallback((_) => _setupAuthListener());
  }

  void _setupAuthListener() {
    if (!widget.requireAuth) return;
    _authRef = Provider.of<AuthService>(context, listen: false);
    _authListener = () {
      if (!mounted) return;
      if (!_authRef!.isAuthenticated) {
        // Redirigir inmediatamente si se pierde la autenticación
        navigatorKey.currentState?.pushReplacementNamed('/login');
      }
    };
    _authRef!.addListener(_authListener!);
  }

  @override
  void dispose() {
    if (_authRef != null && _authListener != null) {
      _authRef!.removeListener(_authListener!);
    }
    super.dispose();
  }

  Future<void> _checkAuthStatus() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    
    // Validar el token si es requerido
    if (widget.requireAuth) {
      if (!authService.isAuthenticated) {
        // Redirigir al login si no está autenticado
        WidgetsBinding.instance.addPostFrameCallback((_) {
          navigatorKey.currentState?.pushReplacementNamed('/login');
        });
      } else {
        // Verificar con el backend si el token es válido
        final isValid = await authService.verifyTokenWithBackend();
        if (!isValid) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushReplacementNamed('/login');
          });
        }
      }
    }
    
    if (mounted) {
      setState(() {
        _isChecking = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isChecking) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Verificando autenticación...'),
            ],
          ),
        ),
      );
    }

    return Consumer<AuthService>(
      builder: (context, authService, child) {
        // Si no requiere autenticación, mostrar el widget directamente
        if (!widget.requireAuth) {
          return widget.child;
        }

        // Si requiere autenticación pero no está autenticado, programar redirección como respaldo
        if (!authService.isAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            navigatorKey.currentState?.pushReplacementNamed('/login');
          });
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Redirigiendo al login...'),
                ],
              ),
            ),
          );
        }

        // Si está autenticado, mostrar el widget
        return widget.child;
      },
    );
  }
}
